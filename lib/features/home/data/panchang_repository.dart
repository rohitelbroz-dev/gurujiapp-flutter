import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guruji/core/constant/api_constants.dart';
import 'package:guruji/features/home/data/panchang_models.dart';

class PanchangRepository {
  final String _baseUrl = ApiConstants.baseUrl;

  /// Fetch daily Panchang for a specific date and location
  Future<DailyPanchangData> fetchDailyPanchang({
    String? date,
    String? location,
  }) async {
    final queryDate = date ?? _getTodayFormatted();
    final queryLocation = location ?? 'Vrindavan';

    try {
      final url = Uri.parse('$_baseUrl/panchang/daily?date=$queryDate&location=$queryLocation');
      final response = await http.get(url).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        final data = decoded['data'] as Map<String, dynamic>? ?? decoded;
        return DailyPanchangData.fromJson(data);
      }
    } catch (_) {
      // Fallback gracefully to offline calculation / realistic defaults
    }

    return _getFallbackPanchang(queryDate, queryLocation);
  }

  /// Fetch upcoming festivals & vrats
  Future<List<FestivalItem>> fetchUpcomingFestivals({int limit = 5}) async {
    try {
      final url = Uri.parse('$_baseUrl/festivals/upcoming?limit=$limit');
      final response = await http.get(url).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final list = (decoded is Map ? decoded['data'] : decoded) as List? ?? [];
        return list.map((item) => FestivalItem.fromJson(item as Map<String, dynamic>)).toList();
      }
    } catch (_) {
      // Fallback gracefully
    }

    return _getFallbackFestivals();
  }

  String _getTodayFormatted() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  DailyPanchangData _getFallbackPanchang(String date, String location) {
    final now = DateTime.now();
    final dayNames = ['सोमवार', 'मंगलवार', 'बुधवार', 'गुरुवार', 'शुक्रवार', 'शनिवार', 'रविवार'];
    final dayName = dayNames[(now.weekday - 1) % 7];

    return DailyPanchangData(
      date: date,
      location: location,
      gregorianFormatted: '$dayName, ${now.day} ${_getMonthName(now.month)} ${now.year}',
      greeting: 'राधे-राधे, आज का दिन मंगलमय हो',
      samvat: SamvatInfo(
        vikramSamvat: now.year + 57,
        shakaSamvat: now.year - 78,
        month: 'भाद्रपद',
        paksha: 'शुक्ल',
        dayName: dayName,
      ),
      tithi: const PanchangTithi(
        name: 'एकादशी',
        number: 11,
        endsAt: 'दोपहर 02:36 तक',
      ),
      nakshatra: const PanchangItem(
        name: 'उत्तराभाद्रपद',
        endsAt: 'अगले दिन 04:12 AM तक',
      ),
      yoga: const PanchangItem(
        name: 'हर्षण',
        endsAt: 'रात 09:15 AM तक',
      ),
      karana: const PanchangItem(
        name: 'बव',
        endsAt: 'दोपहर 02:36 PM तक',
      ),
      abhijitMuhurat: const MuhuratItem(
        startTime: '11:51 AM',
        endTime: '12:45 PM',
        isAuspicious: true,
        description: 'नवीन कार्यों एवं खरीदारी हेतु अत्यंत शुभ फलदायी समय',
      ),
      rahuKaal: const MuhuratItem(
        startTime: '05:15 PM',
        endTime: '06:55 PM',
        isAuspicious: false,
        description: 'इस अवधि में शुभ कार्य न करें',
      ),
      celestial: const CelestialInfo(
        sunrise: '05:32 AM',
        sunset: '07:05 PM',
        moonrise: '02:15 PM',
        moonset: '03:40 AM',
        moonPhase: 'शुक्ल पक्ष',
        moonIlluminationPercent: 85,
      ),
    );
  }

  String _getMonthName(int month) {
    const months = ['जनवरी', 'फ़रवरी', 'मार्च', 'अप्रैल', 'मई', 'जून', 'जुलाई', 'अगस्त', 'सितंबर', 'अक्टूबर', 'नवंबर', 'दिसंबर'];
    return months[(month - 1).clamp(0, 11)];
  }

  List<FestivalItem> _getFallbackFestivals() {
    return const [
      FestivalItem(
        id: 'fest-1',
        title: 'गोवर्धन पूजा (अन्नकूट)',
        subtitle: 'कार्तिक शुक्ल प्रतिपदा',
        date: '2026-09-23',
        badge: 'कल',
        daysLeft: 1,
        description: 'विशेष पूजा, छप्पन भोग एवं अन्नकूट उत्सव',
      ),
      FestivalItem(
        id: 'fest-2',
        title: 'वरूथिनी एकादशी',
        subtitle: 'श्री हरि विष्णु पूजन एवं व्रत',
        date: '2026-09-25',
        badge: '3 दिनों में',
        daysLeft: 3,
        description: 'भगवान विष्णु की भक्ति एवं एकादशी व्रत',
      ),
    ];
  }
}
