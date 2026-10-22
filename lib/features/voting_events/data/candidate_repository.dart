import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../../services/firebase_service.dart';
import '../../../core/utils/error_utils.dart';
import '../domain/candidate.dart';
import '../domain/candidate_photo.dart';

/// The candidate itself was saved but its photo was not. Callers should treat
/// the candidate as created (retrying "add" would hit the duplicate-name check).
class CandidatePhotoException implements Exception {
  const CandidatePhotoException(this.message);
  final String message;
  @override
  String toString() => 'Exception: $message';
}

class CandidateRepository {
  final FirebaseService _firebase = FirebaseService();

  Future<void> createCandidateWithPhoto({
    required String organizationId,
    required String votingEventId,
    required String name,
    String? party,
    String? bio,
    Uint8List? photoBytes,
  }) async {
    // Reject a bad photo BEFORE creating anything remotely.
    if (photoBytes != null) {
      final problem = checkCandidatePhoto(photoBytes);
      if (problem != null) throw Exception(candidatePhotoMessage(problem));
    }
    String candidateId;
    String? expectedPhotoPath;
    try {
      final createCallable = _firebase.functions.httpsCallable('createCandidate');
      final result = await createCallable.call({
        'organizationId': organizationId,
        'votingEventId': votingEventId,
        'name': name,
        if (party != null && party.isNotEmpty) 'party': party,
        if (bio != null && bio.isNotEmpty) 'bio': bio,
      });

      candidateId = result.data['candidateId'] as String;
      expectedPhotoPath = result.data['expectedPhotoPath'] as String?;
    } catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    }

    if (photoBytes != null && expectedPhotoPath != null) {
      try {
        final storageRef = FirebaseStorage.instance.ref().child(expectedPhotoPath);
        await storageRef.putData(photoBytes, SettableMetadata(contentType: 'image/jpeg'));
        final finalizeCallable = _firebase.functions.httpsCallable('finalizeCandidatePhoto');
        await finalizeCallable.call({'candidateId': candidateId});
      } catch (_) {
        throw const CandidatePhotoException(
            'The candidate was added, but the photo could not be uploaded. Edit the candidate to try the photo again.');
      }
    }
  }

  Future<void> updateCandidate({
    required String candidateId,
    String? name,
    String? party,
    String? bio,
    Uint8List? newPhotoBytes,
    String? expectedPhotoPath, // Required if uploading a new photo
  }) async {
    if (newPhotoBytes != null) {
      final problem = checkCandidatePhoto(newPhotoBytes);
      if (problem != null) throw Exception(candidatePhotoMessage(problem));
    }
    try {
      // Only call the server when text actually changed; it rejects an
      // update with nothing to change.
      if (name != null || party != null || bio != null) {
        final updateCallable = _firebase.functions.httpsCallable('updateCandidate');
        await updateCallable.call({
          'candidateId': candidateId,
          if (name != null) 'name': name,
          if (party != null) 'party': party,
          if (bio != null) 'bio': bio,
        });
      }

      if (newPhotoBytes != null && expectedPhotoPath != null) {
        // Upload over the same path first; the old photo is only replaced once
        // the new bytes are in place (deleting first used to lose the old
        // photo whenever the new upload failed).
        final storageRef = FirebaseStorage.instance.ref().child(expectedPhotoPath);
        await storageRef.putData(newPhotoBytes, SettableMetadata(contentType: 'image/jpeg'));

        final finalizeCallable = _firebase.functions.httpsCallable('finalizeCandidatePhoto');
        await finalizeCallable.call({'candidateId': candidateId});
      }
    } catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    }
  }

  Future<void> deleteCandidatePhoto(String candidateId) async {
    try {
      final callable = _firebase.functions.httpsCallable('deleteCandidatePhoto');
      await callable.call({'candidateId': candidateId});
    } catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    }
  }

  Future<void> deleteCandidate(String candidateId) async {
    try {
      final callable = _firebase.functions.httpsCallable('deleteCandidate');
      await callable.call({'candidateId': candidateId});
    } catch (e) {
      throw Exception(mapFirebaseFunctionsError(e));
    }
  }

  Stream<List<Candidate>> watchEventCandidates(String eventId) {
    return _firebase.firestore
        .collection('candidates')
        .where('votingEventId', isEqualTo: eventId)
        .orderBy('name') // FR-CAN-06
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Candidate.fromFirestore(doc)).toList());
  }
}

final candidateRepositoryProvider = Provider((ref) => CandidateRepository());
