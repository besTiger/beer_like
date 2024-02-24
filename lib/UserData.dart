class UserData {
  final String name;
  final String email;

  UserData({required this.name, required this.email});

  factory UserData.fromMap(Map<String, dynamic> map) =>
      UserData(name: map['name'] as String, email: map['email'] as String);
}