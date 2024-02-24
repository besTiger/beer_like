import 'package:flutter/material.dart';

import 'UserData.dart';

class ProfileScreen extends StatelessWidget {
  final UserData userData;

  const ProfileScreen({Key? key, required this.userData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(userData.name, style: const TextStyle(fontSize: 20)),
            Text(userData.email, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}