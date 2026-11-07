import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../services/firebase_service.dart';

final pendingSalesOfferProvider = StateProvider<String?>((ref) => null);

class SalesInquiryException implements Exception {
  const SalesInquiryException(this.message);
  final String message;
}

class SalesRepository {
  Future<String> request(Map<String, dynamic> data) async {
    try {
      final response = await FirebaseService()
          .functions
          .httpsCallable('requestSalesInquiry')
          .call(data);
      final id = response.data is Map ? response.data['reportId'] : null;
      if (id is! String || id.isEmpty) {
        throw const SalesInquiryException(
            'The service did not confirm your request. Check My requests before retrying.');
      }
      return id;
    } on FirebaseFunctionsException catch (error) {
      throw SalesInquiryException(switch (error.code) {
        'resource-exhausted' =>
          'You have reached today’s request limit. Please follow up through My requests.',
        'unauthenticated' =>
          'Please sign in again before sending your request.',
        'failed-precondition' =>
          'Verify your account email, then send your request again.',
        'permission-denied' =>
          'Only an owner or administrator may request a package for the selected organization.',
        'invalid-argument' =>
          'Check your organization name, voter count and election date.',
        'already-exists' =>
          'This request has already been submitted with different details. Open My requests to review it.',
        _ =>
          'Could not submit your request. Check your connection and try again. Your retry uses the same request reference.',
      });
    }
  }
}

final salesRepositoryProvider = Provider((ref) => SalesRepository());
