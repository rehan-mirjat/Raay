import 'package:cloud_functions/cloud_functions.dart';

/// Result of a public receipt lookup. Only [notFound] is a genuine negative:
/// every failure of the service itself is [unavailable] (or [rateLimited]),
/// never presented as "your receipt does not exist".
enum ReceiptVerificationOutcome { verified, notFound, invalidInput, rateLimited, unavailable }

final _sha256Hex = RegExp(r'^[A-Fa-f0-9]{64}$');

bool isValidReceiptHash(String input) => _sha256Hex.hasMatch(input.trim());

/// Maps a thrown error from the `verifyReceipt` callable to an outcome.
ReceiptVerificationOutcome outcomeForVerifyError(Object error) {
  if (error is FirebaseFunctionsException) {
    switch (error.code) {
      case 'not-found':
        return ReceiptVerificationOutcome.notFound;
      case 'invalid-argument':
        return ReceiptVerificationOutcome.invalidInput;
      case 'resource-exhausted':
        return ReceiptVerificationOutcome.rateLimited;
    }
  }
  return ReceiptVerificationOutcome.unavailable;
}
