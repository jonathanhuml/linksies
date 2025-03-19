class LinkItem {
  final String id;
  final String title;
  final String url;
  final String content;
  final DateTime? createdAt;

  LinkItem({
    required this.id,
    required this.title,
    required this.url,
    required this.content,
    this.createdAt,
  });
}