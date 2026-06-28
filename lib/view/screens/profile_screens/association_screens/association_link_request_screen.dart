import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
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

class AssociationLinkRequestScreen extends StatefulWidget {
  const AssociationLinkRequestScreen({super.key});

  @override
  State<AssociationLinkRequestScreen> createState() =>
      _AssociationLinkRequestScreenState();
}

class _AssociationLinkRequestScreenState
    extends State<AssociationLinkRequestScreen> {
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

  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _kunyaController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  String? _selectedGovernorate;
  String? _selectedCity;
  String? _selectedTown;
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
  String? _accountPhone;
  bool isLocked = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _bootstrap());
  }

  @override
  void dispose() {
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
    for (final c in _attachmentDescriptionControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _bootstrap() async {
    // Pre-fill phone from authenticated account.
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthFetchedData) {
      _accountPhone = authState.customer.phone;
      if (_mobileController.text.trim().isEmpty) {
        _mobileController.text = authState.customer.phone ?? '';
      }
    }
  }

  String _normalizePhone(String value) => value.replaceAll(RegExp(r'\D'), '');
  bool _isValidPhone(String value) => _normalizePhone(value).length >= 8;
  bool _isValidEmail(String value) =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim());

  String? _validateRequiredName(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) {
      return l10n.associationLinkEnterFirstName;
    }
    return null;
  }

  String? _validateRequiredPhone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return l10n.enterPhone;
    if (!_isValidPhone(value)) return l10n.invalidPhone;
    final accountPhone = _accountPhone;
    if (accountPhone != null &&
        accountPhone.trim().isNotEmpty &&
        _normalizePhone(accountPhone) != _normalizePhone(value)) {
      return l10n.associationLinkPhoneMustMatchAccount;
    }
    return null;
  }

  String? _validateOptionalPhone(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return null;
    if (!_isValidPhone(value)) return l10n.invalidPhone;
    return null;
  }

  String? _validateOptionalEmail(String? value, AppLocalizations l10n) {
    if (value == null || value.trim().isEmpty) return null;
    if (!_isValidEmail(value)) return l10n.invalidEmail;
    return null;
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
    if (isLocked) return;
    final l10n = AppLocalizations.of(context)!;
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
    );
    if (result == null || !mounted) return;

    for (final file in result.files) {
      final path = file.path;
      if (path == null) continue;
      final attachmentFile = File(path);
      final length = await attachmentFile.length();
      if (length > _maxAttachmentBytes) {
        if (!mounted) return;
        CustomSnackBar.show(context, l10n.associationLinkFileTooLarge);
        continue;
      }
      final extension = file.extension?.toLowerCase();
      if (extension == null || !_allowedExtensions.contains(extension)) {
        if (!mounted) return;
        CustomSnackBar.show(context, l10n.associationLinkUnsupportedFileType);
        continue;
      }
      setState(() {
        final id =
            '${DateTime.now().microsecondsSinceEpoch}_${_attachments.length}';
        _attachments.add(
          AssociationLinkAttachment(id: id, file: attachmentFile),
        );
        _attachmentDescriptionControllers[id] = TextEditingController();
      });
    }
  }

  void _removeAttachment(String id) {
    if (isLocked) return;
    setState(() {
      _attachments.removeWhere((a) => a.id == id);
      _attachmentDescriptionControllers.remove(id)?.dispose();
    });
  }

  List<AssociationLinkAttachment> _attachmentsWithDescriptions() {
    return _attachments
        .map(
          (a) => a.copyWith(
            description:
                _attachmentDescriptionControllers[a.id]?.text.trim() ?? '',
          ),
        )
        .toList();
  }

  Future<void> _submit() async {
    try {
      context.read<AssociationLinkCubit>().submitRequest(
        context: context,
        fatherName: _fatherNameController.text,
        motherName: _motherNameController.text,
        officialGovernorate: _selectedGovernorate ?? '',
        officialCity: _selectedCity ?? '',
        officialTown: _selectedTown ?? '',
        officialMunicipalityVillage: _villageController.text,
        officialStreet: _streetController.text,
        officialBuilding: _buildingController.text,
        permanentAddress: _permanentAddressController.text,
        phone: _mobileController.text,
        attachments: _attachmentsWithDescriptions(),
      );
    } catch (e) {
      CustomSnackBar.show(context, e.toString());
    }
  }

  Widget _fieldSpacer() => SizedBox(height: 14.h);
  bool isSubmitting = false;
  bool isLoading = false;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final hintColor = isDark ? AppColors.taupe : AppColors.burgundy;

    return Scaffold(
      appBar: ScreenAppBar(title: l10n.associationLinkRequestTitle),
      body: Column(
        children: [
          Expanded(
            child: Form(
              key: _formKey,
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
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
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: hintColor,
                        ),
                      ),
                    )
                  else
                    Text(
                      l10n.associationLinkRequestHint,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: hintColor,
                      ),
                    ),
                  SizedBox(height: 16.h),
                  AssociationFormSection(
                    title: l10n.associationLinkPersonalSection,
                    icon: Icons.person_outline_rounded,
                    children: [
                      AppTextField(
                        controller: _firstNameController,
                        label: l10n.associationLinkFirstName,
                        enabled: !isLocked,
                        textCapitalization: TextCapitalization.words,
                        validator: (v) => _validateRequiredName(v, l10n),
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _kunyaController,
                        label: l10n.associationLinkKunya,
                        enabled: !isLocked,
                        textCapitalization: TextCapitalization.words,
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _fatherNameController,
                        label: l10n.associationLinkFatherName,
                        enabled: !isLocked,
                        textCapitalization: TextCapitalization.words,
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _motherNameController,
                        label: l10n.associationLinkMotherName,
                        enabled: !isLocked,
                        textCapitalization: TextCapitalization.words,
                      ),
                    ],
                  ),
                  AssociationFormSection(
                    title: l10n.associationLinkContactSection,
                    icon: Icons.location_on_outlined,
                    children: [
                      AssociationDropdownField(
                        label: l10n.associationLinkGovernorate,
                        value: _selectedGovernorate,
                        items: SyrianLocationCatalog.withSavedValue(
                          SyrianLocationCatalog.governorates(),
                          _selectedGovernorate,
                        ),
                        enabled: !isLoading,
                        onChanged: _onGovernorateChanged,
                      ),
                      SizedBox(height: 16.h),

                      AssociationDropdownField(
                        label: l10n.associationLinkCity,
                        value: _selectedCity,
                        items: SyrianLocationCatalog.withSavedValue(
                          SyrianLocationCatalog.cities(_selectedGovernorate),
                          _selectedCity,
                        ),
                        enabled: !isLoading && _selectedGovernorate != null,
                        onChanged: _onCityChanged,
                      ),
                      SizedBox(height: 16.h),
                      AssociationDropdownField(
                        label: l10n.associationLinkTown,
                        value: _selectedTown,
                        items: SyrianLocationCatalog.withSavedValue(
                          SyrianLocationCatalog.towns(
                            _selectedGovernorate,
                            _selectedCity,
                          ),
                          _selectedTown,
                        ),
                        enabled: !isLoading && _selectedCity != null,
                        onChanged: _onTownChanged,
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _villageController,
                        label: l10n.associationLinkVillage,
                        enabled: !isLocked,
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _streetController,
                        label: l10n.associationLinkStreet,
                        enabled: !isLocked,
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _buildingController,
                        label: l10n.associationLinkBuilding,
                        enabled: !isLocked,
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _permanentAddressController,
                        label: l10n.associationLinkPermanentAddress,
                        enabled: !isLocked,
                        maxLines: 2,
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _mobileController,
                        label: l10n.associationLinkMobile,
                        enabled: !isLocked,
                        keyboardType: TextInputType.phone,
                        validator: (v) => _validateRequiredPhone(v, l10n),
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _whatsAppController,
                        label: l10n.associationLinkWhatsApp,
                        enabled: !isLocked,
                        keyboardType: TextInputType.phone,
                        validator: (v) => _validateOptionalPhone(v, l10n),
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _emailController,
                        label: l10n.associationLinkEmail,
                        enabled: !isLocked,
                        keyboardType: TextInputType.emailAddress,
                        validator: (v) => _validateOptionalEmail(v, l10n),
                      ),
                    ],
                  ),
                  // ── Membership section ───────────────────────────
                  AssociationFormSection(
                    title: l10n.associationLinkMembershipSection,
                    icon: Icons.apartment_outlined,
                    children: [
                      _buildTwoColumnRow(
                        start: AppTextField(
                          controller: _membershipNumberController,
                          label: l10n.associationLinkMembershipNumber,
                          enabled: !isLocked,
                          keyboardType: TextInputType.number,
                        ),
                        end: AppTextField(
                          controller: _priorityNumberController,
                          label: l10n.associationLinkPriorityNumber,
                          enabled: !isLocked,
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _projectNameController,
                        label: l10n.associationLinkProjectName,
                        enabled: !isLocked,
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _housingUnitController,
                        label: l10n.associationLinkHousingUnit,
                        enabled: !isLocked,
                      ),
                      _fieldSpacer(),
                      AppTextField(
                        controller: _totalPaymentsController,
                        label: l10n.associationLinkTotalPayments,
                        enabled: !isLocked,
                        keyboardType: TextInputType.number,
                      ),
                    ],
                  ),
                  // ── Attachments section ──────────────────────────
                  AssociationFormSection(
                    title: l10n.associationLinkAttachmentsSection,
                    icon: Icons.attach_file_rounded,
                    children: [
                      if (_attachments.isEmpty)
                        Text(
                          l10n.associationLinkNoAttachments,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: hintColor,
                          ),
                        ),
                      for (final attachment in _attachments) ...[
                        _fieldSpacer(),
                        _AttachmentTile(
                          attachment: attachment,
                          descriptionController:
                              _attachmentDescriptionControllers[attachment.id]!,
                          enabled: !isLocked,
                          onDelete: () => _removeAttachment(attachment.id),
                        ),
                      ],
                      if (!isLocked) ...[
                        _fieldSpacer(),
                        OutlinedButton.icon(
                          onPressed: _pickAttachment,
                          icon: const Icon(Icons.add_rounded),
                          label: Text(l10n.associationLinkAddAttachment),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (!isLocked)
            SafeArea(
              top: false,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
                decoration: BoxDecoration(
                  color: theme.scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: BlocListener<AssociationLinkCubit, AssociationLinkState>(
                  listener: (context, state) {
                    switch (state) {
                      case AssociationLinkLoading():
                        isSubmitting = true;
                      default:
                        isSubmitting = false;
                    }
                  },
                  child: Expanded(
                    child: FilledButton(
                      onPressed: _submit,
                      child: isSubmitting
                          ? SpinKitFadingCircle(
                              color: AppColors.offWhite,
                              size: 20.r,
                            )
                          : Text(l10n.associationLinkSubmit),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({
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
          ),
        ],
      ),
    );
  }
}
