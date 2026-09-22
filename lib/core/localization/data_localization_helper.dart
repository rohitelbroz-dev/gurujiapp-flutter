import 'package:flutter/material.dart';
import 'package:guruji/core/localization/app_strings.dart';

/// Helper to dynamically localize backend database values (relationships, deities, titles, units)
/// based on the user's currently active language in the application.
class DataLocalizationHelper {
  static const Map<String, String> _hindiDataDictionary = {
    // Family Relationships
    'Self': 'स्वयं',
    'self': 'स्वयं',
    'Son': 'पुत्र',
    'son': 'पुत्र',
    'Daughter': 'पुत्री',
    'daughter': 'पुत्री',
    'Father': 'पिता',
    'father': 'पिता',
    'Mother': 'माता',
    'mother': 'माता',
    'Wife': 'पत्नी',
    'wife': 'पत्नी',
    'Husband': 'पति',
    'husband': 'पति',
    'Brother': 'भाई',
    'brother': 'भाई',
    'Sister': 'बहन',
    'sister': 'बहन',
    'Grandfather': 'दादा जी',
    'Grandmother': 'दादी जी',
    'Relative': 'संबंधी',
    'relative': 'संबंधी',
    'Karta (Head of Family)': 'कर्ता (मुखिया)',

    // Deities & Gods
    'Ram': 'श्री राम',
    'Krishna': 'श्री कृष्ण',
    'Shiva': 'भगवान शिव',
    'Hanuman': 'श्री हनुमान',
    'Vishnu': 'श्री विष्णु',
    'Ganesh': 'श्री गणेश',

    // Audio Titles & Mantras
    'Hanuman Chalisa': 'श्री हनुमान चालीसा',
    'Vishnu Sahasranama': 'श्री विष्णु सहस्रनाम',
    'Shiva Tandava Stotram': 'शिव तांडव स्तोत्रम्',
    'Gayatri Mantra': 'गायत्री मंत्र',
    'Shri Ram Stuti': 'श्री राम स्तुति',
    'Ravana': 'रावण',
    'Rigveda Samhita': 'ऋग्वेद संहिता',
    'Goswami Tulsidas': 'गोस्वामी तुलसीदास',

    // Units & Labels
    'mins': 'मिनट',
    'min': 'मिनट',
    'Members': 'सदस्य',
    'Children': 'संतान',
    'Relations': 'संबंध',
    'jaap': 'जप',
    'japs': 'जप',
    'malas': 'माला',
    'mala': 'माला',
  };

  /// Translate a database text dynamically according to the active language
  static String translate(BuildContext context, String? text) {
    if (text == null || text.isEmpty) return '';
    final isHindi = context.currentLang == 'hi';

    if (!isHindi) {
      return text;
    }

    // Direct exact match
    if (_hindiDataDictionary.containsKey(text)) {
      return _hindiDataDictionary[text]!;
    }

    // Replace partial matches like "10 mins" -> "10 मिनट", "1214 jaap" -> "1214 जप"
    String result = text;
    _hindiDataDictionary.forEach((enKey, hiVal) {
      if (result.contains(enKey)) {
        result = result.replaceAll(enKey, hiVal);
      }
    });

    return result;
  }
}

extension DataLocalizationExtension on BuildContext {
  String trData(String? text) => DataLocalizationHelper.translate(this, text);
}
