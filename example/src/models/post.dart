class PostModel {
  PostModel({
    required this.id,
    required this.title,
    required this.created,
    required this.message,
  });

  final String? id;
  final String title;
  final DateTime? created;
  final String message;

  PostModel copyWith({
    String? id,
    String? title,
    DateTime? created,
    String? message,
  }) {
    return PostModel(
      id: id ?? this.id,
      title: title ?? this.title,
      created: created ?? this.created,
      message: message ?? this.message,
    );
  }
}
