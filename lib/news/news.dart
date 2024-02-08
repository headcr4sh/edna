library edna.news;

import 'dart:ui';

final String _galnetUrlPattern = 'https://cms.zaonce.net/{{language}}/jsonapi/node/galnet_article';

String galnetUrl(final Locale locale, {int offset = 0, int limit = 12}) => '${_galnetUrlPattern.replaceFirst(r'{{language}}', locale.languageCode)}?&sort=-published_at&page[offset]=$offset&page[limit]=$limit';
