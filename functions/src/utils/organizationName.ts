/**
 * Normalizes an organization name for duplicate detection: case, whitespace,
 * and punctuation differences (e.g. "Acme Corp", "acme corp", "ACME-CORP.")
 * should all collide. This is exact matching on a normalized key, not fuzzy
 * (Levenshtein-style) similarity - Firestore has no text-similarity index,
 * and this project has no external search service (Algolia/Typesense) to
 * provide one.
 */
export function normalizeOrganizationName(name: string): string {
  return name
    .trim()
    .toLowerCase()
    .replace(/[^\p{L}\p{N}]+/gu, " ")
    .trim()
    .replace(/\s+/g, " ");
}
