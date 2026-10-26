import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FallbackMaterialLocalizationDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'sd';

  @override
  Future<MaterialLocalizations> load(Locale locale) async =>
      const DefaultMaterialLocalizations();

  @override
  bool shouldReload(
          covariant LocalizationsDelegate<MaterialLocalizations> old) =>
      false;
}

class FallbackCupertinoLocalizationDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'sd';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async =>
      const DefaultCupertinoLocalizations();

  @override
  bool shouldReload(
          covariant LocalizationsDelegate<CupertinoLocalizations> old) =>
      false;
}

/// Flutter ships no widgets localization for Sindhi, so without this the app
/// falls back to left-to-right even though Sindhi is written right-to-left.
class FallbackWidgetsLocalizationDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const FallbackWidgetsLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'sd';

  @override
  Future<WidgetsLocalizations> load(Locale locale) async =>
      const _SindhiWidgetsLocalizations();

  @override
  bool shouldReload(
          covariant LocalizationsDelegate<WidgetsLocalizations> old) =>
      false;
}

class _SindhiWidgetsLocalizations extends DefaultWidgetsLocalizations {
  const _SindhiWidgetsLocalizations();

  @override
  TextDirection get textDirection => TextDirection.rtl;
}
