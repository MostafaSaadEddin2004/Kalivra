import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/cart_cubit/cart_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/cart/cart_api_model.dart';
import 'package:kalivra/model/product/product_model.dart';
import 'package:kalivra/view/widgets/cards/custom_network_image.dart';

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
  bool _isDisposed = false;
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

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }

  Future<void> _loadProductOptions() async {
    final item = widget.item;
    if (item == null) return;

    try {
      final product = await context.read<CartCubit>().loadCartItemProduct(item);
      if (_isDisposed) return;
      _product = product;
      _selectedSize = _findSelectedSize(product);
      _selectedColor = _findSelectedColor(_selectedSize);
      _normalizeQuantity();
    } catch (_) {
      if (_isDisposed) return;
      _product = null;
    } finally {
      if (!_isDisposed) {
        setState(() => _isLoadingProduct = false);
      }
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

  String get _displayPrice {
    final item = widget.item;
    final product = _product ?? widget.product;
    return item?.formattedPrice ??
        item?.price?.toString() ??
        product?.prices.final_?.formattedPrice ??
        product?.prices.regular.formattedPrice ??
        product?.minPrice ??
        product?.prices.final_?.price ??
        product?.prices.regular.price ??
        '';
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

  void _changeQuantity(int quantity) {
    setState(() {
      _quantity = quantity;
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
    var shouldCloseDialog = false;
    try {
      final saved = _isAddMode
          ? await _addSelectedItem(cartCubit)
          : await _updateSelectedItem(cartCubit);
      if (saved) {
        shouldCloseDialog = true;
        context.pop();
        return;
      }
      if (_isDisposed) return;
      setState(
        () => _errorText = _isAddMode
            ? l10n.unableToAddItem
            : l10n.unableToUpdateItem,
      );
    } catch (_) {
      if (_isDisposed) return;
      setState(
        () => _errorText = _isAddMode
            ? l10n.unableToAddItem
            : l10n.unableToUpdateItem,
      );
    } finally {
      if (!shouldCloseDialog && !_isDisposed) {
        setState(() => _isSaving = false);
      }
    }
  }

  Future<bool> _addSelectedItem(CartCubit cartCubit) async {
    final product = _product;
    return cartCubit.addItem(
      context,
      (_selectedColor?.variantId ?? product!.id).toString(),
      quantity: _quantity,
      color: _selectedColor?.colorName ?? '',
      size: _selectedSize?.sizeName ?? '',
      productName: product!.name,
    );
  }

  Future<bool> _updateSelectedItem(CartCubit cartCubit) async {
    final item = widget.item;
    final colorId = _selectedColorOptionId;
    final sizeId = _selectedSizeOptionId;
    return cartCubit.updateItemDetials(
      context,
      item!.id,
      _quantity,
      colorId.toString(),
      sizeId.toString(),
    );
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
        item?.imageUrl ??
        product?.baseImage?.largeImageUrl ??
        product?.baseImage?.originalImageUrl ??
        '';
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 24.h),
      backgroundColor: theme.cardTheme.color,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.r)),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 430.w, maxHeight: maxHeight),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24.w, 18.h, 24.w, 22.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 44.h,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        onPressed: _isSaving ? null : () => context.pop(),
                        icon: Icon(
                          Icons.close_rounded,
                          color: colorScheme.primaryFixed,
                          size: 24.r,
                        ),
                        tooltip: l10n.cancel,
                      ),
                    ),
                    Text(
                      title,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        color: colorScheme.onTertiaryFixed,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 22.h),
              _DialogProductHeader(
                imageUrl: imageUrl,
                name: productName,
                price: _displayPrice,
              ),
              SizedBox(height: 24.h),
              Divider(
                color: colorScheme.primaryFixed.withValues(alpha: 0.08),
                height: 1.h,
              ),
              SizedBox(height: 26.h),
              if (_isLoadingProduct)
                LinearProgressIndicator(color: colorScheme.onTertiaryFixed)
              else ...[
                _DialogOptionLabel(
                  icon: Icons.straighten_rounded,
                  label: l10n.size,
                ),
                SizedBox(height: 10.h),
                if (sizes.isNotEmpty)
                  _StyledDropdown<VariantBySize>(
                    value: _selectedSize,
                    hint: l10n.size,
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
                    value: item?.sizeOption?.optionLabel ?? l10n.noSizeOptions,
                  ),
                SizedBox(height: 22.h),
                _DialogOptionLabel(
                  icon: Icons.palette_outlined,
                  label: l10n.colour,
                ),
                SizedBox(height: 10.h),
                if (colors.isNotEmpty)
                  _StyledDropdown<ColorVariant>(
                    value: _selectedColor,
                    hint: l10n.colour,
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
                    value:
                        item?.colorOption?.optionLabel ?? l10n.noColourOptions,
                  ),
              ],
              SizedBox(height: 22.h),
              _DialogOptionLabel(
                icon: Icons.inventory_2_outlined,
                label: l10n.quantity,
              ),
              SizedBox(height: 10.h),
              _DialogQuantitySelector(
                value: _quantity,
                maxQuantity: maxQuantity,
                enabled: _canChangeQty && !_isSaving,
                onChanged: _changeQuantity,
              ),
              if (!_canChangeQty) ...[
                SizedBox(height: 8.h),
                Text(
                  l10n.quantityReadOnly,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.primaryFixed.withValues(alpha: 0.62),
                  ),
                ),
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
                      padding: EdgeInsets.only(top: 14.h),
                      child: _ReadOnlyOption(value: option.optionLabel),
                    ),
                  ),
              if (_errorText != null) ...[
                SizedBox(height: 14.h),
                Text(
                  _errorText!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.error,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              SizedBox(height: 28.h),
              FilledButton(
                onPressed: canSave ? _save : null,
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.onTertiaryFixed,
                  foregroundColor: colorScheme.secondaryFixed,
                  padding: EdgeInsets.symmetric(vertical: 18.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28.r),
                  ),
                ),
                child: _isSaving
                    ? SpinKitFadingCircle(
                        itemSize: 20.r,
                        size: 22.r,
                        color: colorScheme.secondaryFixed,
                      )
                    : Text(
                        _isAddMode ? l10n.addToCart : l10n.saveChanges,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: colorScheme.secondaryFixed,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
              ),
              SizedBox(height: 14.h),
              TextButton(
                onPressed: _isSaving ? null : () => context.pop(),
                child: Text(
                  l10n.cancel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: colorScheme.onTertiaryFixed,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogProductHeader extends StatelessWidget {
  const _DialogProductHeader({
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  final String imageUrl;
  final String name;
  final String price;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: Container(
            width: 92.w,
            height: 92.w,
            color: colorScheme.tertiaryFixed,
            child: CustomNetworkImage(
              imageUrl: imageUrl,
              width: 92.w,
              height: 92.w,
              defaultIcon: Icons.image_outlined,
              defaultIconColor: AppColors.burgundy.withValues(alpha: 0.48),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: theme.textTheme.titleLarge?.copyWith(
                  color: colorScheme.primaryFixed,
                  fontWeight: FontWeight.w800,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (price.trim().isNotEmpty) ...[
                SizedBox(height: 10.h),
                Text(
                  price,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primaryFixed,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _DialogOptionLabel extends StatelessWidget {
  const _DialogOptionLabel({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Row(
      children: [
        Icon(icon, color: colorScheme.primaryFixed, size: 24.r),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.primaryFixed,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ],
    );
  }
}

class _StyledDropdown<T> extends StatelessWidget {
  const _StyledDropdown({
    required this.value,
    required this.hint,
    required this.items,
    required this.onChanged,
  });

  final T? value;
  final String hint;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DropdownButtonFormField<T>(
      initialValue: value,
      items: items,
      onChanged: onChanged,
      icon: Icon(
        Icons.keyboard_arrow_down_rounded,
        color: colorScheme.primaryFixed,
      ),
      style: theme.textTheme.bodyLarge?.copyWith(
        color: colorScheme.primaryFixed,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.primaryFixed.withValues(alpha: 0.52),
        ),
        filled: true,
        fillColor: theme.cardTheme.color,
        contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: colorScheme.primaryFixed.withValues(alpha: 0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(
            color: colorScheme.primaryFixed.withValues(alpha: 0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: colorScheme.onTertiaryFixed),
        ),
      ),
    );
  }
}

class _ReadOnlyOption extends StatelessWidget {
  const _ReadOnlyOption({required this.value});

  final String? value;

  @override
  Widget build(BuildContext context) {
    if (value == null || value!.trim().isEmpty) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: colorScheme.primaryFixed.withValues(alpha: 0.12),
        ),
      ),
      child: Text(
        value!,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: colorScheme.primaryFixed.withValues(alpha: 0.72),
        ),
      ),
    );
  }
}

class _DialogQuantitySelector extends StatelessWidget {
  const _DialogQuantitySelector({
    required this.value,
    required this.enabled,
    required this.onChanged,
    this.maxQuantity,
  });

  final int value;
  final int? maxQuantity;
  final bool enabled;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final canDecrease = enabled && value > 1;
    final canIncrease =
        enabled && (maxQuantity == null || value < maxQuantity!);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(
          color: colorScheme.primaryFixed.withValues(alpha: 0.12),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              _QuantityRoundButton(
                icon: Icons.remove_rounded,
                enabled: canDecrease,
                onTap: () => onChanged(value - 1),
              ),
              Expanded(
                child: Text(
                  '$value',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: colorScheme.primaryFixed,
                    fontWeight: FontWeight.w800,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              _QuantityRoundButton(
                icon: Icons.add_rounded,
                enabled: canIncrease,
                onTap: () => onChanged(value + 1),
              ),
            ],
          ),
          if (maxQuantity != null) ...[
            SizedBox(height: 10.h),
            Text(
              l10n.availableQuantity(maxQuantity!),
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.primaryFixed.withValues(alpha: 0.55),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _QuantityRoundButton extends StatelessWidget {
  const _QuantityRoundButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: 48.r,
      height: 48.r,
      child: Material(
        color: colorScheme.primaryFixed.withValues(alpha: 0.05),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: Icon(
            icon,
            color: enabled
                ? colorScheme.primaryFixed
                : colorScheme.primaryFixed.withValues(alpha: 0.24),
            size: 22.r,
          ),
        ),
      ),
    );
  }
}
