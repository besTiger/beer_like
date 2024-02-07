import 'dart:convert';

class PhotoItem {
  final int id;
  final String imagePath;
  String title;
  String description;
  DateTime timestamp;

  PhotoItem({
    required this.id,
    required this.imagePath,
    required this.title,
    this.description = '',
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PhotoItem.fromMap(Map<String, dynamic> map) {
    return PhotoItem(
      id: map['id'] ?? 0,
      imagePath: map['imagePath'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      timestamp: DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }

  String toJson() {
    return jsonEncode(toMap());
  }

  factory PhotoItem.fromJson(String json) {
    return PhotoItem.fromMap(jsonDecode(json));
  }
}
