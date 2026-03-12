import 'dart:convert' show jsonDecode;
import 'dart:ui' show Locale;
import 'package:http/http.dart' as http;
import 'article.dart';

final String _galnetUrlPattern = 'https://cms.zaonce.net/{{language}}/jsonapi/node/galnet_article';

String galnetUrl(final Locale locale, {int offset = 0, int limit = 12}) {
  String lang = locale.languageCode.toLowerCase();
  String? country = locale.countryCode?.toUpperCase();

  String fullLang;
  if (country != null) {
    fullLang = '$lang-$country';
  } else {
    // Fallbacks for known languages if country is missing
    fullLang = switch (lang) {
      'en' => 'en-US',
      'de' => 'de-DE',
      'fr' => 'fr-FR',
      'es' => 'es-ES',
      'ru' => 'ru-RU',
      _ => lang,
    };
  }
  
  return '${_galnetUrlPattern.replaceFirst(r'{{language}}', fullLang)}?&sort=-published_at&page[offset]=$offset&page[limit]=$limit';
}

Future<List<Article>> fetchGalnetNews(Locale locale, {int offset = 0, int limit = 12}) async {
  final url = galnetUrl(locale, offset: offset, limit: limit);
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final items = (data['data'] as List<dynamic>?) ?? [];

    return items.map((item) {
      final attrs = item['attributes'] as Map<String, dynamic>;
      final body = attrs['body'] as Map<String, dynamic>?;
      return Article(
        title: attrs['title'] as String? ?? 'No Title',
        date: attrs['field_galnet_date'] as String? ?? attrs['created'] as String? ?? '',
        content: body?['value'] as String? ?? attrs['body'] as String? ?? '',
      );
    }).toList();
  } else {
    throw Exception('Failed to load galnet news: ${response.statusCode}');
  }
}
