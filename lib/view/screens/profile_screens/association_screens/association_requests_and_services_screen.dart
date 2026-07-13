import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:kalivra/controller/blocs/cubit/address_info_cubit/address_info_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/controller/prefs/pref_keys.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_attachment_type.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_request_address.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/association/association_dropdown_field.dart';
import 'package:kalivra/view/widgets/association/association_form_section.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/profile_page/screen_app_bar.dart';

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
    "pdf",
    "jpg",
    "jpeg",
    "png",
    "webp",
    "doc",
    "docx",
  ];

  late final AssociationLinkCubit _associationLinkCubit;

  final _formKey = GlobalKey<FormState>();

  final _messageController = TextEditingController();

  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _nationalIdController = TextEditingController();

  final _streetController = TextEditingController();
  final _streetNumberController = TextEditingController();
  final _buildingController = TextEditingController();
  final _currentAddress = _AssociationAddressInput();
  final List<_AssociationAddressInput> _additionalAddresses = [];

  final _membershipNumberController = TextEditingController();
  final _priorityNumberController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _housingUnitController = TextEditingController();
  final _villageController = TextEditingController();

  final List<AssociationLinkAttachment> _attachments = [];

  final Map<String, String?> _attachmentTypeIds = {};

  final List<dynamic> _requestTypes = [];
  final List<AssociationAttachmentType> _attachmentTypes = [];

  String? _requestType;
  String? _selectedGovernorate;
  String? _selectedCity;
  String? _selectedTown;
  String? _accountPhone;

  bool _hasCurrentAddress = false;
  final bool _isLocked = false;

  bool get _isMembershipRequest => _requestType == _membershipRequestType;

  bool get _hasSelectedGeneralRequest =>
      _requestType != null && !_isMembershipRequest;

  bool get _hasSelectedAnyRequest => _requestType != null;

  @override
  void initState() {
    super.initState();

    _associationLinkCubit = AssociationLinkCubit()..fetchRequestTypes();
  }

  @override
  void dispose() {
    _associationLinkCubit.close();

    _messageController.dispose();

    _fatherNameController.dispose();
    _motherNameController.dispose();
    _nationalIdController.dispose();

    _streetController.dispose();
    _streetNumberController.dispose();
    _buildingController.dispose();
    _currentAddress.dispose();

    for (final address in _additionalAddresses) {
      address.dispose();
    }

    _membershipNumberController.dispose();
    _priorityNumberController.dispose();
    _projectNameController.dispose();
    _housingUnitController.dispose();
    _villageController.dispose();

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

      _attachmentTypeIds.clear();
    });
  }

  void _onGovernorateChanged(String? value) {
    setState(() {
      _selectedGovernorate = value;
      _selectedCity = null;
      _selectedTown = null;
    });
  }

  void _onCityChanged(String? value) {
    setState(() {
      _selectedCity = value;
      _selectedTown = null;
    });
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
        _attachments.add(AssociationLinkAttachment(file: file));
      });
    }
  }

  void _removeAttachment(String name) {
    if (_isLocked) return;

    setState(() {
      _attachments.removeWhere((attachment) => attachment.fileName == name);
      _attachmentTypeIds.remove(name);
    });
  }

  void _onAttachmentTypeChanged(String id, String? value) {
    setState(() {
      _attachmentTypeIds[id] = value;
    });
  }

  void _addAdditionalAddress() {
    if (_isLocked) return;

    setState(() {
      if (_hasCurrentAddress) {
        _additionalAddresses.add(_AssociationAddressInput());
      } else {
        _hasCurrentAddress = true;
      }
    });
  }

  void _removeAdditionalAddress(int index) {
    if (_isLocked) return;

    setState(() {
      _additionalAddresses.removeAt(index).dispose();
    });
  }

  void _removeCurrentAddress() {
    if (_isLocked) return;

    setState(() {
      _hasCurrentAddress = false;
      _currentAddress.clear();
    });
  }

  List<AssociationLinkAttachment> _attachmentsWithTypes() {
    return _attachments.map((attachment) {
      return attachment.copyWith(
        attachmentTypeId: _attachmentTypeIds[attachment.fileName],
      );
    }).toList();
  }

  AssociationRequestAddress _permanentAddress() {
    return AssociationRequestAddress(
      capitalId: _selectedGovernorate,
      cityId: _selectedCity,
      townId: _selectedTown,
      village: _villageController.text.trim(),
      streetName: _streetController.text.trim(),
      streetNumber: _streetNumberController.text.trim(),
      building: _buildingController.text.trim(),
    );
  }

  AssociationRequestAddress _currentRequestAddress() {
    if (!_hasCurrentAddress) return _permanentAddress();
    return _currentAddress.toRequestAddress();
  }

  List<AssociationRequestAddress> _additionalRequestAddresses() {
    return _additionalAddresses
        .map((address) => address.toRequestAddress(includeDetails: true))
        .toList();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    try {
      if (_isMembershipRequest) {
        await _associationLinkCubit.submitLinkRequest(
          context: context,
          customerNote: _messageController.text.trim(),
          type: _membershipRequestType,
          fatherName: _fatherNameController.text.trim(),
          motherName: _motherNameController.text.trim(),
          nationalId: _nationalIdController.text.trim(),
          permanentAddress: _permanentAddress(),
          currentAddress: _currentRequestAddress(),
          additionalAddresses: _additionalRequestAddresses(),
          claimedMembershipNumber: _membershipNumberController.text.trim(),
          claimedPriorityNumber: _priorityNumberController.text.trim(),
          claimedBuildingNumber: _buildingController.text.trim(),
          claimedUnitNumber: _housingUnitController.text.trim(),
          attachments: _attachmentsWithTypes(),
        );
      } else {
        await _associationLinkCubit.submitNormalRequest(
          context: context,
          type: _requestType!,
          customerNote: _messageController.text.trim(),
          attachments: _attachmentsWithTypes(),
        );
      }
    } catch (e) {
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
          attachmentTypes: _attachmentTypes,
          attachmentTypeIds: _attachmentTypeIds,
          enabled: !_isLocked,
          onPickAttachment: _pickAttachment,
          onRemoveAttachment: _removeAttachment,
          onAttachmentTypeChanged: _onAttachmentTypeChanged,
        ),
      ],
    );
  }

  Widget _buildSubmitButton({required AssociationLinkState state}) {
    final isSubmitting =
        state is AssociationLinkLoading && _requestTypes.isNotEmpty;

    return Padding(
      padding: EdgeInsets.only(top: 20.h, bottom: 16.h),
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
              _associationLinkCubit.fetchAttachmentTypes();
            }

            if (state is AssociationAttachmentTypesFetched) {
              setState(() {
                _attachmentTypes
                  ..clear()
                  ..addAll(state.attachmentTypes);
              });
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
                    _AssociationLinkRequestSection(
                      isLocked: _isLocked,
                      hasSelectedGeneralRequest: _hasSelectedGeneralRequest,
                      fatherNameController: _fatherNameController,
                      motherNameController: _motherNameController,
                      nationalIdController: _nationalIdController,
                      customerNoteController: _messageController,
                      selectedGovernorate: _selectedGovernorate,
                      selectedCity: _selectedCity,
                      selectedTown: _selectedTown,
                      streetController: _streetController,
                      streetNumberController: _streetNumberController,
                      buildingController: _buildingController,
                      hasCurrentAddress: _hasCurrentAddress,
                      currentAddress: _currentAddress,
                      additionalAddresses: _additionalAddresses,
                      membershipNumberController: _membershipNumberController,
                      priorityNumberController: _priorityNumberController,
                      projectNameController: _projectNameController,
                      housingUnitController: _housingUnitController,
                      villageController: _villageController,
                      attachments: _attachments,
                      attachmentTypes: _attachmentTypes,
                      attachmentTypeIds: _attachmentTypeIds,
                      onGovernorateChanged: _onGovernorateChanged,
                      onCityChanged: _onCityChanged,
                      onTownChanged: _onTownChanged,

                      onAddAdditionalAddress: _addAdditionalAddress,
                      onRemoveAdditionalAddress: _removeAdditionalAddress,
                      onRemoveCurrentAddress: _removeCurrentAddress,
                      onPickAttachment: _pickAttachment,
                      onRemoveAttachment: _removeAttachment,
                      onAttachmentTypeChanged: _onAttachmentTypeChanged,
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
                    _buildSubmitButton(state: state),
                  ],
                  if (_hasSelectedGeneralRequest) ...[
                    _buildGeneralRequestFields(
                      l10n: l10n,
                      theme: theme,
                      isDark: isDark,
                    ),
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

class _AssociationLinkRequestSection extends StatefulWidget {
  const _AssociationLinkRequestSection({
    required this.fatherNameController,
    required this.motherNameController,
    required this.nationalIdController,
    required this.customerNoteController,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.selectedTown,
    required this.streetController,
    required this.streetNumberController,
    required this.buildingController,
    required this.hasCurrentAddress,
    required this.currentAddress,
    required this.additionalAddresses,
    required this.membershipNumberController,
    required this.priorityNumberController,
    required this.projectNameController,
    required this.housingUnitController,
    required this.villageController,
    required this.attachments,
    required this.attachmentTypes,
    required this.attachmentTypeIds,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onTownChanged,
    required this.onAddAdditionalAddress,
    required this.onRemoveAdditionalAddress,
    required this.onRemoveCurrentAddress,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
    required this.onAttachmentTypeChanged,
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
  final TextEditingController customerNoteController;

  final String? selectedGovernorate;
  final String? selectedCity;
  final String? selectedTown;

  final TextEditingController streetController;
  final TextEditingController streetNumberController;
  final TextEditingController buildingController;
  final bool hasCurrentAddress;
  final _AssociationAddressInput currentAddress;
  final List<_AssociationAddressInput> additionalAddresses;

  final TextEditingController membershipNumberController;
  final TextEditingController priorityNumberController;
  final TextEditingController projectNameController;
  final TextEditingController housingUnitController;
  final TextEditingController villageController;

  final List<AssociationLinkAttachment> attachments;
  final List<AssociationAttachmentType> attachmentTypes;
  final Map<String, String?> attachmentTypeIds;

  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onTownChanged;
  final VoidCallback onAddAdditionalAddress;
  final ValueChanged<int> onRemoveAdditionalAddress;
  final VoidCallback onRemoveCurrentAddress;

  final VoidCallback onPickAttachment;
  final ValueChanged<String> onRemoveAttachment;
  final void Function(String id, String? value) onAttachmentTypeChanged;

  final String? Function(String?) validateRequiredName;
  final String? Function(String?) validateRequiredPhone;
  final String? Function(String?) validateOptionalPhone;
  final String? Function(String?) validateOptionalEmail;
  final bool hasSelectedGeneralRequest;

  final Widget Function() fieldSpacer;
  final bool isLocked;

  @override
  State<_AssociationLinkRequestSection> createState() =>
      _AssociationLinkRequestSectionState();
}

class _AssociationLinkRequestSectionState
    extends State<_AssociationLinkRequestSection> {
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
            _AssociationAddressesSection(
              selectedGovernorate: widget.selectedGovernorate,
              selectedCity: widget.selectedCity,
              selectedTown: widget.selectedTown,
              villageController: widget.villageController,
              streetController: widget.streetController,
              streetNumberController: widget.streetNumberController,
              buildingController: widget.buildingController,
              hasCurrentAddress: widget.hasCurrentAddress,
              currentAddress: widget.currentAddress,
              additionalAddresses: widget.additionalAddresses,
              enabled: !widget.isLocked,
              fieldSpacer: widget.fieldSpacer,
              onGovernorateChanged: widget.onGovernorateChanged,
              onCityChanged: widget.onCityChanged,
              onTownChanged: widget.onTownChanged,
              onAddAddress: widget.onAddAdditionalAddress,
              onRemoveAddress: widget.onRemoveAdditionalAddress,
              onRemoveCurrentAddress: widget.onRemoveCurrentAddress,
            ),
          ],
        ),
        AssociationFormSection(
          title: l10n.associationLinkMembershipSection,
          icon: Icons.apartment_outlined,
          children: [
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
        AssociationFormSection(
          title: l10n.messageLabel,
          icon: Icons.message_outlined,
          children: [
            AppTextField(
              controller: widget.customerNoteController,
              label: l10n.messageLabel,
              hint: l10n.associationRequestMessageHint,
              enabled: !widget.isLocked,
              maxLines: 4,
              textInputAction: TextInputAction.newline,
            ),
          ],
        ),
        _RequestAttachmentsSection(
          attachments: widget.attachments,
          attachmentTypes: widget.attachmentTypes,
          attachmentTypeIds: widget.attachmentTypeIds,
          enabled: !widget.isLocked,
          onPickAttachment: widget.onPickAttachment,
          onRemoveAttachment: widget.onRemoveAttachment,
          onAttachmentTypeChanged: widget.onAttachmentTypeChanged,
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

class _AssociationAddressInput {
  final labelController = TextEditingController();
  final typeController = TextEditingController();
  final villageController = TextEditingController();
  final streetController = TextEditingController();
  final streetNumberController = TextEditingController();
  final buildingController = TextEditingController();

  String? selectedGovernorate;
  String? selectedCity;
  String? selectedTown;

  void clear() {
    selectedGovernorate = null;
    selectedCity = null;
    selectedTown = null;
    labelController.clear();
    typeController.clear();
    villageController.clear();
    streetController.clear();
    streetNumberController.clear();
    buildingController.clear();
  }

  AssociationRequestAddress toRequestAddress({bool includeDetails = false}) {
    return AssociationRequestAddress(
      capitalId: selectedGovernorate,
      cityId: selectedCity,
      townId: selectedTown,
      village: villageController.text.trim(),
      streetName: streetController.text.trim(),
      streetNumber: streetNumberController.text.trim(),
      building: buildingController.text.trim(),
      label: includeDetails ? labelController.text.trim() : '',
      type: includeDetails ? typeController.text.trim() : '',
    );
  }

  void dispose() {
    labelController.dispose();
    typeController.dispose();
    villageController.dispose();
    streetController.dispose();
    streetNumberController.dispose();
    buildingController.dispose();
  }
}

class _AssociationAddressesSection extends StatelessWidget {
  const _AssociationAddressesSection({
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.selectedTown,
    required this.villageController,
    required this.streetController,
    required this.streetNumberController,
    required this.buildingController,
    required this.hasCurrentAddress,
    required this.currentAddress,
    required this.additionalAddresses,
    required this.enabled,
    required this.fieldSpacer,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onTownChanged,
    required this.onAddAddress,
    required this.onRemoveAddress,
    required this.onRemoveCurrentAddress,
  });

  final String? selectedGovernorate;
  final String? selectedCity;
  final String? selectedTown;
  final TextEditingController villageController;
  final TextEditingController streetController;
  final TextEditingController streetNumberController;
  final TextEditingController buildingController;
  final bool hasCurrentAddress;
  final _AssociationAddressInput currentAddress;
  final List<_AssociationAddressInput> additionalAddresses;
  final bool enabled;
  final Widget Function() fieldSpacer;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onTownChanged;
  final VoidCallback onAddAddress;
  final ValueChanged<int> onRemoveAddress;
  final VoidCallback onRemoveCurrentAddress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _AddressFormFields(
          title: l10n.associationLinkPermanentAddress,
          selectedGovernorate: selectedGovernorate,
          selectedCity: selectedCity,
          selectedTown: selectedTown,
          villageController: villageController,
          streetController: streetController,
          streetNumberController: streetNumberController,
          buildingController: buildingController,
          enabled: enabled,
          fieldSpacer: fieldSpacer,
          onGovernorateChanged: onGovernorateChanged,
          onCityChanged: onCityChanged,
          onTownChanged: onTownChanged,
        ),
        if (hasCurrentAddress) ...[
          SizedBox(height: 18.h),
          _AddressFormFields(
            title: l10n.associationMemberCurrentAddress,
            selectedGovernorate: currentAddress.selectedGovernorate,
            selectedCity: currentAddress.selectedCity,
            selectedTown: currentAddress.selectedTown,
            villageController: currentAddress.villageController,
            streetController: currentAddress.streetController,
            streetNumberController: currentAddress.streetNumberController,
            buildingController: currentAddress.buildingController,
            enabled: enabled,
            fieldSpacer: fieldSpacer,
            onRemove: onRemoveCurrentAddress,
            onGovernorateChanged: (value) {
              currentAddress.selectedGovernorate = value;
              currentAddress.selectedCity = null;
              currentAddress.selectedTown = null;
            },
            onCityChanged: (value) {
              currentAddress.selectedCity = value;
              currentAddress.selectedTown = null;
            },
            onTownChanged: (value) {
              currentAddress.selectedTown = value;
            },
          ),
        ],
        for (var index = 0; index < additionalAddresses.length; index++) ...[
          SizedBox(height: 18.h),
          _AddressFormFields(
            title: '${l10n.associationAdditionalAddress} ${index + 1}',
            selectedGovernorate: additionalAddresses[index].selectedGovernorate,
            selectedCity: additionalAddresses[index].selectedCity,
            selectedTown: additionalAddresses[index].selectedTown,
            villageController: additionalAddresses[index].villageController,
            streetController: additionalAddresses[index].streetController,
            streetNumberController:
                additionalAddresses[index].streetNumberController,
            buildingController: additionalAddresses[index].buildingController,
            labelController: additionalAddresses[index].labelController,
            typeController: additionalAddresses[index].typeController,
            enabled: enabled,
            fieldSpacer: fieldSpacer,
            onRemove: () => onRemoveAddress(index),
            onGovernorateChanged: (value) {
              additionalAddresses[index].selectedGovernorate = value;
              additionalAddresses[index].selectedCity = null;
              additionalAddresses[index].selectedTown = null;
            },
            onCityChanged: (value) {
              additionalAddresses[index].selectedCity = value;
              additionalAddresses[index].selectedTown = null;
            },
            onTownChanged: (value) {
              additionalAddresses[index].selectedTown = value;
            },
          ),
        ],
        if (enabled) ...[
          SizedBox(height: 14.h),
          OutlinedButton.icon(
            onPressed: onAddAddress,
            icon: const Icon(Icons.add_rounded),
            label: Text(
              hasCurrentAddress
                  ? l10n.associationAdditionalAddress
                  : l10n.associationAddCurrentAddress,
            ),
          ),
        ],
      ],
    );
  }
}

class _AddressFormFields extends StatefulWidget {
  const _AddressFormFields({
    required this.title,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.selectedTown,
    required this.villageController,
    required this.streetController,
    required this.streetNumberController,
    required this.buildingController,
    required this.enabled,
    required this.fieldSpacer,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onTownChanged,
    this.labelController,
    this.typeController,
    this.onRemove,
  });

  final String title;
  final String? selectedGovernorate;
  final String? selectedCity;
  final String? selectedTown;
  final TextEditingController villageController;
  final TextEditingController streetController;
  final TextEditingController streetNumberController;
  final TextEditingController buildingController;
  final TextEditingController? labelController;
  final TextEditingController? typeController;
  final bool enabled;
  final Widget Function() fieldSpacer;
  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onTownChanged;
  final VoidCallback? onRemove;

  @override
  State<_AddressFormFields> createState() => _AddressFormFieldsState();
}

class _AddressFormFieldsState extends State<_AddressFormFields> {
  late final AddressInfoCubit _addressInfoCubit;
  late String? _selectedGovernorate;
  late String? _selectedCity;
  late String? _selectedTown;

  @override
  void initState() {
    super.initState();
    _selectedGovernorate = widget.selectedGovernorate;
    _selectedCity = widget.selectedCity;
    _selectedTown = widget.selectedTown;
    _addressInfoCubit = AddressInfoCubit()..fetchCapitals();
  }

  @override
  void didUpdateWidget(covariant _AddressFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedGovernorate != widget.selectedGovernorate) {
      _selectedGovernorate = widget.selectedGovernorate;
    }
    if (oldWidget.selectedCity != widget.selectedCity) {
      _selectedCity = widget.selectedCity;
    }
    if (oldWidget.selectedTown != widget.selectedTown) {
      _selectedTown = widget.selectedTown;
    }
  }

  @override
  void dispose() {
    _addressInfoCubit.close();
    super.dispose();
  }

  void _onGovernorateChanged(String? value) {
    widget.onGovernorateChanged(value);
    setState(() {
      _selectedGovernorate = value;
      _selectedCity = null;
      _selectedTown = null;
    });
    if (value != null) {
      _addressInfoCubit.fetchCities(capitalId: value);
    }
  }

  void _onCityChanged(String? value) {
    widget.onCityChanged(value);
    setState(() {
      _selectedCity = value;
      _selectedTown = null;
    });
    if (value != null) {
      _addressInfoCubit.fetchTowns(cityId: value);
    }
  }

  void _onTownChanged(String? value) {
    widget.onTownChanged(value);
    setState(() {
      _selectedTown = value;
    });
  }

  String? _requiredValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return AppLocalizations.of(context)!.required;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final labelController = widget.labelController;
    final typeController = widget.typeController;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.title,
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            if (widget.enabled && widget.onRemove != null)
              IconButton(
                onPressed: widget.onRemove,
                tooltip: l10n.associationDeleteAddress,
                icon: const Icon(Icons.delete_outline_rounded),
              ),
          ],
        ),
        SizedBox(height: 12.h),
        if (labelController != null && typeController != null) ...[
          AppTextField(
            controller: labelController,
            label: l10n.associationAddressLabel,
            enabled: widget.enabled,
            validator: _requiredValue,
          ),
          widget.fieldSpacer(),
          AppTextField(
            controller: typeController,
            label: l10n.associationAddressType,
            enabled: widget.enabled,
          ),
          widget.fieldSpacer(),
        ],
        BlocBuilder<AddressInfoCubit, AddressInfoState>(
          bloc: _addressInfoCubit,
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
                  value: _selectedGovernorate,
                  items: addressState.capitals
                      .map((capital) => capital.id)
                      .toList(),
                  itemLabelBuilder: (id) => capitalLabels[id] ?? id,
                  enabled:
                      widget.enabled &&
                      !addressState.isLoadingCapitals &&
                      !addressState.capitalsFailed,
                  trailing: addressState.capitalsFailed
                      ? _AddressReloadButton(
                          onPressed: widget.enabled
                              ? _addressInfoCubit.fetchCapitals
                              : null,
                        )
                      : null,
                  onChanged: _onGovernorateChanged,
                  validator: (value) => value == null ? l10n.required : null,
                ),
                SizedBox(height: 16.h),
                AssociationDropdownField(
                  label: l10n.associationLinkCity,
                  hintText: addressState.isLoadingCities
                      ? l10n.associationAddressLoadingCities
                      : l10n.associationAddressSelectCity,
                  value: _selectedCity,
                  items: addressState.cities.map((city) => city.id).toList(),
                  itemLabelBuilder: (id) => cityLabels[id] ?? id,
                  enabled:
                      widget.enabled &&
                      _selectedGovernorate != null &&
                      !addressState.isLoadingCities &&
                      !addressState.citiesFailed,
                  trailing:
                      addressState.citiesFailed && _selectedGovernorate != null
                      ? _AddressReloadButton(
                          onPressed: widget.enabled
                              ? () => _addressInfoCubit.fetchCities(
                                  capitalId: _selectedGovernorate!,
                                )
                              : null,
                        )
                      : null,
                  onChanged: _onCityChanged,
                  validator: (value) => value == null ? l10n.required : null,
                ),
                SizedBox(height: 16.h),
                AssociationDropdownField(
                  label: l10n.associationLinkTown,
                  hintText: addressState.isLoadingTowns
                      ? l10n.associationAddressLoadingTowns
                      : l10n.associationAddressSelectTown,
                  value: _selectedTown,
                  items: addressState.towns.map((town) => town.id).toList(),
                  itemLabelBuilder: (id) => townLabels[id] ?? id,
                  enabled:
                      widget.enabled &&
                      _selectedCity != null &&
                      !addressState.isLoadingTowns &&
                      !addressState.townsFailed,
                  trailing: addressState.townsFailed && _selectedCity != null
                      ? _AddressReloadButton(
                          onPressed: widget.enabled
                              ? () => _addressInfoCubit.fetchTowns(
                                  cityId: _selectedCity!,
                                )
                              : null,
                        )
                      : null,
                  onChanged: _onTownChanged,
                  validator: (value) => value == null ? l10n.required : null,
                ),
              ],
            );
          },
        ),
        widget.fieldSpacer(),
        AppTextField(
          controller: widget.villageController,
          label: l10n.associationLinkVillage,
          enabled: widget.enabled,
        ),
        widget.fieldSpacer(),
        AppTextField(
          controller: widget.streetController,
          label: l10n.associationLinkStreet,
          enabled: widget.enabled,
          validator: _requiredValue,
        ),
        widget.fieldSpacer(),
        AppTextField(
          controller: widget.streetNumberController,
          label: l10n.associationStreetNumber,
          enabled: widget.enabled,
        ),
        widget.fieldSpacer(),
        AppTextField(
          controller: widget.buildingController,
          label: l10n.associationLinkBuilding,
          enabled: widget.enabled,
          validator: _requiredValue,
        ),
      ],
    );
  }
}

class _RequestAttachmentsSection extends StatelessWidget {
  const _RequestAttachmentsSection({
    required this.attachments,
    required this.attachmentTypes,
    required this.attachmentTypeIds,
    required this.enabled,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
    required this.onAttachmentTypeChanged,
  });

  final List<AssociationLinkAttachment> attachments;
  final List<AssociationAttachmentType> attachmentTypes;
  final Map<String, String?> attachmentTypeIds;
  final bool enabled;
  final VoidCallback onPickAttachment;
  final ValueChanged<String> onRemoveAttachment;
  final void Function(String id, String? value) onAttachmentTypeChanged;

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
            attachmentTypes: attachmentTypes,
            selectedAttachmentTypeId: attachmentTypeIds[attachment.fileName],
            enabled: enabled,
            onDelete: () => onRemoveAttachment(attachment.fileName),
            onAttachmentTypeChanged: (value) =>
                onAttachmentTypeChanged(attachment.fileName, value),
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
    required this.attachmentTypes,
    required this.selectedAttachmentTypeId,
    required this.enabled,
    required this.onDelete,
    required this.onAttachmentTypeChanged,
  });

  final AssociationLinkAttachment attachment;
  final List<AssociationAttachmentType> attachmentTypes;
  final String? selectedAttachmentTypeId;
  final bool enabled;
  final VoidCallback onDelete;
  final ValueChanged<String?> onAttachmentTypeChanged;

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
          AssociationDropdownField(
            label: l10n.associationLinkAttachmentType,
            hintText: l10n.associationLinkAttachmentType,
            value: selectedAttachmentTypeId,
            items: attachmentTypes.map((type) => type.id.toString()).toList(),
            itemLabelBuilder: (id) {
              final isArabic =
                  Localizations.localeOf(context).languageCode ==
                  PrefKeys.arLocaleKey;
              final attachmentType = attachmentTypes.firstWhere(
                (type) => type.id.toString() == id,
              );
              return isArabic ? attachmentType.nameAr : attachmentType.nameEn;
            },
            enabled: enabled,
            onChanged: onAttachmentTypeChanged,
          ),
        ],
      ),
    );
  }
}
