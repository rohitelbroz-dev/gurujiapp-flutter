import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guruji/features/language/bloc/language_bloc.dart';

class AppStrings {
  static const Map<String, Map<String, String>> _localizedValues = {
    'hi': {
      // General & Common
      'hariPath': 'हरि पाठ',
      'getStarted': 'शुरू करें',
      'next': 'आगे बढ़ें',
      'skip': 'छोड़ें',
      'edit': 'संपादित करें',
      'cancel': 'रद्द करें',
      'saveChanges': 'बदलाव सहेजें',
      'tryAgain': 'पुनः प्रयास करें',
      'viewAll': 'सभी देखें',
      'refresh': 'रिफ्रेश करें',
      'loading': 'लोड हो रहा है...',
      'save': 'सहेजें',
      'share': 'शेयर करें',
      'download': 'डाउनलोड',
      'whatsApp': 'व्हाट्सएप',

      // Navigation
      'navPanchang': 'पंचांग',
      'navJaap': 'नाम जप',
      'navLibrary': 'लाइब्रेरी',
      'navProfile': 'प्रोफ़ाइल',

      // Language & Welcome
      'chooseLanguageTitle': 'अपनी भाषा\nचुनें',
      'chooseLanguageSubtitle': 'अपनी आध्यात्मिक यात्रा के लिए पसंदीदा भाषा चुनें।',
      'welcomeToHariPath': 'हरि पाठ में आपका स्वागत है',
      'welcomeDesc1': 'अपनी आध्यात्मिक यात्रा शुरू करें। भक्ति, ध्यान और आंतरिक शांति के मार्ग पर अग्रसर हों।',
      'naamJaapTitle': 'दैनिक नाम जप',
      'naamJaapDesc': 'डिजिटल जप माला और काउंटर के साथ नाम जप करें और अपनी प्रगति ट्रैक करें।',
      'amritVachanTitle': 'अमृत वचन व सत्संग',
      'amritVachanDesc': 'प्रतिदिन दिव्य उपदेश, आध्यात्मिक विचार और संतों के पावन वचनों का लाभ उठाएं।',

      // Home / Panchang
      'vedicPanchang': 'वैदिक पंचांग',
      'todayAuspicious': 'आज का शुभ समय व पंचांग',
      'celestialTimings': 'खगोलीय समय',
      'sunrise': 'सूर्योदय',
      'sunset': 'सूर्यास्त',
      'moonrise': 'चन्द्रोदय',
      'moonset': 'चन्द्रास्त',
      'inauspiciousPeriod': 'अशुभ काल',
      'rahuKaal': 'राहु काल',
      'rahuKaalCaution': 'महत्वपूर्ण कार्य प्रारंभ करने से बचें',
      'upcomingFestivals': 'आगामी व्रत एवं त्यौहार',
      'sacredSeva': 'पवित्र सेवा एवं दान',
      'supportOurCows': 'गौ माता की सेवा करें',
      'donateDesc': 'गौमाता के दैनिक पोषण, उपचार और आश्रय में सहयोग दें',
      'donateBtn': 'दान करें',
      'exploreSacred': 'दिव्य आध्यात्मिक सेवाएं',
      'videosAndSatsang': 'सत्संग एवं वीडियो',
      'videosDesc': 'भजन, कीर्तन, कथा और दिव्य सत्संग देखें',
      'amritVachanDescShort': 'दैनिक आध्यात्मिक सुविचार एवं संतों की वाणी',
      'spiritualEvents': 'आध्यात्मिक उत्सव एवं कार्यक्रम',
      'eventsDesc': 'धार्मिक अनुष्ठान, कथा व महाकुंभ उत्सव',
      'familyTree': 'पारिवारिक साधना मंडल',
      'familyDesc': 'अपने पूरे परिवार को भक्ति साधना से जोड़ें',
      'sadhakLeaderboard': 'साधक लीडरबोर्ड',
      'leaderboardDesc': 'वैश्विक साधकों की साधना स्थिति व प्रेरणा',

      // Naam Jaap
      'dailyNaamJaap': 'दैनिक नाम जप',
      'tapToCount': 'गिनती के लिए टैप करें',
      'completedMalas': 'पूर्ण मालाएं',
      'today': 'आज',
      'streak': 'लगातार',
      'days': 'दिन',
      'history': 'इतिहास',
      'malaCompletedToast': '🌸 1 माला (108 जप) पूर्ण हुई! हरिबोल!',
      'ramNaam': 'राम नाम',
      'krishnaNaam': 'कृष्ण नाम',
      'radhaNaam': 'राधा नाम',
      'omNamahShivaya': 'ॐ नमः शिवाय',

      // Jaap History
      'jaapHistoryTitle': 'नाम जप इतिहास',
      'jaapHistorySubtitle': 'समय के साथ आपकी भक्ति यात्रा का विवरण',
      'activityHeatmap': 'साधना गतिविधि',
      'totalCount': 'कुल जप संख्या',
      'longestStreak': 'सबसे लंबा सिलसिला',
      'dailyAverage': 'दैनिक औसत',
      'recentSessions': 'हाल के सत्र',
      'morningMeditation': 'प्रातः कालीन साधना',
      'eveningReflection': 'संध्या कालीन ध्यान',
      'week': 'सप्ताह',
      'month': 'माह',
      'year': 'वर्ष',

      // Audio Library & Player
      'audioLibraryTitle': 'दिव्य ऑडियो लाइब्रेरी',
      'audioSearchHint': 'प्रार्थना, आरती, मंत्र खोजें...',
      'allDeities': 'सभी देवता',
      'nowPlaying': 'अब बज रहा है',
      'playlist': 'प्लेलिस्ट',
      'addedToFavorites': 'पसंदीदा में जोड़ा गया',
      'removedFromFavorites': 'पसंदीदा से हटाया गया',

      // Profile
      'profileTitle': 'साधक प्रोफ़ाइल',
      'devotee': 'भक्त साधक',
      'personalInfo': 'व्यक्तिगत जानकारी',
      'fullName': 'पूरा नाम',
      'phone': 'मोबाइल नंबर',
      'email': 'ईमेल पता',
      'cityState': 'शहर एवं राज्य',
      'gotra': 'गोत्र',
      'dob': 'जन्म तिथि',
      'spiritualPreferences': 'आध्यात्मिक प्राथमिकताएं',
      'dailyMalaGoal': 'दैनिक माला लक्ष्य',
      'languageSetting': 'ऐप की भाषा',
      'notifications': 'साधना स्मरण एवं सूचनाएं',
      'jaapStreak': 'जप सिलसिला',
      'totalGauseva': 'कुल गौसेवा',
      'logout': 'लॉग आउट',
      'logoutConfirm': 'क्या आप वाकई लॉग आउट करना चाहते हैं?',

      // Videos
      'videosTitle': 'दिव्य सत्संग एवं कथा',
      'shortsTab': 'शॉर्ट्स',
      'videosTab': 'वीडियो',
      'liveTab': 'लाइव',
      'noVideosFound': 'कोई वीडियो उपलब्ध नहीं है',

      // Amrit Vachan
      'amritVachanHeader': 'दैनिक अमृत वचन',
      'totalAmritVachan': 'कुल अमृत वचन',
      'allAmritVachan': 'सभी अमृत वचन',

      // Events
      'eventsHeader': 'आध्यात्मिक उत्सव एवं कार्यक्रम',
      'noEventsFound': 'कोई आगामी कार्यक्रम नहीं मिला',

      // Family
      'familyHeader': 'पारिवारिक साधना मंडल',
      'headOfFamily': 'मुखिया (कर्ता)',
      'members': 'सदस्य',
      'addFamilyMember': 'परिवार का सदस्य जोड़ें',

      // Leaderboard
      'leaderboardHeader': 'वैश्विक साधक लीडरबोर्ड',
      'topSadhak': 'सर्वोच्च साधक',
      'chants': 'जप',

      // Donate
      'donateHeader': 'पवित्र गौ सेवा सहयोग',
      'monthlyPlan': 'मासिक सहयोग',
      'yearlyPlan': 'वार्षिक सहयोग',
      'oneTimePlan': 'एक बार दान',
      'continueToPayment': 'भुगतान के लिए आगे बढ़ें',
    },

    'en': {
      // General & Common
      'hariPath': 'Hari Path',
      'getStarted': 'Get Started',
      'next': 'Next',
      'skip': 'Skip',
      'edit': 'Edit',
      'cancel': 'Cancel',
      'saveChanges': 'Save Changes',
      'tryAgain': 'Try Again',
      'viewAll': 'View All',
      'refresh': 'Refresh',
      'loading': 'Loading...',
      'save': 'Save',
      'share': 'Share',
      'download': 'Download',
      'whatsApp': 'WhatsApp',

      // Navigation
      'navPanchang': 'Panchang',
      'navJaap': 'Naam Jaap',
      'navLibrary': 'Library',
      'navProfile': 'Profile',

      // Language & Welcome
      'chooseLanguageTitle': 'Choose Your\nLanguage',
      'chooseLanguageSubtitle': 'Select the language you prefer for your spiritual journey.',
      'welcomeToHariPath': 'Welcome to Hari Path',
      'welcomeDesc1': 'Begin Your Spiritual Journey. Immerse yourself in a guided path of devotion, mindfulness, and inner peace.',
      'naamJaapTitle': 'Daily Naam Jaap',
      'naamJaapDesc': 'Chant holy names daily with digital jaap counter, track streaks, and elevate your spiritual energy.',
      'amritVachanTitle': 'Amrit Vachan & Satsang',
      'amritVachanDesc': 'Discover sacred quotes, daily wisdom, uplifting discourses, and holy teachings.',

      // Home / Panchang
      'vedicPanchang': 'Vedic Panchang',
      'todayAuspicious': 'Today\'s Auspicious Timings',
      'celestialTimings': 'Celestial Timings',
      'sunrise': 'Sunrise',
      'sunset': 'Sunset',
      'moonrise': 'Moonrise',
      'moonset': 'Moonset',
      'inauspiciousPeriod': 'Inauspicious Period',
      'rahuKaal': 'Rahu Kaal',
      'rahuKaalCaution': 'Avoid starting important tasks',
      'upcomingFestivals': 'Upcoming Festivals',
      'sacredSeva': 'Sacred Seva & Contributions',
      'supportOurCows': 'Support Our Cows',
      'donateDesc': 'Ensure daily nourishment, medical care & shelter for Gaumata',
      'donateBtn': 'Donate',
      'exploreSacred': 'Sacred Spiritual Features',
      'videosAndSatsang': 'Satsang & Videos',
      'videosDesc': 'Watch divine kathas, bhajans and live broadcasts',
      'amritVachanDescShort': 'Daily spiritual quotes and saint discourses',
      'spiritualEvents': 'Spiritual Events & Utsav',
      'eventsDesc': 'Utsav celebrations, yagnas and sacred gatherings',
      'familyTree': 'Family Sadhana Circle',
      'familyDesc': 'Connect your entire family in holy chanting',
      'sadhakLeaderboard': 'Sadhak Leaderboard',
      'leaderboardDesc': 'Global community devotion rankings & inspiration',

      // Naam Jaap
      'dailyNaamJaap': 'Daily Naam Jaap',
      'tapToCount': 'TAP TO COUNT',
      'completedMalas': 'Completed Malas',
      'today': 'TODAY',
      'streak': 'STREAK',
      'days': 'Days',
      'history': 'HISTORY',
      'malaCompletedToast': '🌸 1 Mala (108 Chants) Completed! Haribol!',
      'ramNaam': 'Ram Naam',
      'krishnaNaam': 'Krishna Naam',
      'radhaNaam': 'Radha Naam',
      'omNamahShivaya': 'Om Namah Shivaya',

      // Jaap History
      'jaapHistoryTitle': 'Naam Jaap History',
      'jaapHistorySubtitle': 'Your devotional journey over time.',
      'activityHeatmap': 'Activity Heatmap',
      'totalCount': 'TOTAL COUNT',
      'longestStreak': 'LONGEST STREAK',
      'dailyAverage': 'DAILY AVERAGE',
      'recentSessions': 'Recent Sessions',
      'morningMeditation': 'Morning Meditation',
      'eveningReflection': 'Evening Reflection',
      'week': 'Week',
      'month': 'Month',
      'year': 'Year',

      // Audio Library & Player
      'audioLibraryTitle': 'Sacred Audio Library',
      'audioSearchHint': 'Search prayers, aartis, mantras...',
      'allDeities': 'All Deities',
      'nowPlaying': 'NOW PLAYING',
      'playlist': 'Playlist',
      'addedToFavorites': 'Added to Sacred Favorites',
      'removedFromFavorites': 'Removed from Favorites',

      // Profile
      'profileTitle': 'Devotee Profile',
      'devotee': 'Devotee Sadhak',
      'personalInfo': 'Personal Information',
      'fullName': 'Full Name',
      'phone': 'Mobile Number',
      'email': 'Email Address',
      'cityState': 'City & State',
      'gotra': 'Gotra',
      'dob': 'Date of Birth',
      'spiritualPreferences': 'Spiritual Preferences',
      'dailyMalaGoal': 'Daily Mala Goal',
      'languageSetting': 'App Language',
      'notifications': 'Sadhana Reminders & Notifications',
      'jaapStreak': 'Jaap Streak',
      'totalGauseva': 'Total Gau Seva',
      'logout': 'Log Out',
      'logoutConfirm': 'Are you sure you want to log out?',

      // Videos
      'videosTitle': 'Divine Satsang & Videos',
      'shortsTab': 'Shorts',
      'videosTab': 'Videos',
      'liveTab': 'Live',
      'noVideosFound': 'No videos found',

      // Amrit Vachan
      'amritVachanHeader': 'Daily Amrit Vachan',
      'totalAmritVachan': 'Total Amrit Vachan',
      'allAmritVachan': 'All Amrit Vachan',

      // Events
      'eventsHeader': 'Spiritual Events & Utsav',
      'noEventsFound': 'No upcoming events found',

      // Family
      'familyHeader': 'Family Sadhana Circle',
      'headOfFamily': 'Karta (Head of Family)',
      'members': 'Members',
      'addFamilyMember': 'Add Family Member',

      // Leaderboard
      'leaderboardHeader': 'Global Sadhak Leaderboard',
      'topSadhak': 'Top Sadhak',
      'chants': 'Chants',

      // Donate
      'donateHeader': 'Sacred Gau Seva Support',
      'monthlyPlan': 'Monthly Contribution',
      'yearlyPlan': 'Yearly Contribution',
      'oneTimePlan': 'One-Time Donation',
      'continueToPayment': 'Continue to Payment',
    },

    'mr': {
      // General & Common
      'hariPath': 'हरि पाठ',
      'getStarted': 'सुरू करा',
      'next': 'पुढे जा',
      'skip': 'वगळा',
      'edit': 'संपादित करा',
      'cancel': 'रद्द करा',
      'saveChanges': 'बदल जतन करा',
      'tryAgain': 'पुन्हा प्रयत्न करा',
      'viewAll': 'सर्व पहा',
      'refresh': 'रिफ्रेश करा',
      'loading': 'लोड होत आहे...',
      'save': 'जतन करा',
      'share': 'शेअर करा',
      'download': 'डाउनलोड',
      'whatsApp': 'व्हॉट्सअॅप',

      // Navigation
      'navPanchang': 'पंचांग',
      'navJaap': 'नामजप',
      'navLibrary': 'लायब्ररी',
      'navProfile': 'प्रोफाइल',

      // Language & Welcome
      'chooseLanguageTitle': 'आपली भाषा\nनिवडा',
      'chooseLanguageSubtitle': 'आपल्या आध्यात्मिक प्रवासासाठी पसंतीची भाषा निवडा.',
      'welcomeToHariPath': 'हरि पाठ मध्ये आपले स्वागत आहे',
      'welcomeDesc1': 'आपला आध्यात्मिक प्रवास सुरू करा. भक्ती, ध्यान आणि आत्मशांतीच्या मार्गावर चाला.',
      'naamJaapTitle': 'दैनिक नामजप',
      'naamJaapDesc': 'डिजिटल जपमाळेसह दररोज नामजप करा आणि आपली प्रगती ट्रॅक करा.',
      'amritVachanTitle': 'अमृत वचन व सत्संग',
      'amritVachanDesc': 'दररोज अमृत वचन, प्रवचने आणि आध्यात्मिक विचारांचा लाभ घ्या.',

      // Home / Panchang
      'vedicPanchang': 'वैदिक पंचांग',
      'todayAuspicious': 'आजचा शुभ मुहूर्त व पंचांग',
      'celestialTimings': 'खगोलीय वेळा',
      'sunrise': 'सूर्योदय',
      'sunset': 'सूर्यास्त',
      'moonrise': 'चंद्रोदय',
      'moonset': 'चंद्रास्त',
      'inauspiciousPeriod': 'अशुभ काळ',
      'rahuKaal': 'राहु काळ',
      'rahuKaalCaution': 'महत्त्वाची कामे सुरू करणे टाळा',
      'upcomingFestivals': 'आगामी सण व उत्सव',
      'sacredSeva': 'पवित्र सेवा आणि दान',
      'supportOurCows': 'गौमातेची सेवा करा',
      'donateDesc': 'गौमातेच्या दैनंदिन पोषण, औषधोपचार आणि निवाऱ्यात हातभार लावा',
      'donateBtn': 'दान करा',
      'exploreSacred': 'आध्यात्मिक वैशिष्ट्ये',
      'videosAndSatsang': 'सत्संग व व्हिडिओ',
      'videosDesc': 'भजन, कीर्तन, कथा आणि थेट सत्संग पहा',
      'amritVachanDescShort': 'दैनिक आध्यात्मिक सुविचार आणि संतांचे वचन',
      'spiritualEvents': 'धार्मिक उत्सव व कार्यक्रम',
      'eventsDesc': 'पूजा, अनुष्ठान आणि धार्मिक मेळावे',
      'familyTree': 'कौटुंबिक साधना मंडळ',
      'familyDesc': 'आपल्या संपूर्ण कुटुंबाला भक्ती साधनेशी जोडा',
      'sadhakLeaderboard': 'साधक लीडरबोर्ड',
      'leaderboardDesc': 'जागतिक साधकांची भक्ती स्थिती व प्रेरणा',

      // Naam Jaap
      'dailyNaamJaap': 'दैनिक नामजप',
      'tapToCount': 'मोजण्यासाठी टॅप करा',
      'completedMalas': 'पूर्ण माळा',
      'today': 'आज',
      'streak': 'सातत्य',
      'days': 'दिवस',
      'history': 'इतिहास',
      'malaCompletedToast': '🌸 १ माळ (१०८ जप) पूर्ण झाली! हरिबोल!',
      'ramNaam': 'राम नाम',
      'krishnaNaam': 'कृष्ण नाम',
      'radhaNaam': 'राधा नाम',
      'omNamahShivaya': 'ॐ नमः शिवाय',

      // Jaap History
      'jaapHistoryTitle': 'नामजप इतिहास',
      'jaapHistorySubtitle': 'आपल्या भक्ती प्रवासाचा आलेख',
      'activityHeatmap': 'साधना आलेख',
      'totalCount': 'एकूण जप संख्या',
      'longestStreak': 'दीर्घकालीन सातत्य',
      'dailyAverage': 'दैनिक सरासरी',
      'recentSessions': 'अलीकडील सत्रे',
      'morningMeditation': 'सकाळची साधना',
      'eveningReflection': 'संध्याकाळचे ध्यान',
      'week': 'आठवडा',
      'month': 'महिना',
      'year': 'वर्ष',

      // Audio Library & Player
      'audioLibraryTitle': 'पवित्र ऑडिओ लायब्ररी',
      'audioSearchHint': 'प्रार्थना, आरत्या, मंत्र शोधा...',
      'allDeities': 'सर्व देवता',
      'nowPlaying': 'आता वाजत आहे',
      'playlist': 'प्लेलिस्ट',
      'addedToFavorites': 'आवडीच्या यादीत जोडले',
      'removedFromFavorites': 'आवडीच्या यादीतून काढले',

      // Profile
      'profileTitle': 'साधक प्रोफाइल',
      'devotee': 'भक्त साधक',
      'personalInfo': 'वैयक्तिक माहिती',
      'fullName': 'पूर्ण नाव',
      'phone': 'मोबाईल नंबर',
      'email': 'ईमेल पत्ता',
      'cityState': 'शहर आणि राज्य',
      'gotra': 'गोत्र',
      'dob': 'जन्मतारीख',
      'spiritualPreferences': 'आध्यात्मिक प्राधान्ये',
      'dailyMalaGoal': 'दैनिक माळ ध्येय',
      'languageSetting': 'अ‍ॅपची भाषा',
      'notifications': 'साधना स्मरणपत्रे व सूचना',
      'jaapStreak': 'जप सातत्य',
      'totalGauseva': 'एकूण गौसेवा',
      'logout': 'लॉग आउट',
      'logoutConfirm': 'तुम्हाला खात्रीने लॉग आउट करायचे आहे का?',

      // Videos
      'videosTitle': 'दिव्य सत्संग आणि व्हिडिओ',
      'shortsTab': 'शॉर्ट्स',
      'videosTab': 'व्हिडिओ',
      'liveTab': 'लाइव्ह',
      'noVideosFound': 'कोणतेही व्हिडिओ उपलब्ध नाहीत',

      // Amrit Vachan
      'amritVachanHeader': 'दैनिक अमृत वचन',
      'totalAmritVachan': 'एकूण अमृत वचन',
      'allAmritVachan': 'सर्व अमृत वचन',

      // Events
      'eventsHeader': 'आध्यात्मिक उत्सव आणि कार्यक्रम',
      'noEventsFound': 'कोणतेही आगामी कार्यक्रम नाहीत',

      // Family
      'familyHeader': 'कौटुंबिक साधना मंडळ',
      'headOfFamily': 'कुटुंबप्रमुख (कर्ता)',
      'members': 'सदस्य',
      'addFamilyMember': 'कुटुंब सदस्य जोडा',

      // Leaderboard
      'leaderboardHeader': 'जागतिक साधक लीडरबोर्ड',
      'topSadhak': 'सर्वोच्च साधक',
      'chants': 'जप',

      // Donate
      'donateHeader': 'पवित्र गौ सेवा सहयोग',
      'monthlyPlan': 'मासिक सहयोग',
      'yearlyPlan': 'वार्षिक सहयोग',
      'oneTimePlan': 'एकदाच दान',
      'continueToPayment': 'पेमेंटसाठी पुढे जा',
    },

    'gu': {
      // General & Common
      'hariPath': 'હરિ પાઠ',
      'getStarted': 'શરૂ કરો',
      'next': 'આગળ વધો',
      'skip': 'છોડો',
      'edit': 'સંપાદિત કરો',
      'cancel': 'રદ કરો',
      'saveChanges': 'ફેરફારો સાચવો',
      'tryAgain': 'ફરી પ્રયાસ કરો',
      'viewAll': 'બધા જુઓ',
      'refresh': 'રીફ્રેશ કરો',
      'loading': 'લોડ થઈ રહ્યું છે...',
      'save': 'સાચવો',
      'share': 'શેર કરો',
      'download': 'ડાઉનલોડ',
      'whatsApp': 'વોટ્સએપ',

      // Navigation
      'navPanchang': 'પંચાંગ',
      'navJaap': 'નામ જાપ',
      'navLibrary': 'લાઇબ્રેરી',
      'navProfile': 'પ્રોફાઇલ',

      // Language & Welcome
      'chooseLanguageTitle': 'તમારી ભાષા\nપસંદ કરો',
      'chooseLanguageSubtitle': 'તમારી આધ્યાત્મિક યાત્રા માટે પસંદગીની ભાષા પસંદ કરો.',
      'welcomeToHariPath': 'હરિ પાઠમાં આપનું સ્વાગત છે',
      'welcomeDesc1': 'તમારી આધ્યાત્મિક યાત્રા શરૂ કરો. ભક્તિ, ધ્યાન અને આંતરિક શાંતિનો માર્ગ અપનાવો.',
      'naamJaapTitle': 'દૈનિક નામ જાપ',
      'naamJaapDesc': 'ડિજિટલ માળા સાથે દરરોજ નામ જાપ કરો અને તમારી પ્રગતિ જુઓ.',
      'amritVachanTitle': 'અમૃત વચન અને સત્સંગ',
      'amritVachanDesc': 'રોજિંદા અમૃત વચન, સત્સંગ અને પવિત્ર જ્ઞાન મેળવો.',

      // Home / Panchang
      'vedicPanchang': 'વૈદિક પંચાંગ',
      'todayAuspicious': 'આજનો શુભ સમય અને પંચાંગ',
      'celestialTimings': 'ખગોળીય સમય',
      'sunrise': 'સૂર્યોદય',
      'sunset': 'સૂર્યાસ્ત',
      'moonrise': 'ચંદ્રોદય',
      'moonset': 'ચંદ્રાસ્ત',
      'inauspiciousPeriod': 'અશુભ સમય',
      'rahuKaal': 'રાહુ કાળ',
      'rahuKaalCaution': 'મહત્વપૂર્ણ કાર્યો શરૂ કરવાનું ટાળો',
      'upcomingFestivals': 'આગામી તહેવારો',
      'sacredSeva': 'પવિત્ર સેવા અને દાન',
      'supportOurCows': 'ગૌમાતાની સેવા કરો',
      'donateDesc': 'ગૌમાતાના દૈનિક આહાર, સારવાર અને આશ્રયમાં સહયોગ આપો',
      'donateBtn': 'દાન કરો',
      'exploreSacred': 'આધ્યાત્મિક સેવાઓ',
      'videosAndSatsang': 'સત્સંગ અને વીડિયો',
      'videosDesc': 'ભજન, કીર્તન, કથા અને લાઈવ સત્સંગ જુઓ',
      'amritVachanDescShort': 'દૈનિક આધ્યાત્મિક સુવિચાર અને સંતોના વચન',
      'spiritualEvents': 'ધાર્મિક ઉત્સવ અને કાર્યક્રમો',
      'eventsDesc': 'પૂજા, અનુષ્ઠાન અને પવિત્ર સભાઓ',
      'familyTree': 'પારિવારિક સાધના મંડળ',
      'familyDesc': 'તમારા આખા પરિવારને ભક્તિ સાધના સાથે જોડો',
      'sadhakLeaderboard': 'સાધક લીડરબોર્ડ',
      'leaderboardDesc': 'વૈશ્વિક સાધકોની ભક્તિ સ્થિતિ અને પ્રેરણા',

      // Naam Jaap
      'dailyNaamJaap': 'દૈનિક નામ જાપ',
      'tapToCount': 'ગણવા માટે ટેપ કરો',
      'completedMalas': 'પૂર્ણ થયેલી માળા',
      'today': 'આજે',
      'streak': 'સતત',
      'days': 'દિવસ',
      'history': 'ઇતિહાસ',
      'malaCompletedToast': '🌸 ૧ માળા (૧૦૮ જાપ) પૂર્ણ થઈ! હરિબોલ!',
      'ramNaam': 'રામ નામ',
      'krishnaNaam': 'કૃષ્ણ નામ',
      'radhaNaam': 'રાધા નામ',
      'omNamahShivaya': 'ૐ નમઃ શિવાય',

      // Jaap History
      'jaapHistoryTitle': 'નામ જાપ ઇતિહાસ',
      'jaapHistorySubtitle': 'સમય સાથે તમારી ભક્તિ યાત્રા',
      'activityHeatmap': 'સાધના આલેખ',
      'totalCount': 'કુલ જાપ સંખ્યા',
      'longestStreak': 'સૌથી લાંબો સમયગાળો',
      'dailyAverage': 'દૈનિક સરેરાશ',
      'recentSessions': 'તાજેતરના સત્રો',
      'morningMeditation': 'પ્રભાત સાધના',
      'eveningReflection': 'સાંજનું ધ્યાન',
      'week': 'અઠવાડિયું',
      'month': 'મહિનો',
      'year': 'વર્ષ',

      // Audio Library & Player
      'audioLibraryTitle': 'પવિત્ર ઓડિયો લાઇબ્રેરી',
      'audioSearchHint': 'પ્રાર્થના, આરતી, મંત્રો શોધો...',
      'allDeities': 'બધા દેવો',
      'nowPlaying': 'હવે વાગી રહ્યું છે',
      'playlist': 'પ્લેલિસ્ટ',
      'addedToFavorites': 'મનપસંદમાં ઉમેરાયું',
      'removedFromFavorites': 'મનપસંદમાંથી દૂર કર્યું',

      // Profile
      'profileTitle': 'સાધક પ્રોફાઇલ',
      'devotee': 'ભક્ત સાધક',
      'personalInfo': 'વ્યક્તિગત માહિતી',
      'fullName': 'પૂરું નામ',
      'phone': 'મોબાઇલ નંબર',
      'email': 'ઇમેઇલ સરનામું',
      'cityState': 'શહેર અને રાજ્ય',
      'gotra': 'ગોત્ર',
      'dob': 'જન્મ તારીખ',
      'spiritualPreferences': 'આધ્યાત્મિક પસંદગીઓ',
      'dailyMalaGoal': 'દૈનિક માળા લક્ષ્ય',
      'languageSetting': 'એપની ભાષા',
      'notifications': 'સાધના રીમાઇન્ડર્સ અને સૂચનાઓ',
      'jaapStreak': 'જાપ સાતત્ય',
      'totalGauseva': 'કુલ ગૌસેવા',
      'logout': 'લૉગ આઉટ',
      'logoutConfirm': 'શું તમે ખરેખર લૉગ આઉટ કરવા માંગો છો?',

      // Videos
      'videosTitle': 'દિવ્ય સત્સંગ અને વીડિયો',
      'shortsTab': 'શોર્ટ્સ',
      'videosTab': 'વીડિયો',
      'liveTab': 'લાઈવ',
      'noVideosFound': 'કોઈ વીડિયો મળ્યો નથી',

      // Amrit Vachan
      'amritVachanHeader': 'દૈનિક અમૃત વચન',
      'totalAmritVachan': 'કુલ અમૃત વચન',
      'allAmritVachan': 'બધા અમૃત વચન',

      // Events
      'eventsHeader': 'ધાર્મિક ઉત્સવ અને કાર્યક્રમો',
      'noEventsFound': 'કોઈ આગામી કાર્યક્રમો નથી',

      // Family
      'familyHeader': 'પારિવારિક સાધના મંડળ',
      'headOfFamily': 'પરિવારના વડા (કર્તા)',
      'members': 'સભ્યો',
      'addFamilyMember': 'પરિવારના સભ્ય ઉમેરો',

      // Leaderboard
      'leaderboardHeader': 'વૈશ્વિક સાધક લીડરબોર્ડ',
      'topSadhak': 'ટોચના સાધક',
      'chants': 'જાપ',

      // Donate
      'donateHeader': 'પવિત્ર ગૌ સેવા સહયોગ',
      'monthlyPlan': 'માસિક સહયોગ',
      'yearlyPlan': 'વાર્ષિક સહયોગ',
      'oneTimePlan': 'એક વખતનું દાન',
      'continueToPayment': 'ચૂકવણી માટે આગળ વધો',
    },

    'ta': {
      // General & Common
      'hariPath': 'ஹரி பாத்',
      'getStarted': 'தொடங்குங்கள்',
      'next': 'அடுத்து',
      'skip': 'தவிர்',
      'edit': 'திருத்து',
      'cancel': 'ரத்து செய்',
      'saveChanges': 'மாற்றங்களை சேமி',
      'tryAgain': 'மீண்டும் முயற்சிக்கவும்',
      'viewAll': 'அனைத்தையும் காண்க',
      'refresh': 'புதுப்பி',
      'loading': 'ஏற்றுகிறது...',
      'save': 'சேமி',
      'share': 'பகிர்',
      'download': 'பதிவிறக்கு',
      'whatsApp': 'வாட்ஸ்அப்',

      // Navigation
      'navPanchang': 'பஞ்சாங்கம்',
      'navJaap': 'நாம ஜெபம்',
      'navLibrary': 'நூலகம்',
      'navProfile': 'சுயவிவரம்',

      // Language & Welcome
      'chooseLanguageTitle': 'உங்கள் மொழியை\nதேர்ந்தெடுங்கள்',
      'chooseLanguageSubtitle': 'உங்கள் ஆன்மீக பயணத்திற்கு விருப்பமான மொழியைத் தேர்ந்தெடுக்கவும்.',
      'welcomeToHariPath': 'ஹரி பாத்திற்கு நல்வரவு',
      'welcomeDesc1': 'உங்கள் ஆன்மீக பயணத்தைத் தொடங்குங்கள். பக்தி, தியானம் மற்றும் அமைதியின் வழியில் பயணியுங்கள்.',
      'naamJaapTitle': 'தினசரி நாம ஜெபம்',
      'naamJaapDesc': 'டிஜிட்டல் ஜெபமாலையுடன் தினசரி நாம ஜெபம் செய்து ஆன்மீக அமைதி பெறுங்கள்.',
      'amritVachanTitle': 'அமிர்த வசனம் & சத்சங்கம்',
      'amritVachanDesc': 'தினசரி ஆன்மீக சிந்தனைகள் மற்றும் வழிகாட்டுதல்களைப் பெறுங்கள்.',

      // Home / Panchang
      'vedicPanchang': 'வேத பஞ்சாங்கம்',
      'todayAuspicious': 'இன்றைய சுப நேரங்கள்',
      'celestialTimings': 'வானியல் நேரங்கள்',
      'sunrise': 'சூரிய உதயம்',
      'sunset': 'சூரிய அஸ்தமனம்',
      'moonrise': 'சந்திர உதயம்',
      'moonset': 'சந்திர அஸ்தமனம்',
      'inauspiciousPeriod': 'அசுப காலம்',
      'rahuKaal': 'ராகு காலம்',
      'rahuKaalCaution': 'முக்கிய பணிகளைத் தொடங்குவதைத் தவிர்க்கவும்',
      'upcomingFestivals': 'வரவிருக்கும் பண்டிகைகள்',
      'sacredSeva': 'புனித சேவை மற்றும் நன்கொடை',
      'supportOurCows': 'பசு சேவை செய்யுங்கள்',
      'donateDesc': 'கோமாதாவின் உணவு, மருத்துவம் மற்றும் பராமரிப்பில் உதவுங்கள்',
      'donateBtn': 'நன்கொடை',
      'exploreSacred': 'ஆன்மீக சேவைகள்',
      'videosAndSatsang': 'சத்சங்கம் & வீடியோக்கள்',
      'videosDesc': 'பக்தி பாடல்கள், உபன்யாசங்கள் மற்றும் நேரலை சத்சங்கம்',
      'amritVachanDescShort': 'தினசரி ஆன்மீக சிந்தனைகள் மற்றும் பொன்மொழிகள்',
      'spiritualEvents': 'ஆன்மீக விழாக்கள் & நிகழ்வுகள்',
      'eventsDesc': 'பூஜைகள், யாகங்கள் மற்றும் ஆன்மீக கூட்டங்கள்',
      'familyTree': 'குடும்ப சாதனா வட்டம்',
      'familyDesc': 'உங்கள் முழு குடும்பத்தையும் பக்தி சாதனையில் இணையுங்கள்',
      'sadhakLeaderboard': 'சாதகர் தரவரிசை',
      'leaderboardDesc': 'உலகளாவிய பக்தர்களின் பக்தி நிலை மற்றும் ஊக்கம்',

      // Naam Jaap
      'dailyNaamJaap': 'தினசரி நாம ஜெபம்',
      'tapToCount': 'எண்ண தட்டவும்',
      'completedMalas': 'முடிந்த மாலைகள்',
      'today': 'இன்று',
      'streak': 'தொடர்ச்சி',
      'days': 'நாட்கள்',
      'history': 'வரலாறு',
      'malaCompletedToast': '🌸 1 மாலை (108 ஜெபம்) முடிந்தது! ஹரிபோல்!',
      'ramNaam': 'ராம நாமம்',
      'krishnaNaam': 'கிருஷ்ண நாமம்',
      'radhaNaam': 'ராதா நாமம்',
      'omNamahShivaya': 'ஓம் நம சிவாய',

      // Jaap History
      'jaapHistoryTitle': 'நாம ஜெப வரலாறு',
      'jaapHistorySubtitle': 'காலப்போக்கில் உங்கள் பக்தி பயணம்',
      'activityHeatmap': 'சாதனை வரைபடம்',
      'totalCount': 'மொத்த ஜெபங்கள்',
      'longestStreak': 'நீண்ட தொடர்ச்சி',
      'dailyAverage': 'தினசரி சராசரி',
      'recentSessions': 'சமீபத்திய அமர்வுகள்',
      'morningMeditation': 'காலை தியானம்',
      'eveningReflection': 'மாலை தியானம்',
      'week': 'வாரம்',
      'month': 'மாதம்',
      'year': 'ஆண்டு',

      // Audio Library & Player
      'audioLibraryTitle': 'புனித ஆடியோ நூலகம்',
      'audioSearchHint': 'பிரார்த்தனைகள், ஆரத்திகள், மந்திரங்களைத் தேடுங்கள்...',
      'allDeities': 'அனைத்து தெய்வங்கள்',
      'nowPlaying': 'இப்போது ஒலிக்கிறது',
      'playlist': 'பிளேலிஸ்ட்',
      'addedToFavorites': 'விருப்பமானவற்றில் சேர்க்கப்பட்டது',
      'removedFromFavorites': 'விருப்பமானவற்றிலிருந்து நீக்கப்பட்டது',

      // Profile
      'profileTitle': 'சாதகர் சுயவிவரம்',
      'devotee': 'பக்த சாதகர்',
      'personalInfo': 'தனிப்பட்ட தகவல்',
      'fullName': 'முழு பெயர்',
      'phone': 'கைபேசி எண்',
      'email': 'மின்னஞ்சல் முகவரி',
      'cityState': 'நகரம் & மாநிலம்',
      'gotra': 'கோத்திரம்',
      'dob': 'பிறந்த தேதி',
      'spiritualPreferences': 'ஆன்மீக விருப்பங்கள்',
      'dailyMalaGoal': 'தினசரி மாலை இலக்கு',
      'languageSetting': 'செயலி மொழி',
      'notifications': 'சாதனா நினைவூட்டல்கள் & அறிவிப்புகள்',
      'jaapStreak': 'ஜெப தொடர்ச்சி',
      'totalGauseva': 'மொத்த கோ சேவை',
      'logout': 'வெளியேறு',
      'logoutConfirm': 'நீங்கள் நிச்சயமாக வெளியேற விரும்புகிறீர்களா?',

      // Videos
      'videosTitle': 'தெய்வீக சத்சங்கம் & வீடியோக்கள்',
      'shortsTab': 'ஷார்ட்ஸ்',
      'videosTab': 'வீடியோக்கள்',
      'liveTab': 'நேரலை',
      'noVideosFound': 'வீடியோக்கள் எதுவும் கிடைக்கவில்லை',

      // Amrit Vachan
      'amritVachanHeader': 'தினசரி அமிர்த வசனம்',
      'totalAmritVachan': 'மொத்த அமிர்த வசனங்கள்',
      'allAmritVachan': 'அனைத்து அமிர்த வசனங்கள்',

      // Events
      'eventsHeader': 'ஆன்மீக விழாக்கள் & நிகழ்வுகள்',
      'noEventsFound': 'வரவிருக்கும் நிகழ்வுகள் இல்லை',

      // Family
      'familyHeader': 'குடும்ப சாதனா வட்டம்',
      'headOfFamily': 'குடும்பத் தலைவர் (கர்த்தா)',
      'members': 'உறுப்பினர்கள்',
      'addFamilyMember': 'குடும்ப உறுப்பினரைச் சேர்க்கவும்',

      // Leaderboard
      'leaderboardHeader': 'உலகளாவிய சாதகர் தரவரிசை',
      'topSadhak': 'சிறந்த சாதகர்',
      'chants': 'ஜெபங்கள்',

      // Donate
      'donateHeader': 'புனித கோ சேவை உதவி',
      'monthlyPlan': 'மாதாந்திர உதவி',
      'yearlyPlan': 'ஆண்டு உதவி',
      'oneTimePlan': 'ஒருமுறை நன்கொடை',
      'continueToPayment': 'பணம் செலுத்த தொடரவும்',
    },

    'te': {
      // General & Common
      'hariPath': 'హరి పాఠ్',
      'getStarted': 'ప్రారంభించండి',
      'next': 'తరువాత',
      'skip': 'దాటవేయి',
      'edit': 'సవరించు',
      'cancel': 'రద్దు చేయి',
      'saveChanges': 'మార్పులను భద్రపరచు',
      'tryAgain': 'మళ్ళీ ప్రయత్నించండి',
      'viewAll': 'అన్నీ చూడండి',
      'refresh': 'రిఫ్రెష్ చేయండి',
      'loading': 'లోడ్ అవుతోంది...',
      'save': 'భద్రపరచు',
      'share': 'భాగస్వామ్యం చేయండి',
      'download': 'డౌన్‌లోడ్',
      'whatsApp': 'వాట్సాప్',

      // Navigation
      'navPanchang': 'పంచాంగం',
      'navJaap': 'నామ జపం',
      'navLibrary': 'లైబ్రరీ',
      'navProfile': 'ప్రొఫైల్',

      // Language & Welcome
      'chooseLanguageTitle': 'మీ భాషను\nఎంచుకోండి',
      'chooseLanguageSubtitle': 'మీ ఆధ్యాత్మిక ప్రయాణానికి ప్రాధాన్యత గల భాషను ఎంచుకోండి.',
      'welcomeToHariPath': 'హరి పాఠ్‌కు స్వాగతం',
      'welcomeDesc1': 'మీ ఆధ్యాత్మిక ప్రయాణాన్ని ప్రారంభించండి. భక్తి, ధ్యానం మరియు శాంతి మార్గంలో సాగండి.',
      'naamJaapTitle': 'రోజువారీ నామ జపం',
      'naamJaapDesc': 'డిజిటల్ జపమాలతో ప్రతిరోజూ నామ జపం చేయండి మరియు ప్రశాంతతను పొందండి.',
      'amritVachanTitle': 'అమృత వచనం & సత్సంగం',
      'amritVachanDesc': 'ప్రతిరోజూ దివ్య వచనాలు మరియు ఆధ్యాత్మిక ప్రవచనాలను వినండి.',

      // Home / Panchang
      'vedicPanchang': 'వైదిక పంచాంగం',
      'todayAuspicious': 'నేటి శుభ ముహూర్తాలు',
      'celestialTimings': 'ఖగోళ సమయాలు',
      'sunrise': 'సూర్యోదయం',
      'sunset': 'సూర్యాస్తమయం',
      'moonrise': 'చంద్రోదయం',
      'moonset': 'చంద్రాస్తమయం',
      'inauspiciousPeriod': 'అశుభ కాలం',
      'rahuKaal': 'రాహు కాలం',
      'rahuKaalCaution': 'ముఖ్యమైన పనులు ప్రారంభించవద్దు',
      'upcomingFestivals': 'రాబోయే పండుగలు',
      'sacredSeva': 'పవిత్ర సేవ & విరాళాలు',
      'supportOurCows': 'గోమాత సేవ చేయండి',
      'donateDesc': 'గోమాత పోషణ, వైద్యం మరియు ఆశ్రయం కోసం సహాయం చేయండి',
      'donateBtn': 'దానం చేయండి',
      'exploreSacred': 'ఆధ్యాత్మిక విశేషాలు',
      'videosAndSatsang': 'సత్సంగం & వీడియోలు',
      'videosDesc': 'భజనలు, కీర్తనలు, ప్రవచనాలు మరియు ప్రత్యక్ష సత్సంగాలు',
      'amritVachanDescShort': 'రోజువారీ ఆధ్యాత్మిక సూక్తులు & సాధువుల బోధనలు',
      'spiritualEvents': 'ఆధ్యాత్మిక ఉత్సవాలు & కార్యక్రమాలు',
      'eventsDesc': 'పూజలు, యజ్ఞాలు మరియు పవిత్ర సభలు',
      'familyTree': 'కుటుంబ సాధన మండలి',
      'familyDesc': 'మీ పూర్తి కుటుంబాన్ని భక్తి సాధనతో అనుసంధానించండి',
      'sadhakLeaderboard': 'సాధక లీడర్‌బోర్డ్',
      'leaderboardDesc': 'ప్రపంచ సాధకుల భక్తి స్థితి మరియు ప్రేరణ',

      // Naam Jaap
      'dailyNaamJaap': 'రోజువారీ నామ జపం',
      'tapToCount': 'లెక్కించడానికి నొక్కండి',
      'completedMalas': 'పూర్తయిన మాలలు',
      'today': 'నేడు',
      'streak': 'నిరంతరత',
      'days': 'రోజులు',
      'history': 'చరిత్ర',
      'malaCompletedToast': '🌸 1 మాల (108 జపాలు) పూర్తయింది! హరిబోల్!',
      'ramNaam': 'రామ నామం',
      'krishnaNaam': 'కృష్ణ నామం',
      'radhaNaam': 'రాధా నామం',
      'omNamahShivaya': 'ఓం నమః శివాయ',

      // Jaap History
      'jaapHistoryTitle': 'నామ జప చరిత్ర',
      'jaapHistorySubtitle': 'సమయంతో మీ భక్తి ప్రయాణం',
      'activityHeatmap': 'సాధన గ్రాఫ్',
      'totalCount': 'మొత్తం జపాలు',
      'longestStreak': 'దీర్ఘకాలిక రికార్డు',
      'dailyAverage': 'రోజువారీ సగటు',
      'recentSessions': 'ఇటీవలి సెషన్లు',
      'morningMeditation': 'ఉదయపు ధ్యానం',
      'eveningReflection': 'సాయంత్రపు ధ్యానం',
      'week': 'వారం',
      'month': 'నెల',
      'year': 'సంవత్సరం',

      // Audio Library & Player
      'audioLibraryTitle': 'పవిత్ర ఆడియో లైబ్రరీ',
      'audioSearchHint': 'ప్రార్థనలు, ఆరతులు, మంత్రాలను శోధించండి...',
      'allDeities': 'అన్ని దేవతలు',
      'nowPlaying': 'ఇప్పుడు ప్లే అవుతోంది',
      'playlist': 'ప్లేలిస్ట్',
      'addedToFavorites': 'ఇష్టమైన వాటిలో చేర్చబడింది',
      'removedFromFavorites': 'ఇష్టమైన వాటి నుండి తొలగించబడింది',

      // Profile
      'profileTitle': 'సాధక ప్రొఫైల్',
      'devotee': 'భక్త సాధకుడు',
      'personalInfo': 'వ్యక్తిగత సమాచారం',
      'fullName': 'పూర్తి పేరు',
      'phone': 'మొబైల్ సంఖ్య',
      'email': 'ఈమెయిల్ చిరునామా',
      'cityState': 'నగరం & రాష్ట్రం',
      'gotra': 'గోత్రం',
      'dob': 'పుట్టిన తేదీ',
      'spiritualPreferences': 'ఆధ్యాత్మిక ప్రాధాన్యతలు',
      'dailyMalaGoal': 'రోజువారీ మాల లక్ష్యం',
      'languageSetting': 'యాప్ భాష',
      'notifications': 'సాధన రిమైండర్‌లు & నోటిఫికేషన్‌లు',
      'jaapStreak': 'జప నిరంతరత',
      'totalGauseva': 'మొత్తం గోసేవ',
      'logout': 'లాగ్ అవుట్',
      'logoutConfirm': 'మీరు ఖచ్చితంగా లాగ్ అవుట్ చేయాలనుకుంటున్నారా?',

      // Videos
      'videosTitle': 'దివ్య సత్సంగం & వీడియోలు',
      'shortsTab': 'షార్ట్స్',
      'videosTab': 'వీడియోలు',
      'liveTab': 'లైవ్',
      'noVideosFound': 'వీడియోలు ఏవీ కనుగొనబడలేదు',

      // Amrit Vachan
      'amritVachanHeader': 'రోజువారీ అమృత వచనం',
      'totalAmritVachan': 'మొత్తం అమృత వచనాలు',
      'allAmritVachan': 'అన్ని అమృత వచనాలు',

      // Events
      'eventsHeader': 'ఆధ్యాత్మిక ఉత్సవాలు & కార్యక్రమాలు',
      'noEventsFound': 'రాబోయే కార్యక్రమాలు ఏవీ లేవు',

      // Family
      'familyHeader': 'కుటుంబ సాధన మండలి',
      'headOfFamily': 'కుటుంబ పెద్ద (కర్త)',
      'members': 'సభ్యులు',
      'addFamilyMember': 'కుటుంబ సభ్యుడిని జోడించండి',

      // Leaderboard
      'leaderboardHeader': 'ప్రపంచ సాధక లీడర్‌బోర్డ్',
      'topSadhak': 'అగ్ర సాధకుడు',
      'chants': 'జపాలు',

      // Donate
      'donateHeader': 'పవిత్ర గోసేవ సహాయం',
      'monthlyPlan': 'నెలవారీ సహాయం',
      'yearlyPlan': 'వార్షిక సహాయం',
      'oneTimePlan': 'ఒకేసారి విరాళం',
      'continueToPayment': 'చెల్లింపుకు ముందుకు సాగండి',
    },
  };

  static String get(String key, {String lang = 'hi'}) {
    return _localizedValues[lang]?[key] ??
        _localizedValues['hi']?[key] ??
        _localizedValues['en']?[key] ??
        key;
  }
}

extension LocalizationExtension on BuildContext {
  String tr(String key) {
    try {
      final lang = watch<LanguageBloc>().state.languageCode;
      return AppStrings.get(key, lang: lang);
    } catch (_) {
      return AppStrings.get(key, lang: 'hi');
    }
  }

  String get currentLang {
    try {
      return watch<LanguageBloc>().state.languageCode;
    } catch (_) {
      return 'hi';
    }
  }
}

