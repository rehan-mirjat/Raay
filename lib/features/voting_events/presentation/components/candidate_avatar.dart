import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/raay_colors.dart';
import '../../domain/candidate.dart';

/// Download URL for a candidate photo stored at [path]. The backend stores only
/// the storage path (no permanent token URL); Storage rules decide who may read
/// it. Returns null when the photo is missing or the viewer may not read it.
final candidatePhotoUrlProvider =
    FutureProvider.autoDispose.family<String?, String>((ref, path) async {
  try {
    return await FirebaseStorage.instance.ref(path).getDownloadURL();
  } catch (_) {
    return null;
  }
});

/// Round candidate picture: the photo when there is one and it loads,
/// otherwise the candidate's initial. Never throws on a bad image.
class CandidateAvatar extends ConsumerWidget {
  const CandidateAvatar({
    super.key,
    required this.candidate,
    this.radius = 24,
    this.previewBytes,
  });

  final Candidate candidate;
  final double radius;

  /// A photo chosen but not uploaded yet (shown instead of the saved one).
  final MemoryImage? previewBytes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final kc = RaayColors.of(context);
    final legacy = candidate.photoUrl;
    final path = candidate.photoPath;

    String? url;
    if (previewBytes == null) {
      if (legacy != null && legacy.isNotEmpty) {
        url = legacy;
      } else if (path != null && path.isNotEmpty) {
        url = ref.watch(candidatePhotoUrlProvider(path)).valueOrNull;
      }
    }

    final initial = candidate.name.trim().isEmpty ? '?' : candidate.name.trim()[0].toUpperCase();
    final ImageProvider? image = previewBytes ?? (url == null ? null : NetworkImage(url));

    return Semantics(
      image: true,
      label: candidate.name,
      excludeSemantics: true,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
        backgroundImage: image,
        onBackgroundImageError: image == null ? null : (_, __) {},
        child: image == null
            ? Text(initial,
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontSize: radius * 0.8, color: kc.accentText))
            : null,
      ),
    );
  }
}
