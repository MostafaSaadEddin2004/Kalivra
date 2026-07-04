import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/controller/blocs/cubit/assoiciation_link_cubit/association_link_cubit.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/location/syrian_location_catalog.dart';
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
    'jpg',
    'jpeg',
    'png',
    'gif',
    'webp',
    'pdf',
    'doc',
    'docx',
    'mp4',
    'mov',
    'avi',
    'mkv',
  ];

  late final AssociationLinkCubit _associationLinkCubit;

  final _formKey = GlobalKey<FormState>();

  final _messageController = TextEditingController();

  final _firstNameController = TextEditingController();
  final _kunyaController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();

  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _permanentAddressController = TextEditingController();
  final _mobileController = TextEditingController();
  final _whatsAppController = TextEditingController();
  final _emailController = TextEditingController();

  final _membershipNumberController = TextEditingController();
  final _priorityNumberController = TextEditingController();
  final _projectNameController = TextEditingController();
  final _housingUnitController = TextEditingController();
  final _totalPaymentsController = TextEditingController();
  final _villageController = TextEditingController();

  final List<AssociationLinkAttachment> _attachments = [];

  final Map<String, TextEditingController> _attachmentDescriptionControllers =
      {};

  final List<dynamic> _requestTypes = [];

  String? _requestType;
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
      _bootstrap();
    });
  }

  @override
  void dispose() {
    _associationLinkCubit.close();

    _messageController.dispose();

    _firstNameController.dispose();
    _kunyaController.dispose();
    _fatherNameController.dispose();
    _motherNameController.dispose();

    _streetController.dispose();
    _buildingController.dispose();
    _permanentAddressController.dispose();
    _mobileController.dispose();
    _whatsAppController.dispose();
    _emailController.dispose();

    _membershipNumberController.dispose();
    _priorityNumberController.dispose();
    _projectNameController.dispose();
    _housingUnitController.dispose();
    _totalPaymentsController.dispose();
    _villageController.dispose();

    for (final controller in _attachmentDescriptionControllers.values) {
      controller.dispose();
    }

    super.dispose();
  }

  Future<void> _bootstrap() async {
    final authState = context.read<AuthCubit>().state;

    if (authState is AuthFetchedData) {
      _accountPhone = authState.customer.phone;

      if (_mobileController.text.trim().isEmpty) {
        _mobileController.text = authState.customer.phone ?? '';
      }
    }
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

  List<AssociationLinkAttachment> _attachmentsWithDescriptions() {
    return _attachments.map((attachment) {
      return attachment.copyWith(
        description:
            _attachmentDescriptionControllers[attachment.id]?.text.trim() ?? '',
      );
    }).toList();
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

    if (_isMembershipRequest && _attachments.isEmpty) {
      CustomSnackBar.show(
        context,
        l10n.associationRequestTypeOrMessageRequired,
      );
      return;
    }

    try {
      if (_isMembershipRequest) {
        await _associationLinkCubit.submitRequest(
          context: context,
          customerNote: _messageController.text.trim(),
          type: _membershipRequestType,
          fatherName: _fatherNameController.text.trim(),
          motherName: _motherNameController.text.trim(),
          permanentCapitalId: _selectedGovernorate,
          permanentCityId: _selectedCity,
          permanentTownId: _selectedTown,
          permanentVillageId: _villageController.text.trim(),
          officialStreet: _streetController.text.trim(),
          officialBuilding: _buildingController.text.trim(),
          permanentAddress: _permanentAddressController.text.trim(),
          phone: _mobileController.text.trim(),
          claimedMembershipNumber: _membershipNumberController.text.trim(),
          claimedPriorityNumber: _priorityNumberController.text.trim(),
          claimedBuildingNumber: _buildingController.text.trim(),
          claimedUnitNumber: _housingUnitController.text.trim(),
          attachments: _attachmentsWithDescriptions(),
        );
      } else {
        await _associationLinkCubit.submitRequest(
          context: context,
          type: _requestType!,
          customerNote: _messageController.text.trim(),
          fatherName: '',
          motherName: '',
          officialStreet: '',
          officialBuilding: '',
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

  Widget _buildTwoColumnRow({required Widget start, required Widget end}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: start),
        SizedBox(width: 12.w),
        Expanded(child: end),
      ],
    );
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

    return DropdownButtonFormField<String>(
      initialValue: selectedValue,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24.r)),
        hintText: isLoadingTypes
            ? 'جاري التحميل'
            : l10n.associationRequestTypeHint,
      ),
      items: isLoadingTypes
          ? const []
          : _requestTypes.map<DropdownMenuItem<String>>((item) {
              return DropdownMenuItem<String>(
                value: item.value,
                child: Text(item.label),
              );
            }).toList(),
      onChanged: isBusy ? null : _onRequestTypeChanged,
      validator: (value) {
        if (value == null) {
          return l10n.associationRequestTypeOrMessageRequired;
        }

        return null;
      },
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
        AppTextField(
          controller: _messageController,
          label: l10n.messageLabel,
          hint: l10n.associationRequestMessageHint,
          maxLines: 6,
          textInputAction: TextInputAction.newline,
          prefixIcon: Icon(
            Icons.notes_rounded,
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
        child: FilledButton.icon(
          onPressed: !_hasSelectedAnyRequest || isSubmitting ? null : _submit,
          icon: isSubmitting
              ? SizedBox(
                  width: 20.r,
                  height: 20.r,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.offWhite,
                  ),
                )
              : const Icon(Icons.send_rounded),
          label: Text(AppLocalizations.of(context)!.associationLinkSubmit),
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
                    AssociationLinkRequestScreen(
                      hasSelectedGeneralRequest: _hasSelectedGeneralRequest,
                      messageController: _messageController,
                      isLocked: _isLocked,
                      firstNameController: _firstNameController,
                      kunyaController: _kunyaController,
                      fatherNameController: _fatherNameController,
                      motherNameController: _motherNameController,
                      selectedGovernorate: _selectedGovernorate,
                      selectedCity: _selectedCity,
                      selectedTown: _selectedTown,
                      streetController: _streetController,
                      buildingController: _buildingController,
                      permanentAddressController: _permanentAddressController,
                      mobileController: _mobileController,
                      whatsAppController: _whatsAppController,
                      emailController: _emailController,
                      membershipNumberController: _membershipNumberController,
                      priorityNumberController: _priorityNumberController,
                      projectNameController: _projectNameController,
                      housingUnitController: _housingUnitController,
                      totalPaymentsController: _totalPaymentsController,
                      villageController: _villageController,
                      attachments: _attachments,
                      attachmentDescriptionControllers:
                          _attachmentDescriptionControllers,
                      onGovernorateChanged: _onGovernorateChanged,
                      onCityChanged: _onCityChanged,
                      onTownChanged: _onTownChanged,
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
                      buildTwoColumnRow: _buildTwoColumnRow,
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

class AssociationLinkRequestScreen extends StatelessWidget {
  const AssociationLinkRequestScreen({
    super.key,
    required this.isLocked,
    required this.firstNameController,
    required this.kunyaController,
    required this.fatherNameController,
    required this.motherNameController,
    required this.selectedGovernorate,
    required this.selectedCity,
    required this.selectedTown,
    required this.streetController,
    required this.buildingController,
    required this.permanentAddressController,
    required this.mobileController,
    required this.whatsAppController,
    required this.emailController,
    required this.membershipNumberController,
    required this.priorityNumberController,
    required this.projectNameController,
    required this.housingUnitController,
    required this.totalPaymentsController,
    required this.villageController,
    required this.attachments,
    required this.attachmentDescriptionControllers,
    required this.onGovernorateChanged,
    required this.onCityChanged,
    required this.onTownChanged,
    required this.onPickAttachment,
    required this.onRemoveAttachment,
    required this.validateRequiredName,
    required this.validateRequiredPhone,
    required this.validateOptionalPhone,
    required this.validateOptionalEmail,
    required this.fieldSpacer,
    required this.buildTwoColumnRow,
    required this.hasSelectedGeneralRequest,
    required this.messageController,
  });

  final bool isLocked;

  final TextEditingController firstNameController;
  final TextEditingController kunyaController;
  final TextEditingController fatherNameController;
  final TextEditingController motherNameController;

  final String? selectedGovernorate;
  final String? selectedCity;
  final String? selectedTown;

  final TextEditingController streetController;
  final TextEditingController buildingController;
  final TextEditingController permanentAddressController;
  final TextEditingController mobileController;
  final TextEditingController whatsAppController;
  final TextEditingController emailController;

  final TextEditingController membershipNumberController;
  final TextEditingController priorityNumberController;
  final TextEditingController projectNameController;
  final TextEditingController housingUnitController;
  final TextEditingController totalPaymentsController;
  final TextEditingController messageController;
  final TextEditingController villageController;

  final List<AssociationLinkAttachment> attachments;
  final Map<String, TextEditingController> attachmentDescriptionControllers;

  final ValueChanged<String?> onGovernorateChanged;
  final ValueChanged<String?> onCityChanged;
  final ValueChanged<String?> onTownChanged;

  final VoidCallback onPickAttachment;
  final ValueChanged<String> onRemoveAttachment;

  final String? Function(String?) validateRequiredName;
  final String? Function(String?) validateRequiredPhone;
  final String? Function(String?) validateOptionalPhone;
  final String? Function(String?) validateOptionalEmail;
  final bool hasSelectedGeneralRequest;

  final Widget Function() fieldSpacer;

  final Widget Function({required Widget start, required Widget end})
  buildTwoColumnRow;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hintColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isLocked)
          Container(
            padding: EdgeInsets.all(14.w),
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: isDark
                  ? AppColors.burgundy.withValues(alpha: 0.2)
                  : AppColors.burgundy.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              l10n.associationLinkSubmittedLocked,
              style: theme.textTheme.bodyMedium?.copyWith(color: hintColor),
            ),
          ),
        AssociationFormSection(
          title: l10n.associationLinkPersonalSection,
          icon: Icons.person_outline_rounded,
          children: [
            AppTextField(
              controller: firstNameController,
              label: l10n.associationLinkFirstName,
              enabled: !isLocked,
              textCapitalization: TextCapitalization.words,
              validator: validateRequiredName,
            ),
            fieldSpacer(),
            AppTextField(
              controller: kunyaController,
              label: l10n.associationLinkKunya,
              enabled: !isLocked,
              textCapitalization: TextCapitalization.words,
            ),
            fieldSpacer(),
            AppTextField(
              controller: fatherNameController,
              label: l10n.associationLinkFatherName,
              enabled: !isLocked,
              textCapitalization: TextCapitalization.words,
              validator: validateRequiredName,
            ),
            fieldSpacer(),
            AppTextField(
              controller: motherNameController,
              label: l10n.associationLinkMotherName,
              enabled: !isLocked,
              textCapitalization: TextCapitalization.words,
              validator: validateRequiredName,
            ),
          ],
        ),
        AssociationFormSection(
          title: l10n.associationLinkContactSection,
          icon: Icons.location_on_outlined,
          children: [
            AssociationDropdownField(
              label: l10n.associationLinkGovernorate,
              value: selectedGovernorate,
              items: SyrianLocationCatalog.withSavedValue(
                SyrianLocationCatalog.governorates(),
                selectedGovernorate,
              ),
              enabled: !isLocked,
              onChanged: onGovernorateChanged,
              validator: (value) => value == null ? l10n.required : null,
            ),
            SizedBox(height: 16.h),
            AssociationDropdownField(
              label: l10n.associationLinkCity,
              value: selectedCity,
              items: SyrianLocationCatalog.withSavedValue(
                SyrianLocationCatalog.cities(selectedGovernorate),
                selectedCity,
              ),
              enabled: !isLocked && selectedGovernorate != null,
              onChanged: onCityChanged,
              validator: (value) => value == null ? l10n.required : null,
            ),
            SizedBox(height: 16.h),
            AssociationDropdownField(
              label: l10n.associationLinkTown,
              value: selectedTown,
              items: SyrianLocationCatalog.withSavedValue(
                SyrianLocationCatalog.towns(selectedGovernorate, selectedCity),
                selectedTown,
              ),
              enabled: !isLocked && selectedCity != null,
              onChanged: onTownChanged,
              validator: (value) => value == null ? l10n.required : null,
            ),
            fieldSpacer(),
            AppTextField(
              controller: villageController,
              label: l10n.associationLinkVillage,
              enabled: !isLocked,
            ),
            fieldSpacer(),
            AppTextField(
              controller: streetController,
              label: l10n.associationLinkStreet,
              enabled: !isLocked,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.required;
                }

                return null;
              },
            ),
            fieldSpacer(),
            AppTextField(
              controller: buildingController,
              label: l10n.associationLinkBuilding,
              enabled: !isLocked,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return l10n.required;
                }

                return null;
              },
            ),
            fieldSpacer(),
            AppTextField(
              controller: permanentAddressController,
              label: l10n.associationLinkPermanentAddress,
              enabled: !isLocked,
              maxLines: 2,
            ),
            fieldSpacer(),
            AppTextField(
              controller: mobileController,
              label: l10n.associationLinkMobile,
              enabled: !isLocked,
              keyboardType: TextInputType.phone,
              validator: validateRequiredPhone,
            ),
            fieldSpacer(),
            AppTextField(
              controller: whatsAppController,
              label: l10n.associationLinkWhatsApp,
              enabled: !isLocked,
              keyboardType: TextInputType.phone,
              validator: validateOptionalPhone,
            ),
            fieldSpacer(),
            AppTextField(
              controller: emailController,
              label: l10n.associationLinkEmail,
              enabled: !isLocked,
              keyboardType: TextInputType.emailAddress,
              validator: validateOptionalEmail,
            ),
          ],
        ),
        AssociationFormSection(
          title: l10n.associationLinkMembershipSection,
          icon: Icons.apartment_outlined,
          children: [
            buildTwoColumnRow(
              start: AppTextField(
                controller: membershipNumberController,
                label: l10n.associationLinkMembershipNumber,
                enabled: !isLocked,
                keyboardType: TextInputType.number,
              ),
              end: AppTextField(
                controller: priorityNumberController,
                label: l10n.associationLinkPriorityNumber,
                enabled: !isLocked,
                keyboardType: TextInputType.number,
              ),
            ),
            fieldSpacer(),
            AppTextField(
              controller: projectNameController,
              label: l10n.associationLinkProjectName,
              enabled: !isLocked,
            ),
            fieldSpacer(),
            AppTextField(
              controller: housingUnitController,
              label: l10n.associationLinkHousingUnit,
              enabled: !isLocked,
            ),
            fieldSpacer(),
            AppTextField(
              controller: totalPaymentsController,
              label: l10n.associationLinkTotalPayments,
              enabled: !isLocked,
              keyboardType: TextInputType.number,
            ),
            fieldSpacer(),
          ],
        ), 
            AppTextField(
              controller: messageController,
              label: l10n.messageLabel,
              hint: l10n.associationRequestMessageHint,
              maxLines: 6,
              textInputAction: TextInputAction.newline,
              prefixIcon: Icon(
                Icons.notes_rounded,
                color: isDark ? AppColors.taupe : AppColors.burgundy,
              ),
              validator: (value) {
                if (hasSelectedGeneralRequest &&
                    (value == null || value.trim().isEmpty)) {
                  return l10n.associationRequestTypeOrMessageRequired;
                }

                return null;
              },
            ),fieldSpacer(),
        _RequestAttachmentsSection(
          attachments: attachments,
          attachmentDescriptionControllers: attachmentDescriptionControllers,
          enabled: !isLocked,
          onPickAttachment: onPickAttachment,
          onRemoveAttachment: onRemoveAttachment,
        ),
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
