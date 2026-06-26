import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:kalivra/core/app_theme.dart';
import 'package:kalivra/l10n/app_localizations.dart';
import 'package:kalivra/model/association/association_link_attachment.dart';
import 'package:kalivra/view/widgets/app_text_field.dart';
import 'package:kalivra/view/widgets/association/association_form_section.dart';
import 'package:kalivra/view/widgets/custom_snack_bar.dart';
import 'package:kalivra/view/widgets/drawer/drawer_screen_app_bar.dart';

class AssociationRequestsAndServicesScreen extends StatefulWidget {
  const AssociationRequestsAndServicesScreen({super.key});

  @override
  State<AssociationRequestsAndServicesScreen> createState() =>
      _AssociationRequestsAndServicesScreenState();
}

class _AssociationRequestsAndServicesScreenState
    extends State<AssociationRequestsAndServicesScreen> {
  static const _allowedExtensions = ['pdf', 'jpg', 'jpeg', 'png', 'webp'];
  static const _maxAttachmentBytes = 8 * 1024 * 1024;

  final _formKey = GlobalKey<FormState>();
  final _messageController = TextEditingController();
  final List<AssociationLinkAttachment> _attachments = [];
  String? _requestType;

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _pickAttachment() async {
    final l10n = AppLocalizations.of(context)!;
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: _allowedExtensions,
    );
    if (result == null || !mounted) return;

    for (final file in result.files) {
      final path = file.path;
      if (path == null) continue;
      final extension = file.extension?.toLowerCase();
      if (extension == null || !_allowedExtensions.contains(extension)) {
        CustomSnackBar.show(context, l10n.associationLinkUnsupportedFileType);
        continue;
      }
      final attachmentFile = File(path);
      if (await attachmentFile.length() > _maxAttachmentBytes) {
        if (!mounted) return;
        CustomSnackBar.show(context, l10n.associationLinkFileTooLarge);
        continue;
      }
      if (!mounted) return;
      setState(() {
        _attachments.add(
          AssociationLinkAttachment(
            id: '${DateTime.now().microsecondsSinceEpoch}_${_attachments.length}',
            file: attachmentFile,
          ),
        );
      });
    }
  }

  void _removeAttachment(String id) {
    setState(() => _attachments.removeWhere((item) => item.id == id));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final requestTypes = [
      (value: 'maintenance', label: 'Maintenance'),
      (value: 'financial', label: 'Financial'),
      (value: 'documents', label: 'Documents'),
      (value: 'complaint', label: 'Complaint'),
      (value: 'other', label: 'TypeOther'),
    ];

    return Scaffold(
      appBar: DrawerScreenAppBar(title: l10n.associationRequestsAndServices),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(20.w, 18.h, 20.w, 28.h),
                children: [
                  SizedBox(height: 18.h),
                  AssociationFormSection(
                    title: l10n.associationRequestsAndServices,
                    icon: Icons.assignment_outlined,
                    children: [
                      DropdownButtonFormField<String>(
                        initialValue: _requestType,
                        decoration: InputDecoration(
                          labelText: l10n.associationRequestTypeHint,
                          prefixIcon: Icon(
                            Icons.category_outlined,
                            color: isDark
                                ? AppColors.taupe
                                : AppColors.burgundy,
                          ),
                        ),
                        items: requestTypes
                            .map(
                              (item) => DropdownMenuItem(
                                alignment: Alignment.center,
                                value: item.value,
                                child: Text(item.label),
                              ),
                            )
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _requestType = value),
                        validator: (value) => value == null
                            ? l10n.associationRequestTypeOrMessageRequired
                            : null,
                      ),
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
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                            ? l10n.associationRequestTypeOrMessageRequired
                            : null,
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  AssociationFormSection(
                    title: l10n.associationLinkAttachmentsSection,
                    icon: Icons.attach_file_rounded,
                    children: [
                      if (_attachments.isEmpty)
                        Text(
                          l10n.associationLinkNoAttachments,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.62,
                            ),
                          ),
                        ),
                      for (final attachment in _attachments) ...[
                        SizedBox(height: 12.h),
                        _AttachmentTile(
                          attachment: attachment,
                          onDelete: () => _removeAttachment(attachment.id),
                        ),
                      ],
                      SizedBox(height: 14.h),
                      OutlinedButton.icon(
                        onPressed: _pickAttachment,
                        icon: const Icon(Icons.add_rounded),
                        label: Text(l10n.associationLinkAddAttachment),
                      ),
                    ],
                  ),
                ],
              ),
            ),
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
                      blurRadius: 14,
                      offset: const Offset(0, -5),
                    ),
                  ],
                ),
                child: FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.send_rounded),
                  label: Text(l10n.associationLinkSubmit),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AttachmentTile extends StatelessWidget {
  const _AttachmentTile({required this.attachment, required this.onDelete});

  final AssociationLinkAttachment attachment;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 38.w,
            height: 38.w,
            decoration: BoxDecoration(
              color: AppColors.burgundy.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: const Icon(Icons.insert_drive_file_outlined),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              attachment.fileName,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline_rounded),
          ),
        ],
      ),
    );
  }
}
