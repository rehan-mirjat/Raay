/**
 * Strips characters that have no legitimate use in user-supplied plain text
 * but can corrupt how it later renders or is exported:
 *  - C0/C1 control characters (0x00-0x1F, 0x7F-0x9F) - terminal/log injection,
 *    unexpected line breaks in single-line fields.
 *  - Unicode bidi override/embedding/isolate characters (U+202A-U+202E,
 *    U+2066-U+2069) and zero-width/format characters (U+200B-U+200F, U+FEFF,
 *    U+2060) - these let stored text render differently than it reads (the
 *    same class of spoofing as "Trojan Source"), e.g. disguising a display
 *    name in a member list or audit log.
 *
 * This is defense-in-depth, not an HTML/SQL escaper: Firestore writes are
 * parameterized (no injection via field values) and the Flutter client never
 * renders this text as HTML, so no markup-escaping is needed here.
 */
const ZERO_WIDTH_AND_BIDI = /[​-‏‪-‮⁠-⁩﻿]/g;
const CONTROL_CHARS_ALL = /[\u0000-\u001F\u007F-\u009F]/g;
const CONTROL_CHARS_KEEP_NEWLINE = /[\u0000-\u0009\u000B-\u001F\u007F-\u009F]/g;

export function sanitizePlainText(value: string, options: { multiline?: boolean } = {}): string {
  let result = value.replace(ZERO_WIDTH_AND_BIDI, "");

  if (options.multiline) {
    result = result
      .replace(CONTROL_CHARS_KEEP_NEWLINE, "")
      .replace(/\r\n?/g, "\n")
      .replace(/\n{3,}/g, "\n\n")
      .trim()
      .replace(/[ \t]{2,}/g, " ");
  } else {
    result = result
      .replace(CONTROL_CHARS_ALL, "")
      .trim()
      .replace(/\s{2,}/g, " ");
  }

  return result;
}
