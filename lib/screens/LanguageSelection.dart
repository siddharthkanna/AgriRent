// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LanguageSelectionScreen extends StatefulWidget {
  @override
  _LanguageSelectionScreenState createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  Locale _selectedLocale = const Locale('en');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose your Language", style: TextStyle(fontSize: 16)),
      ),
      body: ListView(
        children: [
          _buildLanguageOption(context, 'English', const Locale('en')),
          _buildLanguageOption(context, 'Telugu', const Locale('te')),
          _buildLanguageOption(context, 'Hindi', const Locale('hi')),
          _buildLanguageOption(context, 'Tamil', const Locale('ta')),
          _buildLanguageOption(context, 'Kannada', const Locale('kn')),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String language, Locale locale) {
    return RadioListTile<Locale>(
      title: Text(language),
      value: locale,
      groupValue: _selectedLocale,
      onChanged: (Locale? value) {
        setState(() {
          if (value != null) {
            _selectedLocale = value;
            _changeLanguage(value, context);
          }
        });
      },
    );
  }

  void _changeLanguage(Locale locale, BuildContext context) {
    // Implement logic to change language
  }
}
