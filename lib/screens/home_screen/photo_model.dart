class PhotoItem {
  final int id;
  final String imagePath;
  String title;


  PhotoItem({required this.id, required this.imagePath, required this.title,});

  factory PhotoItem.fromMap(Map<String, dynamic> map) {
    return PhotoItem(
      id: map['id'],
      imagePath: map['imagePath'],
      title: map['title'] ?? '',
    );
  }
}