import 'dart:io';
import 'package:flutter/material.dart';
import 'package:beer_like/screens/home_screen/data/photo_model.dart';
import '../home_screen/data/data_base_helper.dart';

class PhotoDetailScreen extends StatefulWidget {
  final PhotoItem photoItem;
  final VoidCallback onPhotoDeleted;

  const PhotoDetailScreen({
    Key? key,
    required this.photoItem,
    required this.onPhotoDeleted,
  }) : super(key: key);

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
    _descriptionController =
        TextEditingController(text: widget.photoItem.description);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Photo Detail'),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView(
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
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                _titleController.text,
                                style: TextStyle(
                                  fontSize: 24.0, // Adjust the font size
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black,
                                    width: 1.0,
                                  ),
                                ),
                                padding: const EdgeInsets.all(8.0),
                                child: TextField(
                                  controller: _descriptionController,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                  ),
                                  maxLines: null, // Allow unlimited lines
                                  keyboardType: TextInputType.multiline,
                                ),
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
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _saveChanges();
                },
                child: const Text('Save Changes'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  _deletePhoto();
                },
                child: const Text('Delete'),
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

      await DatabaseHelper.instance
          .updatePhoto(widget.photoItem.id, updatedPhoto);
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
