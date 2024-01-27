class PhotoItem {
  // Додано поле title
  final int id;
  final String imagePath;
  String title;
  String description;

  PhotoItem({required this.id, required this.imagePath, required this.title, required this.description});

  factory PhotoItem.fromMap(Map<String, dynamic> map) {
    return PhotoItem(
      id: map['id'],
      imagePath: map['imagePath'],
      title: map['title'] ?? '', // Використовуємо title, якщо він існує
      description: map['description'] ?? '',
    );
  }
}