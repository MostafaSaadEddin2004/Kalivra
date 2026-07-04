import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kalivra/controller/blocs/cubit/address_info_cubit/address_info_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/association/association_dropdown_field.dart';
import 'package:kalivra/view/widgets/association/association_form_section.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

const String _membershipTypeTourism = 'سياحية';
const String _membershipTypeResidential = 'سكنية';

class AssociationRequestsAndServicesScreen extends StatefulWidget {
  const AssociationRequestsAndServicesScreen({super.key});

  @override
  State<AssociationRequestsAndServicesScreen> createState() =>
      _AssociationRequestsAndServicesScreenState();
}

class _AssociationRequestsAndServicesScreenState
    extends State<AssociationRequestsAndServicesScreen> {
  static const String _membershipRequestType = 'association_membership';
  static const int _maxAttachmentBytes = 15 * 1024 * 1024;

  static const List<String> _allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'pdf',
  ];

  late final AssociationLinkCubit _associationLinkCubit;

  final _formKey = GlobalKey<FormState>();

  final _messageController = TextEditingController();

  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _nationalIdController = TextEditingController();

  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final List<TextEditingController> _additionalAddressControllers = [
    TextEditingController(),
  ];

  final _membershipNumberController = TextEditingController();
  final _priorityNumberController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _housingUnitController = TextEditingController();
  final _villageController = TextEditingController();

  final List<AssociationLinkAttachment> _attachments = [];

  final Map<String, TextEditingController> _attachmentDescriptionControllers =
      {};

  final List<dynamic> _requestTypes = [];

  String? _requestType;
  String? _requestedMembershipType;
  String? _selectedGovernorate;
  String? _selectedCity;
  String? _selectedTown;
  String? _accountPhone;

  bool _isLocked = false;

  bool get _isMembershipRequest => _requestType == _membershipRequestType;

  bool get _hasSelectedGeneralRequest =>
      _requestType != null && !_isMembershipRequest;

  bool get _hasSelectedAnyRequest => _requestType != null;

  @override
  void initState() {
    super.initState();

    _associationLinkCubit = AssociationLinkCubit()..fetchRequestTypes();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AddressInfoCubit>().fetchCapitals();
    });
  }

  @override
  void dispose() {
    _associationLinkCubit.close();

    _messageController.dispose();

    _fatherNameController.dispose();
    _motherNameController.dispose();
    _nationalIdController.dispose();

    _streetController.dispose();
    _buildingController.dispose();

    for (final controller in _additionalAddressControllers) {
      controller.dispose();
    }

    _membershipNumberController.dispose();
    _priorityNumberController.dispose();
    _projectNameController.dispose();
    _housingUnitController.dispose();
    _villageController.dispose();

    for (final controller in _attachmentDescriptionControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  String _normalizePhone(String value) {
    return value.replaceAll(RegExp(r'\D'), '');
  }

  bool _isValidPhone(String value) {
    return _normalizePhone(value).length >= 8;
  }

  bool _isValidEmail(String value) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim());
  }

  String? _validateRequiredName(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.associationLinkEnterFirstName;
    }

    return null;
  }

  String? _validateRequiredPhone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.enterPhone;
    }

    if (!_isValidPhone(value)) {
      return l10n.invalidPhone;
    }

    final accountPhone = _accountPhone;

    if (accountPhone != null &&
        accountPhone.trim().isNotEmpty &&
        _normalizePhone(accountPhone) != _normalizePhone(value)) {
      return l10n.associationLinkPhoneMustMatchAccount;
    }

    return null;
  }

  String? _validateOptionalPhone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!_isValidPhone(value)) {
      return l10n.invalidPhone;
    }

    return null;
  }

  String? _validateOptionalEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return null;
    }

    if (!_isValidEmail(value)) {
      return l10n.invalidEmail;
    }

    return null;
  }

  void _onRequestTypeChanged(String? value) {
    if (value == _requestType) return;

    setState(() {
      _requestType = value;

      _messageController.clear();

      _attachments.clear();

      for (final controller in _attachmentDescriptionControllers.values) {
        controller.dispose();
      }

      _attachmentDescriptionControllers.clear();
    });
  }

  void _onRequestedMembershipTypeChanged(String? value) {
    setState(() {
      _requestedMembershipType = value;
    });
  }

  void _onGovernorateChanged(String? value) {
    setState(() {
      _selectedGovernorate = value;
      _selectedCity = null;
      _selectedTown = null;
    });

    if (value != null) {
      context.read<AddressInfoCubit>().fetchCities(capitalId: value);
    }
  }

  void _onCityChanged(String? value) {
    setState(() {
      _selectedCity = value;
      _selectedTown = null;
    });

    if (value != null) {
      context.read<AddressInfoCubit>().fetchTowns(cityId: value);
    }
  }

  void _onTownChanged(String? value) {
    setState(() {
      _selectedTown = value;
    });
  }

  Future<void> _pickAttachment() async {
    if (_isLocked) return;

    final l10n = AppLocalizations.of(context)!;

    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
    );

    if (result == null || !mounted) return;

    for (final pickedFile in result.files) {
      final path = pickedFile.path;

      if (path == null) continue;

      final extension = pickedFile.extension?.toLowerCase();

      if (extension == null || !_allowedExtensions.contains(extension)) {
        CustomSnackBar.show(context, l10n.associationLinkUnsupportedFileType);
        continue;
      }

      final file = File(path);
      final fileSize = await file.length();

      if (!mounted) return;

      if (fileSize > _maxAttachmentBytes) {
        CustomSnackBar.show(context, l10n.associationLinkFileTooLarge);
        continue;
      }

      setState(() {
        final id =
            '${DateTime.now().microsecondsSinceEpoch}_${_attachments.length}';

        _attachments.add(AssociationLinkAttachment(id: id, file: file));

        _attachmentDescriptionControllers[id] = TextEditingController();
      });
    }
  }

  void _removeAttachment(String id) {
    if (_isLocked) return;

    setState(() {
      _attachments.removeWhere((attachment) => attachment.id == id);
      _attachmentDescriptionControllers.remove(id)?.dispose();
    });
  }

  void _addAdditionalAddress() {
    if (_isLocked) return;

    if (_additionalAddressControllers.first.text.trim().isEmpty) {
      CustomSnackBar.show(
        context,
        AppLocalizations.of(context)!.associationAddressRequired,
      );
      return;
    }

    setState(() {
      _additionalAddressControllers.add(TextEditingController());
    });
  }

  void _removeAdditionalAddress(int index) {
    if (_isLocked || _additionalAddressControllers.length == 1) return;

    setState(() {
      _additionalAddressControllers.removeAt(index).dispose();
    });
  }

  List<AssociationLinkAttachment> _attachmentsWithDescriptions() {
    return _attachments.map((attachment) {
      return attachment.copyWith(
        description:
            _attachmentDescriptionControllers[attachment.id]?.text.trim() ?? '',
      );
    }).toList();
  }

  List<String> _additionalAddresses() {
    return _additionalAddressControllers
        .map((controller) => controller.text.trim())
        .where((address) => address.isNotEmpty)
        .toList();
  }

  Future<void> _submit() async {
    final l10n = AppLocalizations.of(context)!;

    if (_requestType == null) {
      CustomSnackBar.show(
        context,
        l10n.associationRequestTypeOrMessageRequired,
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_isMembershipRequest && _additionalAddresses().isEmpty) {
      CustomSnackBar.show(context, l10n.associationAddressRequired);
      return;
    }

    if (_isMembershipRequest && _attachments.isEmpty) {
      CustomSnackBar.show(
        context,
        l10n.associationRequestTypeOrMessageRequired,
      );
      return;
    }

    try {
      if (_isMembershipRequest) {
        await _associationLinkCubit.submitLinkRequest(
          context: context,
          customerNote: _messageController.text.trim(),
          type: _membershipRequestType,
          fatherName: _fatherNameController.text.trim(),
          motherName: _motherNameController.text.trim(),
          nationalId: _nationalIdController.text.trim(),
          requestedMembershipType: _requestedMembershipType!,
          permanentCapitalId: _selectedGovernorate,
          permanentCityId: _selectedCity,
          permanentTownId: _selectedTown,
          permanentVillage: _villageController.text.trim(),
          officialStreet: _streetController.text.trim(),
          officialBuilding: _buildingController.text.trim(),
          additionalAddresses: _additionalAddresses(),
          claimedMembershipNumber: _membershipNumberController.text.trim(),
          claimedPriorityNumber: _priorityNumberController.text.trim(),
          claimedBuildingNumber: _buildingController.text.trim(),
          claimedUnitNumber: _housingUnitController.text.trim(),
          attachments: _attachmentsWithDescriptions(),
        );
      } else {
        await _associationLinkCubit.submitNormalRequest(
          context: context,
          type: _requestType!,
          customerNote: _messageController.text.trim(),
          attachments: _attachmentsWithDescriptions(),
        );
      }

      if (!mounted) return;

      CustomSnackBar.show(context, l10n.linkRequestSentSuccessfully);

      setState(() {
        _isLocked = _isMembershipRequest;
      });
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(context, e.toString());
    }
  }

  Widget _fieldSpacer() {
    return SizedBox(height: 14.h);
  }

  Widget _buildRequestTypeDropdown({
    required AppLocalizations l10n,
    required AssociationLinkState state,
  }) {
    final isBusy = state is AssociationLinkLoading;
    final isLoadingTypes = isBusy && _requestTypes.isEmpty;
    final hasFetchFailure =
        state is AssociationLinkFailure && _requestTypes.isEmpty;

    if (hasFetchFailure) {
      return Text(
        state.errorMessage,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: Theme.of(context).colorScheme.error,
        ),
      );
    }

    final selectedValue =
        _requestTypes.any((item) => item.value == _requestType)
        ? _requestType
        : null;

    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(12.w),
        child: AssociationDropdownField(
          label: l10n.associationRequestTypeHint,
          hintText: isLoadingTypes
              ? l10n.associationAddressLoadingRequestTypes
              : l10n.associationRequestTypeHint,
          value: selectedValue,
          items: isLoadingTypes
              ? const []
              : _requestTypes
                    .map<String>((item) => item.value as String)
                    .toList(),
          itemLabelBuilder: (value) {
            final item = _requestTypes.firstWhere(
              (requestType) => requestType.value == value,
            );
            return item.label;
          },
          enabled: !isBusy,
          onChanged: _onRequestTypeChanged,
          validator: (value) => value == null
              ? l10n.associationRequestTypeOrMessageRequired
              : null,
        ),
      ),
    );
  }

  Widget _buildGeneralRequestFields({
    required AppLocalizations l10n,
    required ThemeData theme,
    required bool isDark,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 16.h),
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: AppTextField(
              controller: _messageController,
              label: l10n.messageLabel,
              hint: l10n.associationRequestMessageHint,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              prefixIcon: Icon(
                Icons.message_rounded,
                color: isDark ? AppColors.taupe : AppColors.burgundy,
              ),
              validator: (value) {
                if (_hasSelectedGeneralRequest &&
                    (value == null || value.trim().isEmpty)) {
                  return l10n.associationRequestTypeOrMessageRequired;
                }

                return null;
              },
            ),
          ),
        ),
        SizedBox(height: 16.h),
        _RequestAttachmentsSection(
          attachments: _attachments,
          attachmentDescriptionControllers: _attachmentDescriptionControllers,
          enabled: !_isLocked,
          onPickAttachment: _pickAttachment,
          onRemoveAttachment: _removeAttachment,
        ),
      ],
    );
  }

  Widget _buildSubmitButton({required AssociationLinkState state}) {
    final isSubmitting =
        state is AssociationLinkLoading && _requestTypes.isNotEmpty;

    return SafeArea(
      top: false,
      child: SizedBox(
        width: double.infinity,
        child: FilledButton(
          onPressed: !_hasSelectedAnyRequest || isSubmitting ? null : _submit,
          child: isSubmitting
              ? SpinKitFadingCircle(color: AppColors.offWhite, size: 20.r)
              : Text(AppLocalizations.of(context)!.associationLinkSubmit),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocProvider.value(
      value: _associationLinkCubit,
      child: Scaffold(
        appBar: ScreenAppBar(title: l10n.associationRequestsAndServices),
        body: BlocConsumer<AssociationLinkCubit, AssociationLinkState>(
          listener: (context, state) {
            if (state is AssociationRequestTypesFetched) {
              setState(() {
                _requestTypes
                  ..clear()
                  ..addAll(state.requestTypes);
              });
            }

            if (state is AssociationLinkFailure && _requestTypes.isNotEmpty) {
              CustomSnackBar.show(context, state.errorMessage);
            }
          },
          builder: (context, state) {
            return Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                children: [
                  _buildRequestTypeDropdown(l10n: l10n, state: state),
                  if (_isMembershipRequest) ...[
                    SizedBox(height: 16.h),
                    AssociationLinkRequestSection(
                      isLocked: _isLocked,
                      hasSelectedGeneralRequest: _hasSelectedGeneralRequest,
                      fatherNameController: _fatherNameController,
                      motherNameController: _motherNameController,
                      nationalIdController: _nationalIdController,
                      selectedGovernorate: _selectedGovernorate,
                      selectedCity: _selectedCity,
                      selectedTown: _selectedTown,
                      streetController: _streetController,
                      buildingController: _buildingController,
                      additionalAddressControllers:
                          _additionalAddressControllers,
                      requestedMembershipType: _requestedMembershipType,
                      membershipNumberController: _membershipNumberController,
                      priorityNumberController: _priorityNumberController,
                      projectNameController: _projectNameController,
                      housingUnitController: _housingUnitController,
                      villageController: _villageController,
                      attachments: _attachments,
                      attachmentDescriptionControllers:
                          _attachmentDescriptionControllers,
                      onGovernorateChanged: _onGovernorateChanged,
                      onCityChanged: _onCityChanged,
                      onTownChanged: _onTownChanged,
                      onRequestedMembershipTypeChanged:
                          _onRequestedMembershipTypeChanged,
                      onAddAdditionalAddress: _addAdditionalAddress,
                      onRemoveAdditionalAddress: _removeAdditionalAddress,
                      onPickAttachment: _pickAttachment,
                      onRemoveAttachment: _removeAttachment,
                      validateRequiredName: (value) =>
                          _validateRequiredName(value, l10n),
                      validateRequiredPhone: (value) =>
                          _validateRequiredPhone(value, l10n),
                      validateOptionalPhone: (value) =>
                          _validateOptionalPhone(value, l10n),
                      validateOptionalEmail: (value) =>
                          _validateOptionalEmail(value, l10n),
                      fieldSpacer: _fieldSpacer,
                    ),
                  ],
                  if (_hasSelectedGeneralRequest)
                    _buildGeneralRequestFields(
                      l10n: l10n,
                      theme: theme,
                      isDark: isDark,
                    ),
                  if (_hasSelectedAnyRequest && !_isLocked) ...[
                    SizedBox(height: 20.h),
                    _buildSubmitButton(state: state),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class AssociationLinkRequestSection extends StatefulWidget {
  const AssociationLinkRequestSection({
    super.key,
    required this.fatherNameController,
    required this.motherNameController,
    required this.nationalIdController,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.selectedTown,
    required this.streetController,
    required this.buildingController,
    required this.additionalAddressControllers,
    required this.requestedMembershipType,
    required this.membershipNumberController,
    required this.priorityNumberController,
    required this.projectNameController,
    required this.housingUnitController,
    required this.villageController,
    required this.attachments,
    required this.attachmentDescriptionControllers,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onTownChanged,
    required this.onRequestedMembershipTypeChanged,
    required this.onAddAdditionalAddress,
    required this.onRemoveAdditionalAddress,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
    required this.validateRequiredName,
    required this.validateRequiredPhone,
    required this.validateOptionalPhone,
    required this.validateOptionalEmail,
    required this.fieldSpacer,
    required this.hasSelectedGeneralRequest,
    required this.isLocked,
  });

  final TextEditingController fatherNameController;
  final TextEditingController motherNameController;
  final TextEditingController nationalIdController;

  final String? selectedGovernorate;
  final String? selectedCity;
  final String? selectedTown;

  final TextEditingController streetController;
  final TextEditingController buildingController;
  final List<TextEditingController> additionalAddressControllers;
  final String? requestedMembershipType;

  final TextEditingController membershipNumberController;
  final TextEditingController priorityNumberController;
  final TextEditingController projectNameController;
  final TextEditingController housingUnitController;
  final TextEditingController villageController;

  final List<AssociationLinkAttachment> attachments;
  final Map<String, TextEditingController> attachmentDescriptionControllers;

  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onTownChanged;
  final ValueChanged<String?> onRequestedMembershipTypeChanged;
  final VoidCallback onAddAdditionalAddress;
  final ValueChanged<int> onRemoveAdditionalAddress;

  final VoidCallback onPickAttachment;
  final ValueChanged<String> onRemoveAttachment;

  final String? Function(String?) validateRequiredName;
  final String? Function(String?) validateRequiredPhone;
  final String? Function(String?) validateOptionalPhone;
  final String? Function(String?) validateOptionalEmail;
  final bool hasSelectedGeneralRequest;

  final Widget Function() fieldSpacer;
  final bool isLocked;

  @override
  State<AssociationLinkRequestSection> createState() =>
      _AssociationLinkRequestSectionState();
}

class _AssociationLinkRequestSectionState
    extends State<AssociationLinkRequestSection> {
  bool get isLocked => widget.isLocked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AssociationFormSection(
          title: l10n.associationLinkPersonalSection,
          icon: Icons.person_outline_rounded,
          children: [
            AppTextField(
              controller: widget.fatherNameController,
              label: l10n.associationLinkFatherName,
              textCapitalization: TextCapitalization.words,
              validator: widget.validateRequiredName,
            ),
            widget.fieldSpacer(),
            AppTextField(
              controller: widget.motherNameController,
              label: l10n.associationLinkMotherName,
              textCapitalization: TextCapitalization.words,
              validator: widget.validateRequiredName,
            ),
            widget.fieldSpacer(),
            AppTextField(
              controller: widget.nationalIdController,
              label: l10n.associationLinkNationalId,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.required;
                }

                return null;
              },
            ),
          ],
        ),
        AssociationFormSection(
          title: l10n.associationLinkContactSection,
          icon: Icons.location_on_outlined,
          children: [
            BlocBuilder<AddressInfoCubit, AddressInfoState>(
              builder: (context, addressState) {
                final capitalLabels = {
                  for (final capital in addressState.capitals)
                    capital.id: capital.name,
                };
                final cityLabels = {
                  for (final city in addressState.cities) city.id: city.name,
                };
                final townLabels = {
                  for (final town in addressState.towns) town.id: town.name,
                };

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    AssociationDropdownField(
                      label: l10n.associationLinkGovernorate,
                      hintText: addressState.isLoadingCapitals
                          ? l10n.associationAddressLoadingCapitals
                          : l10n.associationAddressSelectCapital,
                      value: widget.selectedGovernorate,
                      items: addressState.capitals
                          .map((capital) => capital.id)
                          .toList(),
                      itemLabelBuilder: (id) => capitalLabels[id] ?? id,
                      enabled:
                          !isLocked &&
                          !addressState.isLoadingCapitals &&
                          !addressState.capitalsFailed,
                      trailing: addressState.capitalsFailed
                          ? _AddressReloadButton(
                              onPressed: isLocked
                                  ? null
                                  : () => context
                                        .read<AddressInfoCubit>()
                                        .fetchCapitals(),
                            )
                          : null,
                      onChanged: widget.onGovernorateChanged,
                      validator: (value) =>
                          value == null ? l10n.required : null,
                    ),
                    SizedBox(height: 16.h),
                    AssociationDropdownField(
                      label: l10n.associationLinkCity,
                      hintText: addressState.isLoadingCities
                          ? l10n.associationAddressLoadingCities
                          : l10n.associationAddressSelectCity,
                      value: widget.selectedCity,
                      items: addressState.cities
                          .map((city) => city.id)
                          .toList(),
                      itemLabelBuilder: (id) => cityLabels[id] ?? id,
                      enabled:
                          !isLocked &&
                          widget.selectedGovernorate != null &&
                          !addressState.isLoadingCities &&
                          !addressState.citiesFailed,
                      trailing:
                          addressState.citiesFailed &&
                              widget.selectedGovernorate != null
                          ? _AddressReloadButton(
                              onPressed: isLocked
                                  ? null
                                  : () => context
                                        .read<AddressInfoCubit>()
                                        .fetchCities(
                                          capitalId:
                                              widget.selectedGovernorate!,
                                        ),
                            )
                          : null,
                      onChanged: widget.onCityChanged,
                      validator: (value) =>
                          value == null ? l10n.required : null,
                    ),
                    SizedBox(height: 16.h),
                    AssociationDropdownField(
                      label: l10n.associationLinkTown,
                      hintText: addressState.isLoadingTowns
                          ? l10n.associationAddressLoadingTowns
                          : l10n.associationAddressSelectTown,
                      value: widget.selectedTown,
                      items: addressState.towns.map((town) => town.id).toList(),
                      itemLabelBuilder: (id) => townLabels[id] ?? id,
                      enabled:
                          !isLocked &&
                          widget.selectedCity != null &&
                          !addressState.isLoadingTowns &&
                          !addressState.townsFailed,
                      trailing:
                          addressState.townsFailed &&
                              widget.selectedCity != null
                          ? _AddressReloadButton(
                              onPressed: isLocked
                                  ? null
                                  : () => context
                                        .read<AddressInfoCubit>()
                                        .fetchTowns(
                                          cityId: widget.selectedCity!,
                                        ),
                            )
                          : null,
                      onChanged: widget.onTownChanged,
                      validator: (value) =>
                          value == null ? l10n.required : null,
                    ),
                  ],
                );
              },
            ),
            widget.fieldSpacer(),
            AppTextField(
              controller: widget.villageController,
              label: l10n.associationLinkVillage,
            ),
            widget.fieldSpacer(),
            AppTextField(
              controller: widget.streetController,
              label: l10n.associationLinkStreet,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.required;
                }

                return null;
              },
            ),
            widget.fieldSpacer(),
            AppTextField(
              controller: widget.buildingController,
              label: l10n.associationLinkBuilding,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.required;
                }

                return null;
              },
            ),
            widget.fieldSpacer(),
            _AdditionalAddressesSection(
              controllers: widget.additionalAddressControllers,
              enabled: !widget.isLocked,
              onAddAddress: widget.onAddAdditionalAddress,
              onRemoveAddress: widget.onRemoveAdditionalAddress,
            ),
          ],
        ),
        AssociationFormSection(
          title: l10n.associationLinkMembershipSection,
          icon: Icons.apartment_outlined,
          children: [
            AssociationDropdownField(
              label: l10n.associationRequestedMembershipType,
              hintText: l10n.associationRequestedMembershipType,
              value: widget.requestedMembershipType,
              items: const [_membershipTypeTourism, _membershipTypeResidential],
              itemLabelBuilder: (value) {
                return switch (value) {
                  _membershipTypeTourism =>
                    l10n.associationMembershipTypeTourism,
                  _membershipTypeResidential =>
                    l10n.associationMembershipTypeResidential,
                  _ => value,
                };
              },
              enabled: !widget.isLocked,
              onChanged: widget.onRequestedMembershipTypeChanged,
              validator: (value) => value == null ? l10n.required : null,
            ),
            widget.fieldSpacer(),
            Row(
              children: [
                Expanded(
                  child: AppTextField(
                    controller: widget.membershipNumberController,
                    label: l10n.associationLinkMembershipNumber,
                    keyboardType: TextInputType.number,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: AppTextField(
                    controller: widget.priorityNumberController,
                    label: l10n.associationLinkPriorityNumber,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            widget.fieldSpacer(),
            AppTextField(
              controller: widget.projectNameController,
              label: l10n.associationLinkProjectName,
            ),
            widget.fieldSpacer(),
            AppTextField(
              controller: widget.housingUnitController,
              label: l10n.associationLinkHousingUnit,
            ),
            widget.fieldSpacer(),
          ],
        ),
        _RequestAttachmentsSection(
          attachments: widget.attachments,
          attachmentDescriptionControllers:
              widget.attachmentDescriptionControllers,
          enabled: !widget.isLocked,
          onPickAttachment: widget.onPickAttachment,
          onRemoveAttachment: widget.onRemoveAttachment,
        ),
      ],
    );
  }
}

class _AddressReloadButton extends StatelessWidget {
  const _AddressReloadButton({required this.onPressed});

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.only(end: 4.w),
      child: TextButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.refresh_rounded, size: 18.r),
        label: Text(AppLocalizations.of(context)!.associationAddressLoadAgain),
        style: TextButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 8.w),
          minimumSize: Size(0, 36.h),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
    );
  }
}

class _AdditionalAddressesSection extends StatelessWidget {
  const _AdditionalAddressesSection({
    required this.controllers,
    required this.enabled,
    required this.onAddAddress,
    required this.onRemoveAddress,
  });

  final List<TextEditingController> controllers;
  final bool enabled;
  final VoidCallback onAddAddress;
  final ValueChanged<int> onRemoveAddress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var index = 0; index < controllers.length; index++) ...[
          if (index > 0) SizedBox(height: 14.h),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppTextField(
                controller: controllers[index],
                label: index == 0
                    ? l10n.associationAddress
                    : l10n.associationAdditionalAddress,
                maxLines: 2,
                enabled: enabled,
                validator: index == 0
                    ? (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.associationAddressRequired;
                        }

                        return null;
                      }
                    : null,
              ),
            ],
          ),
        ],
        if (enabled) ...[
          SizedBox(height: 14.h),
          OutlinedButton.icon(
            onPressed: onAddAddress,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.associationAddAddress),
          ),
        ],
      ],
    );
  }
}

class _RequestAttachmentsSection extends StatelessWidget {
  const _RequestAttachmentsSection({
    required this.attachments,
    required this.attachmentDescriptionControllers,
    required this.enabled,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
  });

  final List<AssociationLinkAttachment> attachments;
  final Map<String, TextEditingController> attachmentDescriptionControllers;
  final bool enabled;
  final VoidCallback onPickAttachment;
  final ValueChanged<String> onRemoveAttachment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hintColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return AssociationFormSection(
      title: l10n.associationLinkAttachmentsSection,
      icon: Icons.attach_file_rounded,
      children: [
        if (attachments.isEmpty)
          Text(
            l10n.associationLinkNoAttachments,
            style: theme.textTheme.bodySmall?.copyWith(color: hintColor),
          ),
        for (final attachment in attachments) ...[
          SizedBox(height: 14.h),
          AttachmentTile(
            attachment: attachment,
            descriptionController:
                attachmentDescriptionControllers[attachment.id]!,
            enabled: enabled,
            onDelete: () => onRemoveAttachment(attachment.id),
          ),
        ],
        if (enabled) ...[
          SizedBox(height: 14.h),
          OutlinedButton.icon(
            onPressed: onPickAttachment,
            icon: const Icon(Icons.add_rounded),
            label: Text(l10n.associationLinkAddAttachment),
          ),
        ],
      ],
    );
  }
}

class AttachmentTile extends StatelessWidget {
  const AttachmentTile({
    super.key,
    required this.attachment,
    required this.descriptionController,
    required this.enabled,
    required this.onDelete,
  });

  final AssociationLinkAttachment attachment;
  final TextEditingController descriptionController;
  final bool enabled;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: theme.colorScheme.onTertiaryFixed.withValues(alpha: 0.2),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Icon(Icons.insert_drive_file_outlined),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  attachment.fileName,
                  style: theme.textTheme.bodyMedium,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (enabled)
                IconButton(
                  onPressed: onDelete,
                  tooltip: l10n.associationLinkDeleteAttachment,
                  icon: const Icon(Icons.delete_outline_rounded),
                ),
            ],
          ),
          SizedBox(height: 8.h),
          AppTextField(
            controller: descriptionController,
            label: l10n.associationLinkAttachmentDescription,
            enabled: enabled,
            validator: enabled
                ? (value) {
                    if (value == null || value.trim().isEmpty) {
                      return l10n.required;
                    }

                    return null;
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
