class Post {
  final int id, userId;
  final String title, body;

  Post({required this.id,
    required this.userId,
    required this.title,
    required this.body});

  factory Post.fromJson(
      Map<String, dynamic> j) =>
    Post(id: j['id'],
      userId: j['userId'],
      title: j['title'],
      body: j['body']);
}
