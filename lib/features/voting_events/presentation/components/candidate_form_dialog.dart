import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kivora/core/theme/app_theme.dart';
import 'package:kivora/core/theme/kivora_icons.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_button.dart';
import 'package:kivora/core/widgets/ui_kit/kivora_text_field.dart';

import '../../../../core/theme/kivora_colors.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../data/candidate_repository.dart';
import '../../domain/candidate.dart';
import '../../../../core/utils/friendly_error.dart';

class CandidateFormDialog extends ConsumerStatefulWidget {
  final String orgId;
  final String eventId;
  final Candidate? existingCandidate;

  const CandidateFormDialog({
    super.key,
    required this.orgId,
    required this.eventId,
    this.existingCandidate,
  });

  @override
  ConsumerState<CandidateFormDialog> createState() => _CandidateFormDialogState();
}

class _CandidateFormDialogState extends ConsumerState<CandidateFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _partyCtrl;
  late TextEditingController _bioCtrl;
  
  Uint8List? _selectedImageBytes;
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existingCandidate?.name);
    _partyCtrl = TextEditingController(text: widget.existingCandidate?.party);
    _bioCtrl = TextEditingController(text: widget.existingCandidate?.bio);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _partyCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    // FR-CAN-03: Client processes image (downscales to max 1024px width, JPEG quality 85%)
    final file = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      imageQuality: 85,
    );
    if (file != null) {
      final bytes = await file.readAsBytes();
      setState(() {
        _selectedImageBytes = bytes;
      });
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final repo = ref.read(candidateRepositoryProvider);
      if (widget.existingCandidate == null) {
        await repo.createCandidateWithPhoto(
          organizationId: widget.orgId,
          votingEventId: widget.eventId,
          name: _nameCtrl.text.trim(),
          party: _partyCtrl.text.trim(),
          bio: _bioCtrl.text.trim(),
          photoBytes: _selectedImageBytes,
        );
      } else {
        await repo.updateCandidate(
          candidateId: widget.existingCandidate!.id,
          name: _nameCtrl.text.trim(),
          party: _partyCtrl.text.trim(),
          bio: _bioCtrl.text.trim(),
          newPhotoBytes: _selectedImageBytes,
          expectedPhotoPath: _selectedImageBytes != null 
              ? widget.existingCandidate!.photoPath ?? 'organizations/${widget.orgId}/events/${widget.eventId}/candidates/${widget.existingCandidate!.id}/photo.jpg'
              : null,
        );
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = friendlyError(e);
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final kc = KivoraColors.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: kc.surface,
      child: SizedBox(
        width: (screenWidth - 80).clamp(280.0, 480.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.existingCandidate == null ? 'Add Candidate' : 'Edit Candidate',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kc.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(KivoraIcons.x, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Semantics(
                          button: true,
                          label: 'Select candidate photo',
                          child: Material(
                            color: Colors.transparent,
                            shape: const CircleBorder(),
                            clipBehavior: Clip.antiAlias,
                            child: InkWell(
                              onTap: _pickImage,
                              child: Container(
                                width: 84,
                                height: 84,
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryBlue.withValues(alpha: 0.1),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: AppTheme.primaryBlue.withValues(alpha: 0.3), width: 1.5),
                                  image: _selectedImageBytes != null
                                      ? DecorationImage(
                                          image: MemoryImage(_selectedImageBytes!),
                                          fit: BoxFit.cover,
                                        )
                                      : (widget.existingCandidate?.photoUrl != null
                                          ? DecorationImage(
                                              image: NetworkImage(widget.existingCandidate!.photoUrl!),
                                              fit: BoxFit.cover,
                                            )
                                          : null),
                                ),
                                child: _selectedImageBytes == null && widget.existingCandidate?.photoUrl == null
                                    ? Icon(KivoraIcons.camera, size: 28, color: KivoraColors.of(context).accentText)
                                    : null,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Tap to upload candidate photo',
                            style: TextStyle(fontSize: 12, color: kc.textSecondary)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  KivoraTextField(
                    controller: _nameCtrl,
                    label: 'Full Name *',
                    hint: 'e.g. Dr. Sarah Jenkins',
                    validator: (v) => v == null || v.trim().length < 3 ? 'Name must be at least 3 characters' : null,
                  ),
                  const SizedBox(height: 16),
                  KivoraTextField(
                    controller: _partyCtrl,
                    label: 'Party / Affiliation (Optional)',
                    hint: 'e.g. Progressive Coalition',
                  ),
                  const SizedBox(height: 16),
                  KivoraTextField(
                    controller: _bioCtrl,
                    label: 'Candidate Bio / Vision Statement (Optional)',
                    hint: 'Brief summary of experience and objectives...',
                    maxLines: 3,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    InlineErrorBanner(message: _error!),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: KivoraButton(
                          type: KivoraButtonType.secondary,
                          label: 'Cancel',
                          onPressed: _isLoading ? null : () => Navigator.pop(context),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: KivoraButton(
                          label: widget.existingCandidate == null ? 'Add Candidate' : 'Save Changes',
                          isLoading: _isLoading,
                          onPressed: _submit,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
