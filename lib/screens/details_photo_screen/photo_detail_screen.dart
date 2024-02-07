import 'dart:io';
import 'package:flutter/material.dart';
import 'package:beer_like/screens/home_screen/data/photo_model.dart';
import '../home_screen/data/data_base_helper.dart';

class PhotoDetailScreen extends StatefulWidget {
  final PhotoItem photoItem;
  final VoidCallback onPhotoDeleted;

  const PhotoDetailScreen({Key? key, required this.photoItem, required this.onPhotoDeleted}) : super(key: key);

  @override
  _PhotoDetailScreenState createState() => _PhotoDetailScreenState();
}

class _PhotoDetailScreenState extends State<PhotoDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.photoItem.title);
    _descriptionController = TextEditingController(text: widget.photoItem.description);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Photo Detail'),
        ),
        body: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.file(
                    File(widget.photoItem.imagePath),
                    fit: BoxFit.cover,
                    height: 200,
                  ),
                  const SizedBox(height: 16.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _titleController,
                          decoration: const InputDecoration(labelText: 'Title'),
                        ),
                        const SizedBox(height: 16.0),
                        TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(labelText: 'Description'),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            _saveChanges();
                          },
                          child: const Text('Save Changes'),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: () {
                            _deletePhoto();
                          },
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveChanges() async {
    String updatedTitle = _titleController.text.trim();
    String updatedDescription = _descriptionController.text.trim();

    if (updatedTitle.isNotEmpty || updatedDescription.isNotEmpty) {
      Map<String, dynamic> updatedPhoto = {
        'title': updatedTitle,
        'description': updatedDescription,
      };

      await DatabaseHelper.instance.updatePhoto(widget.photoItem.id, updatedPhoto);
      widget.onPhotoDeleted(); // Refresh the UI on HomeScreen

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Changes saved successfully'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No changes made'),
        ),
      );
    }
  }

  Future<void> _deletePhoto() async {
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
      await DatabaseHelper.instance.deletePhoto(widget.photoItem.id);
      widget.onPhotoDeleted(); // Refresh the UI on HomeScreen

      Navigator.pop(context); // Navigate back to the previous screen
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
