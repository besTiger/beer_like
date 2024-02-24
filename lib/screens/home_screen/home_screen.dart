import 'package:beer_like/screens/home_screen/data/photo_model.dart';
import 'package:beer_like/screens/home_screen/widgets/floating_action_button_widget.dart';
import 'package:beer_like/screens/home_screen/widgets/title_input_dialog_widget.dart';
import 'package:beer_like/screens/home_screen/widgets/beer_list_screen_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../ProfileScreen.dart';
import '../../UserData.dart';
import '../details_photo_screen/photo_detail_screen.dart';
import 'data/data_base_helper.dart';

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
      String? title = await TitleInputDialog.show(context);

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

  void _handleDismiss(int index) async {
    await DatabaseHelper.instance.deletePhoto(photoList[index].id);
    setState(() {
      photoList.removeAt(index);
    });
    // Refresh the photo list after dismissing a photo
    _loadPhotos();
  }

  // Add the _fetchUserData method here
  Future<UserData?> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);
      final documentSnapshot = await docRef.get();
      if (documentSnapshot.exists) {
        return UserData.fromMap(documentSnapshot.data()!);
      }
    }
    return null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.account_circle),
          onPressed: () async {
            // Navigate to the new screen after fetching user data
            final userData = await _fetchUserData();
            if (userData != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(userData: userData),
                ),
              );
            } else {
              // handle the case where user data is not available
              print("Error fetching user data");
            }
          },
        ),
      ),
      body: BeerListScreen(
        photoList: photoList,
        onDismiss: _handleDismiss,
        onTap: _navigateToPhotoDetailScreen,
        onTakePhoto: _takePhoto,
      ),
      floatingActionButton: CustomFloatingActionButton(
        onPressed: _takePhoto,
      ),
    );
  }
}
