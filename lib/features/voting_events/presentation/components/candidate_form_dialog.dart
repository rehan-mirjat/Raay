import '../../../../l10n/app_localizations.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:raay/core/theme/raay_icons.dart';
import 'package:raay/core/widgets/ui_kit/raay_text_field.dart';

import '../../../../core/theme/raay_colors.dart';
import '../../../../core/widgets/inline_error_banner.dart';
import '../../data/candidate_repository.dart';
import '../../domain/candidate.dart';
import '../../domain/candidate_photo.dart';
import 'candidate_avatar.dart';
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
  ConsumerState<CandidateFormDialog> createState() =>
      _CandidateFormDialogState();
}

class _CandidateFormDialogState extends ConsumerState<CandidateFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _partyCtrl;
  late TextEditingController _bioCtrl;

  Uint8List? _selectedImageBytes;
  bool _isLoading = false;
  String? _error;
  String? _photoError;

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
    if (file == null) return;
    final bytes = await file.readAsBytes();
    if (!mounted) return;
    // Check now (JPEG signature + size) so a bad photo never gets as far as
    // creating a candidate whose photo then fails.
    final problem = checkCandidatePhoto(bytes);
    setState(() {
      if (problem == null) {
        _selectedImageBytes = bytes;
        _photoError = null;
      } else {
        _photoError = candidatePhotoMessage(problem);
      }
    });
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
        final saved = widget.existingCandidate!;
        final changes = changedCandidateText(
          savedName: saved.name,
          savedParty: saved.party,
          savedBio: saved.bio,
          name: _nameCtrl.text,
          party: _partyCtrl.text,
          bio: _bioCtrl.text,
        );
        if (changes.isEmpty && _selectedImageBytes == null) {
          // Nothing to save; just close instead of showing a server error.
          if (mounted) Navigator.pop(context);
          return;
        }
        await repo.updateCandidate(
          candidateId: saved.id,
          name: changes['name'],
          party: changes['party'],
          bio: changes['bio'],
          newPhotoBytes: _selectedImageBytes,
          expectedPhotoPath: _selectedImageBytes != null
              ? saved.photoPath ??
                  'organizations/${widget.orgId}/events/${widget.eventId}/candidates/${saved.id}/photo.jpg'
              : null,
        );
      }
      if (mounted) Navigator.pop(context);
    } on CandidatePhotoException catch (e) {
      // The candidate exists now; keeping the form open would invite a second
      // "add" that the duplicate-name check rejects.
      if (mounted) {
        final messenger = ScaffoldMessenger.of(context);
        Navigator.pop(context);
        messenger.showSnackBar(SnackBar(content: Text(e.message)));
      }
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
    final kc = RaayColors.of(context);

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
                    children: [
                      Expanded(
                        child: Semantics(
                          header: true,
                          child: Text(
                            widget.existingCandidate == null
                                ? AppLocalizations.of(context).cfAdd
                                : AppLocalizations.of(context).cfEdit,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: kc.textPrimary),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: AppLocalizations.of(context).cfClose,
                        constraints:
                            const BoxConstraints(minWidth: 48, minHeight: 48),
                        icon: const Icon(RaayIcons.x, size: 20),
                        onPressed:
                            _isLoading ? null : () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: Column(
                      children: [
                        Semantics(
                          button: true,
                          label: AppLocalizations.of(context).cfPhotoSem,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: _isLoading ? null : _pickImage,
                            child: Stack(
                              alignment: AlignmentDirectional.bottomEnd,
                              children: [
                                CandidateAvatar(
                                  radius: 42,
                                  candidate: widget.existingCandidate ??
                                      Candidate(
                                        id: '',
                                        organizationId: widget.orgId,
                                        votingEventId: widget.eventId,
                                        name: _nameCtrl.text,
                                        party: '',
                                        bio: '',
                                        createdAt: DateTime.now(),
                                        updatedAt: DateTime.now(),
                                      ),
                                  previewBytes: _selectedImageBytes == null
                                      ? null
                                      : MemoryImage(_selectedImageBytes!),
                                ),
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(RaayIcons.camera,
                                      size: 16,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          style: TextButton.styleFrom(
                              minimumSize: const Size(48, 48)),
                          onPressed: _isLoading ? null : _pickImage,
                          child: Text(_selectedImageBytes == null
                              ? AppLocalizations.of(context).cfPhoto
                              : AppLocalizations.of(context).cfPhotoChange),
                        ),
                        if (_photoError != null)
                          Semantics(
                            liveRegion: true,
                            child: Text(_photoError!,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 14, color: kc.errorText)),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  RaayTextField(
                    controller: _nameCtrl,
                    label: AppLocalizations.of(context).cfName,
                    hint: AppLocalizations.of(context).cfNameHint,
                    validator: (v) {
                      final n = v?.trim().length ?? 0;
                      if (n < 2) {
                        return AppLocalizations.of(context).cfNameShort;
                      }
                      if (n > 100) return AppLocalizations.of(context).cf100;
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  RaayTextField(
                    controller: _partyCtrl,
                    label: AppLocalizations.of(context).cfParty,
                    hint: AppLocalizations.of(context).cfPartyHint,
                    validator: (v) => (v?.trim().length ?? 0) > 100
                        ? AppLocalizations.of(context).cf100
                        : null,
                  ),
                  const SizedBox(height: 16),
                  RaayTextField(
                    controller: _bioCtrl,
                    label: AppLocalizations.of(context).cfBio,
                    hint: AppLocalizations.of(context).cfBioHint,
                    maxLines: 3,
                    validator: (v) => (v?.trim().length ?? 0) > 1000
                        ? AppLocalizations.of(context).cf1000
                        : null,
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: 16),
                    InlineErrorBanner(message: _error!),
                  ],
                  const SizedBox(height: 24),
                  Wrap(
                    alignment: WrapAlignment.end,
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            minimumSize: const Size(48, 48)),
                        onPressed:
                            _isLoading ? null : () => Navigator.pop(context),
                        child: Text(AppLocalizations.of(context).cfCancel),
                      ),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                            minimumSize: const Size(48, 48)),
                        onPressed: _isLoading ? null : _submit,
                        icon: _isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2))
                            : const SizedBox.shrink(),
                        label: Text(widget.existingCandidate == null
                            ? AppLocalizations.of(context).cfAdd
                            : AppLocalizations.of(context).cfSave),
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
