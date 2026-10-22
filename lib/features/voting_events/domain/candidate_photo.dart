import 'dart:typed_data';

/// Largest photo the server accepts (Storage rule and finalizeCandidatePhoto).
const kMaxCandidatePhotoBytes = 5 * 1024 * 1024;

enum CandidatePhotoProblem { empty, notJpeg, tooLarge }

/// The server stores candidate photos as JPEG only and deletes anything whose
/// first bytes are not FF D8 FF, so check before creating anything remotely.
bool looksLikeJpeg(Uint8List bytes) =>
    bytes.length >= 3 && bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF;

/// null means the photo is acceptable.
CandidatePhotoProblem? checkCandidatePhoto(Uint8List bytes) {
  if (bytes.isEmpty) return CandidatePhotoProblem.empty;
  if (bytes.length > kMaxCandidatePhotoBytes) return CandidatePhotoProblem.tooLarge;
  if (!looksLikeJpeg(bytes)) return CandidatePhotoProblem.notJpeg;
  return null;
}

String candidatePhotoMessage(CandidatePhotoProblem p) => switch (p) {
      CandidatePhotoProblem.empty => 'That image is empty. Choose another photo.',
      CandidatePhotoProblem.notJpeg => 'Candidate photos must be JPEG (.jpg) images. Choose a JPEG photo.',
      CandidatePhotoProblem.tooLarge => 'That photo is larger than 5 MB. Choose a smaller one.',
    };
