import 'package:flutter/material.dart';
import 'package:guruji/core/localization/app_strings.dart';

/// Helper to dynamically localize backend database values (relationships, deities, titles, units)
/// based on the user's currently active language in the application.
class DataLocalizationHelper {
  static const Map<String, Map<String, String>> _dataDictionaries = {
    'hi': {
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
      'Grandfather': 'दादा जी / नाना जी',
      'Grandmother': 'दादी जी / नानी जी',
      'Relative': 'संबंधी',
      'relative': 'संबंधी',
      'Karta (Head of Family)': 'मुखिया (कर्ता)',

      // Deities & Gods
      'Ram': 'श्री राम',
      'Krishna': 'श्री कृष्ण',
      'Shiva': 'भगवान शिव',
      'Hanuman': 'श्री हनुमान',
      'Vishnu': 'भगवान विष्णु',
      'Ganesh': 'श्री गणेश',
      'Durga': 'माँ दुर्गा',

      // Audio Titles & Mantras
      'Hanuman Chalisa': 'श्री हनुमान चालीसा',
      'Vishnu Sahasranama': 'विष्णु सहस्रनाम',
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
      'days': 'दिन',
      'day': 'दिन',
    },

    'mr': {
      // Family Relationships
      'Self': 'स्वतः',
      'self': 'स्वतः',
      'Son': 'मुलगा (पुत्र)',
      'son': 'मुलगा (पुत्र)',
      'Daughter': 'मुलगी (कन्या)',
      'daughter': 'मुलगी (कन्या)',
      'Father': 'वडील (पिता)',
      'father': 'वडील (पिता)',
      'Mother': 'आई (माता)',
      'mother': 'आई (माता)',
      'Wife': 'पत्नी',
      'wife': 'पत्नी',
      'Husband': 'पती',
      'husband': 'पती',
      'Brother': 'भाऊ',
      'brother': 'भाऊ',
      'Sister': 'बहीण',
      'sister': 'बहीण',
      'Grandfather': 'आजोबा',
      'Grandmother': 'आजी',
      'Relative': 'नातेवाईक',
      'relative': 'नातेवाईक',
      'Karta (Head of Family)': 'कुटुंबप्रमुख (कर्ता)',

      // Deities & Gods
      'Ram': 'श्री राम',
      'Krishna': 'श्री कृष्ण',
      'Shiva': 'भगवान शिव',
      'Hanuman': 'श्री हनुमान',
      'Vishnu': 'भगवान विष्णू',
      'Ganesh': 'श्री गणेश',
      'Durga': 'आई दुर्गा',

      // Audio Titles & Mantras
      'Hanuman Chalisa': 'श्री हनुमान चालीसा',
      'Vishnu Sahasranama': 'विष्णू सहस्रनाम',
      'Shiva Tandava Stotram': 'शिव तांडव स्तोत्र',
      'Gayatri Mantra': 'गायत्री मंत्र',
      'Shri Ram Stuti': 'श्री राम स्तुती',
      'Ravana': 'रावण',
      'Rigveda Samhita': 'ऋग्वेद संहिता',
      'Goswami Tulsidas': 'गोस्वामी तुलसीदास',

      // Units & Labels
      'mins': 'मिनिटे',
      'min': 'मिनिट',
      'Members': 'सदस्य',
      'Children': 'मुले',
      'Relations': 'नाते',
      'jaap': 'जप',
      'japs': 'जप',
      'malas': 'माळा',
      'mala': 'माळ',
      'days': 'दिवस',
      'day': 'दिवस',
    },

    'gu': {
      // Family Relationships
      'Self': 'પોતે',
      'self': 'પોતે',
      'Son': 'પુત્ર (દીકરો)',
      'son': 'પુત્ર (દીકરો)',
      'Daughter': 'પુત્રી (દીકરી)',
      'daughter': 'પુત્રી (દીકરી)',
      'Father': 'પિતા',
      'father': 'પિતા',
      'Mother': 'માતા',
      'mother': 'માતા',
      'Wife': 'પત્ની',
      'wife': 'પત્ની',
      'Husband': 'પતિ',
      'husband': 'પતિ',
      'Brother': 'ભાઈ',
      'brother': 'ભાઈ',
      'Sister': 'બહેન',
      'sister': 'બહેન',
      'Grandfather': 'દાદા',
      'Grandmother': 'દાદી',
      'Relative': 'સંબંધી',
      'relative': 'સંબંધી',
      'Karta (Head of Family)': 'મોભી (કર્તા)',

      // Deities & Gods
      'Ram': 'શ્રી રામ',
      'Krishna': 'શ્રી કૃષ્ણ',
      'Shiva': 'ભગવાન શિવ',
      'Hanuman': 'શ્રી હનુમાન',
      'Vishnu': 'ભગવાન વિષ્ણુ',
      'Ganesh': 'શ્રી ગણેશ',
      'Durga': 'માં દુર્ગા',

      // Audio Titles & Mantras
      'Hanuman Chalisa': 'શ્રી હનુમાન ચાલીસા',
      'Vishnu Sahasranama': 'વિષ્ણુ સહસ્ત્રનામ',
      'Shiva Tandava Stotram': 'શિવ તાંડવ સ્તોત્રમ',
      'Gayatri Mantra': 'ગાયત્રી મંત્ર',
      'Shri Ram Stuti': 'શ્રી રામ સ્તુતિ',
      'Ravana': 'રાવણ',
      'Rigveda Samhita': 'ઋગ્વેદ સંહિતા',
      'Goswami Tulsidas': 'ગોસ્વામી તુલસીદાસ',

      // Units & Labels
      'mins': 'મિનિટ',
      'min': 'મિનિટ',
      'Members': 'સભ્યો',
      'Children': 'સંતાન',
      'Relations': 'સંબંધો',
      'jaap': 'જાપ',
      'japs': 'જાપ',
      'malas': 'માળા',
      'mala': 'માળા',
      'days': 'દિવસ',
      'day': 'દિવસ',
    },

    'ta': {
      // Family Relationships
      'Self': 'சுய',
      'self': 'சுய',
      'Son': 'மகன்',
      'son': 'மகன்',
      'Daughter': 'மகள்',
      'daughter': 'மகள்',
      'Father': 'தந்தை',
      'father': 'தந்தை',
      'Mother': 'தாய்',
      'mother': 'தாய்',
      'Wife': 'மனைவி',
      'wife': 'மனைவி',
      'Husband': 'கணவர்',
      'husband': 'கணவர்',
      'Brother': 'சகோதரன்',
      'brother': 'சகோதரன்',
      'Sister': 'சகோதரி',
      'sister': 'சகோதரி',
      'Grandfather': 'தாத்தா',
      'Grandmother': 'பாட்டி',
      'Relative': 'உறவினர்',
      'relative': 'உறவினர்',
      'Karta (Head of Family)': 'குடும்பத் தலைவர் (கர்த்தா)',

      // Deities & Gods
      'Ram': 'ஸ்ரீ ராமர்',
      'Krishna': 'ஸ்ரீ கிருஷ்ணர்',
      'Shiva': 'சிவபெருமான்',
      'Hanuman': 'ஸ்ரீ அனுமன்',
      'Vishnu': 'விஷ்ணு பகவான்',
      'Ganesh': 'ஸ்ரீ விநாயகர்',
      'Durga': 'துர்க்கை அம்மன்',

      // Audio Titles & Mantras
      'Hanuman Chalisa': 'ஸ்ரீ ஹனுமான் சாலிசா',
      'Vishnu Sahasranama': 'விஷ்ணு சஹஸ்ரநாமம்',
      'Shiva Tandava Stotram': 'சிவ தாண்டவ ஸ்தோத்திரம்',
      'Gayatri Mantra': 'காயத்ரி மந்திரம்',
      'Shri Ram Stuti': 'ஸ்ரீ ராம ஸ்துதி',
      'Ravana': 'ராவணன்',
      'Rigveda Samhita': 'ரிக்வேத சம்ஹிதை',
      'Goswami Tulsidas': 'கோஸ்வாமி துளசிதாஸ்',

      // Units & Labels
      'mins': 'நிமிடங்கள்',
      'min': 'நிமிடம்',
      'Members': 'உறுப்பினர்கள்',
      'Children': 'குழந்தைகள்',
      'Relations': 'உறவுகள்',
      'jaap': 'ஜபம்',
      'japs': 'ஜபம்',
      'malas': 'மாலைகள்',
      'mala': 'மாலை',
      'days': 'நாட்கள்',
      'day': 'நாள்',
    },

    'te': {
      // Family Relationships
      'Self': 'స్వీయ',
      'self': 'స్వీయ',
      'Son': 'కుమారుడు',
      'son': 'కుమారుడు',
      'Daughter': 'కుమార్తె',
      'daughter': 'కుమార్తె',
      'Father': 'తండ్రి',
      'father': 'తండ్రి',
      'Mother': 'తల్లి',
      'mother': 'తల్లి',
      'Wife': 'భార్య',
      'wife': 'భార్య',
      'Husband': 'భర్త',
      'husband': 'భర్త',
      'Brother': 'సోదరుడు',
      'brother': 'సోదరుడు',
      'Sister': 'సోదరి',
      'sister': 'సోదరి',
      'Grandfather': 'తాతయ్య',
      'Grandmother': 'అమ్మమ్మ / నానమ్మ',
      'Relative': 'బంధువు',
      'relative': 'బంధువు',
      'Karta (Head of Family)': 'కుటుంబ పెద్ద (కర్త)',

      // Deities & Gods
      'Ram': 'శ్రీ రాముడు',
      'Krishna': 'శ్రీ కృష్ణుడు',
      'Shiva': 'పరమ శివుడు',
      'Hanuman': 'శ్రీ హనుమంతుడు',
      'Vishnu': 'శ్రీ మహావిష్ణువు',
      'Ganesh': 'శ్రీ వినాయకుడు',
      'Durga': 'దుర్గా దేవి',

      // Audio Titles & Mantras
      'Hanuman Chalisa': 'శ్రీ హనుమాన్ చాలీసా',
      'Vishnu Sahasranama': 'విష్ణు సహస్రనామం',
      'Shiva Tandava Stotram': 'శివ తాండవ స్తోత్రం',
      'Gayatri Mantra': 'గాయత్రీ మంత్రం',
      'Shri Ram Stuti': 'శ్రీ రామ స్తుతి',
      'Ravana': 'రావణుడు',
      'Rigveda Samhita': 'ఋగ్వేద సంహిత',
      'Goswami Tulsidas': 'గోస్వామి తులసీదాస్',

      // Units & Labels
      'mins': 'నిమిషాలు',
      'min': 'నిమిషం',
      'Members': 'సభ్యులు',
      'Children': 'పిల్లలు',
      'Relations': 'సంబంధాలు',
      'jaap': 'జపం',
      'japs': 'జపం',
      'malas': 'మాలలు',
      'mala': 'మాల',
      'days': 'రోజులు',
      'day': 'రోజు',
    },

    'en': {
      // Family Relationships
      'Self': 'Self',
      'self': 'Self',
      'Son': 'Son',
      'son': 'Son',
      'Daughter': 'Daughter',
      'daughter': 'Daughter',
      'Father': 'Father',
      'father': 'Father',
      'Mother': 'Mother',
      'mother': 'Mother',
      'Wife': 'Wife',
      'wife': 'Wife',
      'Husband': 'Husband',
      'husband': 'Husband',
      'Brother': 'Brother',
      'brother': 'Brother',
      'Sister': 'Sister',
      'sister': 'Sister',
      'Grandfather': 'Grandfather',
      'Grandmother': 'Grandmother',
      'Relative': 'Relative',
      'relative': 'Relative',
      'Karta (Head of Family)': 'Karta (Head of Family)',

      // Deities & Gods
      'Ram': 'Shri Ram',
      'Krishna': 'Shri Krishna',
      'Shiva': 'Lord Shiva',
      'Hanuman': 'Shri Hanuman',
      'Vishnu': 'Lord Vishnu',
      'Ganesh': 'Shri Ganesh',
      'Durga': 'Maa Durga',

      // Audio Titles & Mantras
      'Hanuman Chalisa': 'Hanuman Chalisa',
      'Vishnu Sahasranama': 'Vishnu Sahasranama',
      'Shiva Tandava Stotram': 'Shiva Tandava Stotram',
      'Gayatri Mantra': 'Gayatri Mantra',
      'Shri Ram Stuti': 'Shri Ram Stuti',
      'Ravana': 'Ravana',
      'Rigveda Samhita': 'Rigveda Samhita',
      'Goswami Tulsidas': 'Goswami Tulsidas',

      // Units & Labels
      'mins': 'mins',
      'min': 'min',
      'Members': 'Members',
      'Children': 'Children',
      'Relations': 'Relations',
      'jaap': 'jaap',
      'japs': 'jaap',
      'malas': 'malas',
      'mala': 'mala',
      'days': 'days',
      'day': 'day',
    },
  };

  /// Translate a database text dynamically according to the active language
  static String translate(BuildContext context, String? text) {
    if (text == null || text.isEmpty) return '';
    final lang = context.currentLang;
    final dict = _dataDictionaries[lang] ?? _dataDictionaries['hi']!;

    // Direct exact match
    if (dict.containsKey(text)) {
      return dict[text]!;
    }

    // Replace partial matches like "10 mins" -> "10 <mins in lang>", "1214 jaap" -> "1214 <jaap in lang>"
    String result = text;
    dict.forEach((enKey, localizedVal) {
      if (result.contains(enKey)) {
        result = result.replaceAll(enKey, localizedVal);
      }
    });

    return result;
  }
}

extension DataLocalizationExtension on BuildContext {
  String trData(String? text) => DataLocalizationHelper.translate(this, text);
}
