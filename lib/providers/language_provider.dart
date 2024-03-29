import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier(Locale initialLocale) : super(initialLocale);

  void updateLocale(Locale newLocale) {
    state = newLocale;
  }
}

final selectedLocaleProvider =
    StateNotifierProvider<LocaleNotifier, Locale>(
  (ref) => LocaleNotifier(const Locale('en')),
);
