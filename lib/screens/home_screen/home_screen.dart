import 'package:beer_like/screens/home_screen/photo_detail_screen.dart';
import 'package:beer_like/screens/home_screen/photo_model.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'data_base_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  HomeScreenState createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  List<PhotoItem> photoList = [];

  @override
  void initState() {
    super.initState();
    _loadPhotos();
  }

  Future<void> _loadPhotos() async {
    List<Map<String, dynamic>> photos =
    await DatabaseHelper.instance.retrievePhotos();

    setState(() {
      photoList = photos.map((photo) => PhotoItem.fromMap(photo)).toList();
    });
  }

  Future<void> _takePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      String? title = await _getTitleFromUser();

      if (title != null) {
        int id = await DatabaseHelper.instance.insertPhoto({
          'imagePath': pickedFile.path,
          'title': title,
        });

        setState(() {
          photoList.add(PhotoItem(
            id: id,
            imagePath: pickedFile.path,
            title: title,
          ));
        });
      }
    }
  }

  Future<String?> _getTitleFromUser() async {
    TextEditingController titleController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Enter Title'),
          content: TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: 'Title'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, null); // Cancel
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, titleController.text.trim());
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _navigateToPhotoDetailScreen(PhotoItem photoItem) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PhotoDetailScreen(
          photoItem: photoItem,
          onPhotoDeleted: _loadPhotos, // Pass the callback function
        ),
      ),
    );
  }

  Widget _buildPhotoItem(PhotoItem photoItem) {
    return GestureDetector(
      onTap: () {
        _navigateToPhotoDetailScreen(photoItem);
      },
      child: Hero(
        tag: 'photo${photoItem.id}',
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  photoItem.title,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ),
              SizedBox(
                width: double.infinity,
                height: 160,
                child: ClipRect(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0,
                      ),
                    ),
                    child: Image.file(
                      File(photoItem.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Photo List'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 0.8,
          ),
          itemCount: photoList.length,
          itemBuilder: (context, index) {
            return _buildPhotoItem(photoList[index]);
          },
        ),
      ),
      floatingActionButton: SizedBox(
        width: 70,
        height: 70,
        child: FloatingActionButton(
          onPressed: _takePhoto,
          child: Image.asset(
            'assets/logo_splash.png',
            width: 50,
            height: 50,
          ),
        ),
      ),
    );
  }
}
