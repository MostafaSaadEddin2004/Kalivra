import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:kalivra/controller/blocs/cubit/auth_cubit/auth_cubit.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/model/association/association_link_request_draft.dart';
import 'package:kalivra/model/location/syrian_location_catalog.dart';
import 'package:kalivra/model/services/api/association_link_api_service.dart';
import 'package:kalivra/model/services/association_link_draft_store.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/association/association_dropdown_field.dart';
import 'package:kalivra/view/widgets/association/association_form_section.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

class AssociationLinkRequestScreen extends StatefulWidget {
  const AssociationLinkRequestScreen({
    super.key,
    this.resubmit = false,
    // When non-null the screen edits an existing local draft instead of
    // starting a fresh form.
    this.draftId,
  });

  final bool resubmit;

  /// ID of a local draft to load from [AssociationLinkDraftStore].
  /// When provided [resubmit] is ignored.
  final String? draftId;

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
  final _draftStore = AssociationLinkDraftStore();
  final _apiService = AssociationLinkApiService();

  final _firstNameController = TextEditingController();
  final _kunyaController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  String? _selectedGovernorate;
  String? _selectedCity;
  String? _selectedTown;
  String? _selectedVillage;
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

  final List<AssociationLinkAttachment> _attachments = [];
  final Map<String, TextEditingController> _attachmentDescriptionControllers =
      {};
  String? _accountPhone;

  /// The ID of the draft currently being edited. Null when creating new.
  String? _currentDraftId;

  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isLocked = false;

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

    if (widget.draftId != null) {
      // ── Open an existing local draft ──────────────────────────────────────
      _currentDraftId = widget.draftId;
      final entry = await _draftStore.loadDraft(widget.draftId!);
      if (entry != null) _applyDraft(entry.draft);
    } else if (widget.resubmit) {
      // ── Resubmit: pull latest server request ──────────────────────────────
      await _draftStore.clearSubmitted();
      final latest = await _apiService.fetchDraftsRequests();
      if (latest != null) _applyDraft(latest);
    } else {
      // ── Fresh form: check submitted lock ──────────────────────────────────
      final submitted = await _draftStore.isSubmitted();
      if (submitted) {
        if (!mounted) return;
        setState(() {
          _isLocked = true;
          _isLoading = false;
        });
        return;
      }
    }

    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  void _applyDraft(AssociationLinkRequestDraft draft) {
    _firstNameController.text = draft.firstName;
    _kunyaController.text = draft.kunya;
    _fatherNameController.text = draft.fatherName;
    _motherNameController.text = draft.motherName;
    _selectedGovernorate = draft.governorate.isEmpty ? null : draft.governorate;
    _selectedCity = draft.city.isEmpty ? null : draft.city;
    _selectedTown = draft.town.isEmpty ? null : draft.town;
    _selectedVillage = draft.municipality.isEmpty ? null : draft.municipality;
    _streetController.text = draft.street;
    _buildingController.text = draft.building;
    _permanentAddressController.text = draft.permanentAddress;
    if (draft.mobile.trim().isNotEmpty) {
      _mobileController.text = draft.mobile;
    }
    _whatsAppController.text = draft.whatsApp;
    _emailController.text = draft.email;
    _membershipNumberController.text = draft.membershipNumber;
    _priorityNumberController.text = draft.priorityNumber;
    _projectNameController.text = draft.projectName;
    _housingUnitController.text = draft.housingUnit;
    _totalPaymentsController.text = draft.totalPayments;
  }

  AssociationLinkRequestDraft _currentDraft() {
    return AssociationLinkRequestDraft(
      firstName: _firstNameController.text.trim(),
      kunya: _kunyaController.text.trim(),
      fatherName: _fatherNameController.text.trim(),
      motherName: _motherNameController.text.trim(),
      governorate: _selectedGovernorate?.trim() ?? '',
      city: _selectedCity?.trim() ?? '',
      town: _selectedTown?.trim() ?? '',
      municipality: _selectedVillage?.trim() ?? '',
      street: _streetController.text.trim(),
      building: _buildingController.text.trim(),
      permanentAddress: _permanentAddressController.text.trim(),
      mobile: _mobileController.text.trim(),
      whatsApp: _whatsAppController.text.trim(),
      email: _emailController.text.trim(),
      membershipNumber: _membershipNumberController.text.trim(),
      priorityNumber: _priorityNumberController.text.trim(),
      projectName: _projectNameController.text.trim(),
      housingUnit: _housingUnitController.text.trim(),
      totalPayments: _totalPaymentsController.text.trim(),
    );
  }

  Future<void> _saveDraft() async {
    if (_isLocked) return;
    final entry = await _draftStore.saveDraft(
      _currentDraft(),
      id: _currentDraftId,
    );
    _currentDraftId = entry.id;
    if (!mounted) return;
    CustomSnackBar.show(
      context,
      AppLocalizations.of(context)!.associationLinkDraftSaved,
    );
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

  bool _hasIncompleteOptionalData() {
    final values = [
      _kunyaController.text,
      _fatherNameController.text,
      _motherNameController.text,
      _selectedGovernorate ?? '',
      _selectedCity ?? '',
      _selectedTown ?? '',
      _selectedVillage ?? '',
      _streetController.text,
      _buildingController.text,
      _permanentAddressController.text,
      _whatsAppController.text,
      _emailController.text,
      _membershipNumberController.text,
      _priorityNumberController.text,
      _projectNameController.text,
      _housingUnitController.text,
      _totalPaymentsController.text,
    ];
    return values.any((v) => v.trim().isEmpty);
  }

  Future<bool> _confirmIncompleteSubmission(AppLocalizations l10n) async {
    if (!_hasIncompleteOptionalData() && _attachments.isNotEmpty) return true;
    final shouldContinue = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.associationLinkSubmit),
        content: Text(l10n.associationLinkIncompleteWarning),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(l10n.back),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.associationLinkSubmit),
          ),
        ],
      ),
    );
    return shouldContinue ?? false;
  }

  void _onGovernorateChanged(String? value) {
    setState(() {
      _selectedGovernorate = value;
      _selectedCity = null;
      _selectedTown = null;
      _selectedVillage = null;
    });
  }

  void _onCityChanged(String? value) {
    setState(() {
      _selectedCity = value;
      _selectedTown = null;
      _selectedVillage = null;
    });
  }

  void _onTownChanged(String? value) {
    setState(() {
      _selectedTown = value;
      _selectedVillage = null;
    });
  }

  void _onVillageChanged(String? value) {
    setState(() => _selectedVillage = value);
  }

  Future<void> _pickAttachment() async {
    if (_isLocked) return;
    final l10n = AppLocalizations.of(context)!;
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
      withData: false,
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
    if (_isLocked) return;
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
    if (_isLocked || _isSubmitting) return;
    final l10n = AppLocalizations.of(context)!;
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final shouldContinue = await _confirmIncompleteSubmission(l10n);
    if (!shouldContinue || !mounted) return;

    setState(() => _isSubmitting = true);
    try {
      await _apiService.submitRequest(
        draft: _currentDraft(),
        fatherName: _fatherNameController.text,
        motherName: _motherNameController.text,
        officialGovernorate: _selectedGovernorate ?? '',
        officialCity: _selectedCity ?? '',
        officialTown: _selectedTown ?? '',
        officialMunicipalityVillage: _selectedVillage ?? '',
        officialStreet: _streetController.text,
        officialBuilding: _buildingController.text,
        permanentAddress: _permanentAddressController.text,
        phone: _mobileController.text,
        attachments: _attachmentsWithDescriptions(),
      );

      // Remove the draft from local store once successfully submitted.
      if (_currentDraftId != null) {
        await _draftStore.deleteDraft(_currentDraftId!);
      }
      await _draftStore.markSubmitted();

      if (!mounted) return;
      CustomSnackBar.show(context, l10n.associationLinkRequestSubmitted);
      context.pop();
    } on DioException catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(
        context,
        e.message ?? e.response?.statusMessage ?? l10n.invalidPhone,
      );
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.show(context, e.toString());
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  Widget _fieldSpacer() => SizedBox(height: 14.h);

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
      appBar: DrawerScreenAppBar(
        title: widget.resubmit
            ? l10n.associationLinkResubmit
            : l10n.associationLinkRequestTitle,
        actions: [
          if (!_isLocked)
            TextButton(
              onPressed: _isSubmitting ? null : _saveDraft,
              child: Text(
                l10n.associationLinkSaveDraft,
                style: TextStyle(color: theme.appBarTheme.foregroundColor),
              ),
            )
          else
            SizedBox(width: 48.w),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: ListView(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                      children: [
                        if (_isLocked)
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
                        // ── Personal section ─────────────────────────────
                        AssociationFormSection(
                          title: l10n.associationLinkPersonalSection,
                          icon: Icons.person_outline_rounded,
                          children: [
                            AppTextField(
                              controller: _firstNameController,
                              label: l10n.associationLinkFirstName,
                              enabled: !_isLocked,
                              textCapitalization: TextCapitalization.words,
                              validator: (v) => _validateRequiredName(v, l10n),
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _kunyaController,
                              label: l10n.associationLinkKunya,
                              enabled: !_isLocked,
                              textCapitalization: TextCapitalization.words,
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _fatherNameController,
                              label: l10n.associationLinkFatherName,
                              enabled: !_isLocked,
                              textCapitalization: TextCapitalization.words,
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _motherNameController,
                              label: l10n.associationLinkMotherName,
                              enabled: !_isLocked,
                              textCapitalization: TextCapitalization.words,
                            ),
                          ],
                        ),
                        // ── Contact section ──────────────────────────────
                        AssociationFormSection(
                          title: l10n.associationLinkContactSection,
                          icon: Icons.location_on_outlined,
                          children: [
                            _buildTwoColumnRow(
                              start: AssociationDropdownField(
                                label: l10n.associationLinkGovernorate,
                                value: _selectedGovernorate,
                                items: SyrianLocationCatalog.withSavedValue(
                                  SyrianLocationCatalog.governorates(),
                                  _selectedGovernorate,
                                ),
                                enabled: !_isLocked,
                                onChanged: _onGovernorateChanged,
                              ),
                              end: AssociationDropdownField(
                                label: l10n.associationLinkCity,
                                value: _selectedCity,
                                items: SyrianLocationCatalog.withSavedValue(
                                  SyrianLocationCatalog.cities(
                                    _selectedGovernorate,
                                  ),
                                  _selectedCity,
                                ),
                                enabled: !_isLocked,
                                onChanged: _onCityChanged,
                              ),
                            ),
                            _fieldSpacer(),
                            _buildTwoColumnRow(
                              start: AssociationDropdownField(
                                label: l10n.associationLinkTown,
                                value: _selectedTown,
                                items: SyrianLocationCatalog.withSavedValue(
                                  SyrianLocationCatalog.towns(
                                    _selectedGovernorate,
                                    _selectedCity,
                                  ),
                                  _selectedTown,
                                ),
                                enabled: !_isLocked,
                                onChanged: _onTownChanged,
                              ),
                              end: AssociationDropdownField(
                                label: l10n.associationLinkVillage,
                                value: _selectedVillage,
                                items: SyrianLocationCatalog.withSavedValue(
                                  SyrianLocationCatalog.villages(
                                    _selectedGovernorate,
                                    _selectedCity,
                                    _selectedTown,
                                  ),
                                  _selectedVillage,
                                ),
                                enabled: !_isLocked,
                                onChanged: _onVillageChanged,
                              ),
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _streetController,
                              label: l10n.associationLinkStreet,
                              enabled: !_isLocked,
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _buildingController,
                              label: l10n.associationLinkBuilding,
                              enabled: !_isLocked,
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _permanentAddressController,
                              label: l10n.associationLinkPermanentAddress,
                              enabled: !_isLocked,
                              maxLines: 2,
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _mobileController,
                              label: l10n.associationLinkMobile,
                              enabled: !_isLocked,
                              keyboardType: TextInputType.phone,
                              validator: (v) => _validateRequiredPhone(v, l10n),
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _whatsAppController,
                              label: l10n.associationLinkWhatsApp,
                              enabled: !_isLocked,
                              keyboardType: TextInputType.phone,
                              validator: (v) => _validateOptionalPhone(v, l10n),
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _emailController,
                              label: l10n.associationLinkEmail,
                              enabled: !_isLocked,
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
                                enabled: !_isLocked,
                                keyboardType: TextInputType.number,
                              ),
                              end: AppTextField(
                                controller: _priorityNumberController,
                                label: l10n.associationLinkPriorityNumber,
                                enabled: !_isLocked,
                                keyboardType: TextInputType.number,
                              ),
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _projectNameController,
                              label: l10n.associationLinkProjectName,
                              enabled: !_isLocked,
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _housingUnitController,
                              label: l10n.associationLinkHousingUnit,
                              enabled: !_isLocked,
                            ),
                            _fieldSpacer(),
                            AppTextField(
                              controller: _totalPaymentsController,
                              label: l10n.associationLinkTotalPayments,
                              enabled: !_isLocked,
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
                                    _attachmentDescriptionControllers[attachment
                                        .id]!,
                                enabled: !_isLocked,
                                onDelete: () =>
                                    _removeAttachment(attachment.id),
                              ),
                            ],
                            if (!_isLocked) ...[
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
                if (!_isLocked)
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
                      child: FilledButton(
                        onPressed: _isSubmitting ? null : _submit,
                        child: _isSubmitting
                            ? SizedBox(
                                height: 22.h,
                                width: 22.w,
                                child: const CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(l10n.associationLinkSubmit),
                      ),
                    ),
                  ),
              ],
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Attachment tile (unchanged from original)
// ─────────────────────────────────────────────────────────────────────────────

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
