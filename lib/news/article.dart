class Article {
  final String title;
  final String date;
  final String content;

  Article({required this.title, required this.date, required this.content});

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      title: json['title'] as String,
      date: json['date'] as String,
      content: json['content'] as String,
    );
  }

  @override
  String toString() {
    return '[$date] $title';
  }
}
