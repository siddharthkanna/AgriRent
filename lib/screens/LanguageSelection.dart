import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:agrirent/providers/language_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelectionScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = ref.watch(selectedLocaleProvider);
    final updateLocale = ref.read(selectedLocaleProvider.notifier);
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLoc.chooseYourLanguages,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(20.0),
        mainAxisSpacing: 20.0,
        crossAxisSpacing: 20.0,
        children: [
          _buildLanguageOption(context, 'English', const Locale('en'),
              updateLocale, selectedLocale),
          _buildLanguageOption(context, 'Telugu', const Locale('te'),
              updateLocale, selectedLocale),
          _buildLanguageOption(context, 'Hindi', const Locale('hi'),
              updateLocale, selectedLocale),
          _buildLanguageOption(context, 'Tamil', const Locale('ta'),
              updateLocale, selectedLocale),
          _buildLanguageOption(context, 'Kannada', const Locale('kn'),
              updateLocale, selectedLocale),
          _buildLanguageOption(context, 'Malayalam', const Locale('ml'),
              updateLocale, selectedLocale),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String language,
    Locale locale,
    LocaleNotifier updateLocale,
    Locale selectedLocale,
  ) {
    final isSelected = locale == selectedLocale;
    return GestureDetector(
      onTap: () {
        updateLocale.updateLocale(locale);
        _saveLocale(locale);
      },
      child: Container(
        height: 50.0,
        decoration: BoxDecoration(
          color: isSelected ? Palette.red : Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: isSelected ? Colors.red : Colors.black),
        ),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              language,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (language !=
                'English') // Display native language name below English text
              Text(
                _getNativeLanguageName(language),
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.black,
                  fontSize: 14.0, // Adjust font size as needed
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getNativeLanguageName(String language) {
    // Add mappings for other languages as needed
    switch (language) {
      case 'Telugu':
        return 'తెలుగు';
      case 'Hindi':
        return 'हिन्दी';
      case 'Tamil':
        return 'தமிழ்';
      case 'Kannada':
        return 'ಕನ್ನಡ';
      case 'Malayalam':
        return 'മലയാളം';
      default:
        return language;
    }
  }

  void _saveLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('language_code', locale.languageCode);
  }
}
