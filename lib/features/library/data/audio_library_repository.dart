import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:guruji/core/constant/api_constants.dart';
import 'package:guruji/core/services/user_persistence_service.dart';
import 'package:guruji/features/library/data/audio_library_models.dart';

class AudioLibraryRepository {
  final String _baseUrl = ApiConstants.baseUrl;

  /// Fetch all active Deity categories for horizontal filter
  Future<List<DeityCategory>> fetchDeities() async {
    try {
      final url = Uri.parse('$_baseUrl/audio/categories');
      final response = await http.get(url).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final list = (decoded is Map ? decoded['data'] : decoded) as List? ?? [];
        if (list.isNotEmpty) {
          return list.map((item) => DeityCategory.fromJson(item as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {
      // Fallback gracefully to predefined deities
    }

    return _getFallbackDeities();
  }

  /// Fetch all audio tracks with deity filter and search query
  Future<List<AudioTrackItem>> fetchAudioTracks({
    String? deity,
    String? search,
    String? category,
    int page = 1,
    int limit = 30,
  }) async {
    try {
      final queryParams = <String, String>{
        'page': page.toString(),
        'limit': limit.toString(),
      };
      if (deity != null && deity.isNotEmpty && deity != 'All') {
        queryParams['deity'] = deity;
      }
      if (search != null && search.trim().isNotEmpty) {
        queryParams['search'] = search.trim();
      }
      if (category != null && category.isNotEmpty) {
        queryParams['category'] = category;
      }

      final uri = Uri.parse('$_baseUrl/audio/tracks').replace(queryParameters: queryParams);
      final response = await http.get(uri).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        final list = (decoded is Map ? decoded['data'] : decoded) as List? ?? [];
        if (list.isNotEmpty) {
          return list.map((item) => AudioTrackItem.fromJson(item as Map<String, dynamic>)).toList();
        }
      }
    } catch (_) {
      // Fallback to local filter
    }

    return _getFallbackTracks(deity: deity, search: search);
  }

  /// Toggle track favorite
  Future<bool> toggleFavorite(String trackId) async {
    try {
      final token = await UserPersistenceService.getToken();
      final url = Uri.parse('$_baseUrl/audio/favorites/toggle');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'trackId': trackId}),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body) as Map<String, dynamic>;
        return decoded['isFavorite'] as bool? ?? true;
      }
    } catch (_) {}

    return true;
  }

  List<DeityCategory> _getFallbackDeities() {
    return const [
      DeityCategory(
        id: 'd-ram',
        key: 'Ram',
        name: 'Ram',
        imageUrl: '',
        assetFallback: 'assets/images/ram_divine.jpg',
        order: 1,
      ),
      DeityCategory(
        id: 'd-krishna',
        key: 'Krishna',
        name: 'Krishna',
        imageUrl: '',
        assetFallback: 'assets/images/krishna_divine.jpg',
        order: 2,
      ),
      DeityCategory(
        id: 'd-shiva',
        key: 'Shiva',
        name: 'Shiva',
        imageUrl: '',
        assetFallback: 'assets/images/shiva_divine.jpg',
        order: 3,
      ),
      DeityCategory(
        id: 'd-hanuman',
        key: 'Hanuman',
        name: 'Hanuman',
        imageUrl: '',
        assetFallback: 'assets/images/ram_divine.jpg',
        order: 4,
      ),
    ];
  }

  List<AudioTrackItem> _getFallbackTracks({String? deity, String? search}) {
    final all = const [
      AudioTrackItem(
        id: '1',
        title: 'Hanuman Chalisa',
        artist: 'Goswami Tulsidas',
        deity: 'Hanuman',
        category: 'chalisa',
        audioUrl: '',
        coverImage: '',
        assetFallback: 'assets/images/ram_divine.jpg',
        durationFormatted: '10 mins',
        totalSeconds: 600,
        lyrics: 'श्री गुरु चरन सरोज रज निज मनु मुकुरु सुधारि।\nबरनउँ रघुबर बिमल जसु जो दायकु फल चारि॥\n\nबुद्धिहीन तनु जानिके, सुमिरौं पवन-कुमार।\nबल बुधि बिद्या देहु मोहिं, हरहु कलेस बिकार॥\n\nजय हनुमान ज्ञान गुन सागर। जय कपीस तिहुँ लोक उजागर॥\nराम दूत अतुलित बल धामा। अंजनि-पुत्र पवनसुत नामा॥',
      ),
      AudioTrackItem(
        id: '2',
        title: 'Vishnu Sahasranama',
        artist: 'Maharishi Ved Vyas',
        deity: 'Krishna',
        category: 'stotram',
        audioUrl: '',
        coverImage: '',
        assetFallback: 'assets/images/krishna_divine.jpg',
        durationFormatted: '25 mins',
        totalSeconds: 1500,
        lyrics: 'शुक्लाम्बरधरं विष्णुं शशिवर्णं चतुर्भुजम्।\nप्रसन्नवदनं ध्यायेत् सर्वविघ्नोपशान्तये॥\n\nशान्ताकारं भुजगशयनं पद्मनाभं सुरेशम्।\nविश्वाधारं गगनसदृशं मेघवर्णं शुभाङ्गम्॥',
      ),
      AudioTrackItem(
        id: '3',
        title: 'Shiva Tandava Stotram',
        artist: 'Ravana',
        deity: 'Shiva',
        category: 'stotram',
        audioUrl: '',
        coverImage: '',
        assetFallback: 'assets/images/shiva_divine.jpg',
        durationFormatted: '8 mins',
        totalSeconds: 480,
        lyrics: 'जटाटवीगलज्जलप्रवाहपावितस्थले गलेऽवलम्ब्य लम्बितां भुजङ्गतुङ्गमालिकाम्।\nडमड्डमड्डमड्डमन्निनादवड्डमर्वयं चकार चण्डताण्डवं तनोतु नः शिवः शिवम्॥',
      ),
      AudioTrackItem(
        id: '4',
        title: 'Gayatri Mantra',
        artist: 'Rigveda Samhita',
        deity: 'Ram',
        category: 'mantra',
        audioUrl: '',
        coverImage: '',
        assetFallback: 'assets/images/ram_divine.jpg',
        durationFormatted: '15 mins',
        totalSeconds: 900,
        lyrics: 'ॐ भूर्भुवः स्वः तत्सवितुर्वरेण्यं।\nभर्गो देवस्य धीमहि धियो यो नः प्रचोदयात्॥',
      ),
      AudioTrackItem(
        id: '5',
        title: 'Shri Ram Stuti',
        artist: 'Goswami Tulsidas',
        deity: 'Ram',
        category: 'stuti',
        audioUrl: '',
        coverImage: '',
        assetFallback: 'assets/images/ram_divine.jpg',
        durationFormatted: '04:12',
        totalSeconds: 252,
        lyrics: 'श्री रामचन्द्र कृपालु भजु मन हरण भवभय दारुणम्।\nनवकंज लोचन, कंज मुख, कर कंज, पद कंजारुणम्॥\n\nकंदर्प अगणित अमित छबि, नवनील नीरद सुन्दरम्।\nपट पीत मानहु तड़ित रुचि शुचि नौमि जनक सुतावरम्॥',
      ),
    ];

    var filtered = all;

    if (deity != null && deity.isNotEmpty && deity != 'All') {
      filtered = filtered.where((t) => t.deity.toLowerCase() == deity.toLowerCase()).toList();
    }

    if (search != null && search.trim().isNotEmpty) {
      final q = search.trim().toLowerCase();
      filtered = filtered.where((t) {
        return t.title.toLowerCase().contains(q) ||
            t.artist.toLowerCase().contains(q) ||
            t.deity.toLowerCase().contains(q) ||
            t.category.toLowerCase().contains(q);
      }).toList();
    }

    return filtered;
  }
}
