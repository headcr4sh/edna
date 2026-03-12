import 'dart:io';
import 'package:flutter/material.dart';
import 'article.dart';
import 'news.dart' as galnet;

class GalnetNewsPage extends StatefulWidget {
  const GalnetNewsPage({super.key});

  @override
  State<GalnetNewsPage> createState() => _GalnetNewsPageState();
}

class _GalnetNewsPageState extends State<GalnetNewsPage> {
  late Future<List<Article>> _newsFuture;

  @override
  void initState() {
    super.initState();
    final parts = Platform.localeName.split('_');
    final locale = parts.length > 1 ? Locale(parts[0], parts[1]) : Locale(parts[0]);
    _newsFuture = galnet.fetchGalnetNews(locale);
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold without AppBar so it blends seamlessly as a body page
    return FutureBuilder<List<Article>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No news available.'));
        }

        final articles = snapshot.data!;
        return ListView.separated(
          padding: const EdgeInsets.all(8.0),
          itemCount: articles.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final article = articles[index];
            return ListTile(
              title: Text(article.title),
              subtitle: Text(article.date,
                  style: const TextStyle(color: Colors.orange)),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ArticleDetailPage(article: article),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

class ArticleDetailPage extends StatelessWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  String _cleanContent(String html) {
    return html
        .replaceAll(RegExp(r'<br\s*/?>'), '\n')
        .replaceAll(RegExp(r'</?(p|div)[^>]*>'), '\n\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll('&#039;', "'")
        .replaceAll('&quot;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galnet Communication')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              article.date,
              style: Theme.of(context)
                  .textTheme
                  .titleSmall
                  ?.copyWith(color: Colors.orange),
            ),
            const SizedBox(height: 16),
            Text(
              _cleanContent(article.content),
              style:
                  Theme.of(context).textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ],
        ),
      ),
    );
  }
}
