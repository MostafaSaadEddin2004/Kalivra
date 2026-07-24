import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';
import 'package:kalivra/view/widgets/cart/quantity_counter.dart';

class CartItemEditDialog extends StatefulWidget {
  const CartItemEditDialog({super.key, required this.item})
    : product = null,
      initialSize = null,
      initialColor = null;

  const CartItemEditDialog.add({
    super.key,
    required this.product,
    this.initialSize,
    this.initialColor,
  }) : item = null;

  final CartItemApiModel? item;
  final ProductModel? product;
  final VariantBySize? initialSize;
  final ColorVariant? initialColor;

  @override
  State<CartItemEditDialog> createState() => _CartItemEditDialogState();
}

class _CartItemEditDialogState extends State<CartItemEditDialog> {
  late final int _originalQuantity;
  late final int? _originalColorOptionId;
  late final int? _originalSizeOptionId;

  ProductModel? _product;
  VariantBySize? _selectedSize;
  ColorVariant? _selectedColor;
  late int _quantity;
  bool _isLoadingProduct = true;
  bool _isSaving = false;
  String? _errorText;

  bool get _isAddMode => widget.item == null;

  @override
  void initState() {
    super.initState();
    final item = widget.item;
    _originalQuantity = item?.quantity ?? 1;
    _originalColorOptionId = item?.colorOption?.optionId;
    _originalSizeOptionId = item?.sizeOption?.optionId;
    _quantity = _originalQuantity;

    if (_isAddMode) {
      _product = widget.product;
      _selectedSize = _findSelectedSize(_product);
      _selectedColor = _findSelectedColor(_selectedSize);
      _normalizeQuantity();
      _isLoadingProduct = false;
    } else {
      _loadProductOptions();
    }
  }

  Future<void> _loadProductOptions() async {
    final item = widget.item;
    if (item == null) return;

    try {
      final product = await context.read<CartCubit>().loadCartItemProduct(item);
      if (!mounted) return;
      _product = product;
      _selectedSize = _findSelectedSize(product);
      _selectedColor = _findSelectedColor(_selectedSize);
      _normalizeQuantity();
    } catch (_) {
      if (!mounted) return;
      _product = null;
    } finally {
      if (mounted) setState(() => _isLoadingProduct = false);
    }
  }

  VariantBySize? _findSelectedSize(ProductModel? product) {
    final sizes = product?.variants?.variantsBySize ?? const <VariantBySize>[];
    if (sizes.isEmpty) return null;

    final initialSize = widget.initialSize;
    if (initialSize != null) {
      for (final size in sizes) {
        if (size.sizeId == initialSize.sizeId) return size;
      }
    }

    if (_originalSizeOptionId != null) {
      for (final size in sizes) {
        if (size.sizeId == _originalSizeOptionId) return size;
      }
    }

    final label = widget.item?.sizeOption?.optionLabel?.trim().toLowerCase();
    if (label != null && label.isNotEmpty) {
      for (final size in sizes) {
        if (size.sizeName.trim().toLowerCase() == label) return size;
      }
    }

    return sizes.first;
  }

  ColorVariant? _findSelectedColor(VariantBySize? size) {
    final colors = size?.colors ?? const <ColorVariant>[];
    if (colors.isEmpty) return null;

    final initialColor = widget.initialColor;
    if (initialColor != null) {
      for (final color in colors) {
        if (color.colorId == initialColor.colorId ||
            color.variantId == initialColor.variantId) {
          return color;
        }
      }
    }

    if (_originalColorOptionId != null) {
      for (final color in colors) {
        if (color.colorId == _originalColorOptionId ||
            color.variantId == _originalColorOptionId) {
          return color;
        }
      }
    }

    final label = widget.item?.colorOption?.optionLabel?.trim().toLowerCase();
    if (label != null && label.isNotEmpty) {
      for (final color in colors) {
        if (color.colorName.trim().toLowerCase() == label) return color;
      }
    }

    return colors.first;
  }

  int? get _selectedSizeOptionId =>
      _selectedSize?.sizeId ?? _originalSizeOptionId;

  int? get _selectedColorOptionId =>
      _selectedColor?.colorId ?? _originalColorOptionId;

  bool get _quantityChanged => _quantity != _originalQuantity;

  bool get _colorChanged => _selectedColorOptionId != _originalColorOptionId;

  bool get _sizeChanged => _selectedSizeOptionId != _originalSizeOptionId;

  bool get _hasChanges => _quantityChanged || _colorChanged || _sizeChanged;

  bool get _canChangeQty => widget.item?.canChangeQty ?? true;

  int? get _maxQuantity {
    final colorStock = _selectedColor?.stockQty;
    if (colorStock != null) return colorStock;
    final productStock = _product?.variants?.stockQty;
    if (productStock != null) return productStock;
    return null;
  }

  bool get _hasRequiredOptions {
    final sizes = _product?.variants?.variantsBySize ?? const <VariantBySize>[];
    final colors = _selectedSize?.colors ?? const <ColorVariant>[];
    if (sizes.isNotEmpty && _selectedSize == null) return false;
    if (colors.isNotEmpty && _selectedColor == null) return false;
    return true;
  }

  bool get _isQuantityValid {
    if (_quantity < 1) return false;
    final maxQuantity = _maxQuantity;
    if (maxQuantity != null && _quantity > maxQuantity) return false;
    return true;
  }

  void _normalizeQuantity() {
    final maxQuantity = _maxQuantity;
    if (maxQuantity != null && maxQuantity > 0 && _quantity > maxQuantity) {
      _quantity = maxQuantity;
    }
    if (_quantity < 1) _quantity = 1;
  }

  void _selectSize(VariantBySize? size) {
    if (size == null) return;
    setState(() {
      _selectedSize = size;
      _selectedColor = _findSelectedColor(size);
      _normalizeQuantity();
      _errorText = null;
    });
  }

  void _selectColor(ColorVariant? color) {
    if (color == null) return;
    setState(() {
      _selectedColor = color;
      _normalizeQuantity();
      _errorText = null;
    });
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context)!;
    if (!_hasRequiredOptions) {
      setState(() => _errorText = l10n.selectRequiredOptions);
      return;
    }
    if (!_isQuantityValid) {
      setState(() => _errorText = l10n.invalidQuantity);
      return;
    }
    if (!_isAddMode && !_hasChanges) {
      setState(() => _errorText = l10n.noChangesDetected);
      return;
    }

    setState(() {
      _isSaving = true;
      _errorText = null;
    });

    final cartCubit = context.read<CartCubit>();
    final success = _isAddMode
        ? await _addSelectedItem(cartCubit)
        : await _updateSelectedItem(cartCubit);

    if (!mounted) return;
    setState(() => _isSaving = false);
    if (success) {
      Navigator.of(context).pop(true);
    } else {
      setState(
        () => _errorText = _isAddMode
            ? l10n.unableToAddItem
            : l10n.unableToUpdateItem,
      );
    }
  }

  Future<bool> _addSelectedItem(CartCubit cartCubit) async {
    final product = _product;
    if (product == null) return false;

    return cartCubit.addItem(
      (_selectedColor?.variantId ?? product.id).toString(),
      quantity: _quantity,
      color: _selectedColor?.colorName ?? '',
      size: _selectedSize?.sizeName ?? '',
    );
  }

  Future<bool> _updateSelectedItem(CartCubit cartCubit) async {
    final item = widget.item;
    if (item == null) return false;

    if (_colorChanged || _sizeChanged) {
      final colorId = _selectedColorOptionId;
      final sizeId = _selectedSizeOptionId;
      if (colorId == null || sizeId == null) return false;
      return cartCubit.updateItemDetials(
        item.id,
        _quantity,
        colorId.toString(),
        sizeId.toString(),
      );
    }

    return cartCubit.updateItemQuantity(item.id, _quantity);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final product = _product;
    final item = widget.item;
    final sizes = product?.variants?.variantsBySize ?? const <VariantBySize>[];
    final colors = _selectedSize?.colors ?? const <ColorVariant>[];
    final maxQuantity = _maxQuantity;
    final canSave =
        !_isSaving &&
        (_isAddMode || _hasChanges) &&
        (_canChangeQty || !_quantityChanged) &&
        _hasRequiredOptions &&
        _isQuantityValid;
    final title = _isAddMode ? l10n.chooseCartOptions : l10n.editItem;
    final productName = item?.name ?? product?.name ?? '';
    final imageUrl =
        item?.imageUrl ?? product?.baseImage?.originalImageUrl ?? '';

    return AlertDialog(
      title: Text(title),
      content: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 420.w),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Container(
                      width: 64.w,
                      height: 64.w,
                      color: colorScheme.tertiaryFixed,
                      child: CustomNetworkImage(
                        imageUrl: imageUrl,
                        width: 64.w,
                        height: 64.w,
                        defaultIcon: Icons.inventory_2_outlined,
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: Text(
                      productName,
                      style: theme.textTheme.titleMedium,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.h),
              if (_isLoadingProduct)
                const LinearProgressIndicator()
              else ...[
                if (sizes.isNotEmpty)
                  DropdownButtonFormField<VariantBySize>(
                    key: ValueKey(_selectedSize?.sizeId),
                    initialValue: _selectedSize,
                    decoration: InputDecoration(labelText: l10n.size),
                    items: sizes
                        .map(
                          (size) => DropdownMenuItem(
                            value: size,
                            child: Text(size.sizeName),
                          ),
                        )
                        .toList(),
                    onChanged: _isSaving ? null : _selectSize,
                  )
                else
                  _ReadOnlyOption(
                    label: l10n.size,
                    value: item?.sizeOption?.optionLabel ?? l10n.noSizeOptions,
                  ),
                SizedBox(height: 12.h),
                if (colors.isNotEmpty)
                  DropdownButtonFormField<ColorVariant>(
                    key: ValueKey(
                      '${_selectedSize?.sizeId}-${_selectedColor?.colorId}',
                    ),
                    initialValue: _selectedColor,
                    decoration: InputDecoration(labelText: l10n.colour),
                    items: colors
                        .map(
                          (color) => DropdownMenuItem(
                            value: color,
                            child: Text(color.colorName),
                          ),
                        )
                        .toList(),
                    onChanged: _isSaving ? null : _selectColor,
                  )
                else
                  _ReadOnlyOption(
                    label: l10n.colour,
                    value:
                        item?.colorOption?.optionLabel ?? l10n.noColourOptions,
                  ),
              ],
              SizedBox(height: 12.h),
              InputDecorator(
                decoration: InputDecoration(labelText: l10n.quantity),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        maxQuantity == null
                            ? l10n.quantity
                            : l10n.availableQuantity(maxQuantity),
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                    QuantityCounter(
                      value: _quantity,
                      maxQuantity: maxQuantity,
                      enabled: _canChangeQty && !_isSaving,
                      onChanged: (value) => setState(() {
                        _quantity = value;
                        _errorText = null;
                      }),
                    ),
                  ],
                ),
              ),
              if (!_canChangeQty) ...[
                SizedBox(height: 6.h),
                Text(l10n.quantityReadOnly, style: theme.textTheme.bodySmall),
              ],
              ...?item?.options
                  .where(
                    (option) =>
                        option.optionLabel != null &&
                        option != item.colorOption &&
                        option != item.sizeOption,
                  )
                  .map(
                    (option) => Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: _ReadOnlyOption(
                        label: option.attributeName,
                        value: option.optionLabel,
                      ),
                    ),
                  ),
              if (_errorText != null) ...[
                SizedBox(height: 12.h),
                Text(
                  _errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: canSave ? _save : null,
          child: _isSaving
              ? SizedBox(
                  width: 18.r,
                  height: 18.r,
                  child: const CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(_isAddMode ? l10n.addToCart : l10n.saveChanges),
        ),
      ],
    );
  }
}

class _ReadOnlyOption extends StatelessWidget {
  const _ReadOnlyOption({required this.label, required this.value});

  final String? label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.trim().isEmpty) return const SizedBox.shrink();
    return InputDecorator(
      decoration: InputDecoration(labelText: label),
      child: Text(value!),
    );
  }
}
