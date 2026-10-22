import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class FallbackMaterialLocalizationDelegate extends LocalizationsDelegate<MaterialLocalizations> {
  const FallbackMaterialLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'sd';

  @override
  Future<MaterialLocalizations> load(Locale locale) async => const DefaultMaterialLocalizations();

  @override
  bool shouldReload(covariant LocalizationsDelegate<MaterialLocalizations> old) => false;
}

class FallbackCupertinoLocalizationDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalizationDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'sd';

  @override
  Future<CupertinoLocalizations> load(Locale locale) async => const DefaultCupertinoLocalizations();

  @override
  bool shouldReload(covariant LocalizationsDelegate<CupertinoLocalizations> old) => false;
}
