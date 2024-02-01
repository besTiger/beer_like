import 'package:beer_like/screens/home_screen/photo_%20card_widget.dart';
import 'package:beer_like/screens/home_screen/photo_detail_screen.dart';
import 'package:beer_like/screens/home_screen/photo_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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

    // Add a check for an empty list
    if (photoList.isEmpty) {
      // Display a message or handle it as needed
      if (kDebugMode) {
        print("No photos available.");
      }
    }
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
            description: "Default description",
            timestamp: DateTime.now(),
          ));
        });
      }
    }
  }

  Future<String?> _getTitleFromUser() async {
    TextEditingController titleController = TextEditingController();
    FocusNode focusNode = FocusNode();

    bool isDialogOpen = true; // Variable to track if the dialog is open

    // Add listener to the focus node to open the keyboard when it gains focus
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        FocusScope.of(context).requestFocus(focusNode);
      }
    });

    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        // Delay the dialog to allow time for the focus request
        Future.delayed(Duration.zero, () {
          FocusScope.of(context).requestFocus(focusNode);
        });

        return Stack(
          children: [
            ModalBarrier(
              color: Colors.black.withOpacity(0.5),
              dismissible: false,
            ),
            AlertDialog(
              title: Row(
                children: [
                  const Icon(Icons.edit), // Pencil icon for better design
                  const SizedBox(width: 8.0),
                  const Text('Enter Title'),
                ],
              ),
              content: TextField(
                controller: titleController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  hintText: 'Title',
                  prefixIcon: const Icon(Icons.edit), // Pencil icon inside the TextField
                ),
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
                    isDialogOpen = false; // Set dialog status to closed when saved
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        );
      },
    );

    isDialogOpen = false; // Set dialog status to closed after the dialog is dismissed
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Beer List',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7,
            ),
            itemCount: photoList.length,
            itemBuilder: (context, index) {
              return PhotoCardWidget(
                photoItem: photoList[index],
                onDismissed: () {
                  _handleDismiss(index);
                },
                onTap: () {
                  _navigateToPhotoDetailScreen(photoList[index]);
                },
              );
            },
          ),
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

  void _handleDismiss(int index) async {
    await DatabaseHelper.instance.deletePhoto(photoList[index].id);
    setState(() {
      photoList.removeAt(index);
    });
    // Refresh the photo list after dismissing a photo
    _loadPhotos();
  }

}
