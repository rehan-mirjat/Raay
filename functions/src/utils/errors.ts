import { HttpsError } from "firebase-functions/v2/https";

export function createUnauthenticatedError(message = "Authentication required.") {
  return new HttpsError("unauthenticated", message);
}

export function createPermissionDeniedError(message = "Permission denied.") {
  return new HttpsError("permission-denied", message);
}

export function createInvalidArgumentError(message = "Invalid arguments provided.") {
  return new HttpsError("invalid-argument", message);
}

export function createNotFoundError(message = "Requested resource not found.") {
  return new HttpsError("not-found", message);
}

export function createAlreadyExistsError(message = "Resource already exists.") {
  return new HttpsError("already-exists", message);
}

export function createResourceExhaustedError(message = "Rate limit exceeded. Please try again later.") {
  return new HttpsError("resource-exhausted", message);
}
