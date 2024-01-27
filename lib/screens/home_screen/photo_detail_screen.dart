import 'dart:io';

import 'package:flutter/material.dart';
import 'package:beer_like/screens/home_screen/photo_model.dart';
import 'data_base_helper.dart';

class PhotoDetailScreen extends StatelessWidget {
  final PhotoItem photoItem;
  final VoidCallback onPhotoDeleted;

  const PhotoDetailScreen({Key? key, required this.photoItem, required this.onPhotoDeleted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Photo Detail'),
      ),
      body: Hero(
        tag: 'photo${photoItem.id}',
        child: ListView( // Wrap with ListView for scrolling
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(
                    File(photoItem.imagePath),
                    fit: BoxFit.cover,
                    height: 200, // Set a fixed height for the smaller version of the photo
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                    photoItem.title,
                    style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      _deletePhoto(context, photoItem);
                    },
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deletePhoto(BuildContext context, PhotoItem photoItem) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this photo?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Confirm deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      await DatabaseHelper.instance.deletePhoto(photoItem.id);

      // Call the callback function to update the UI on HomeScreen
      onPhotoDeleted();

      Navigator.pop(context); // Navigate back to the previous screen
    }
  }
}
