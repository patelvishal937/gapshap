import 'package:flutter/material.dart';
import 'package:translator/translator.dart';

class Translations {
  static final languages = <String>[
    'en',
    'gu',
    'hi',
    'it',
    'fr',
    'ru',
    'de',
    'es', 
  ];

  static String getLanguageCode(String language) {
    switch (language) {
      case 'English':
        return 'en';
      case 'French':
        return 'fr';
      case 'Italian':
        return 'it';
      case 'Russian':
        return 'ru';
      case 'Spanish':
        return 'es';
      case 'German':
        return 'de';
      default:
        return 'en';
    }
  }
}

class Dropdown extends StatelessWidget {
  final String selectedLanguage;
  final ValueChanged<String?> onChanged;

  const Dropdown(
      {super.key, required this.onChanged, required this.selectedLanguage});

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: selectedLanguage,

      // add icon
      icon: const Icon(
        Icons.arrow_drop_down, // Add an arrow icon
        color: Colors.white, // Change the arrow icon color
      ),

      // underline  null
      underline: Container(
        height: null,
      ),

      // dropdownlist
      items: Translations.languages.map((String language) {
        return DropdownMenuItem<String>(
          value: language,
          child: Text(
            language,
            style: const TextStyle(color: Colors.black),
          ),
        );
      }).toList(),
      onChanged: onChanged,
    );
  }
}
