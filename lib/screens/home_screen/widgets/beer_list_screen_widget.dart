import 'package:beer_like/screens/home_screen/data/photo_model.dart';
import 'package:beer_like/screens/home_screen/widgets/photo_%20card_widget.dart';
import 'package:flutter/material.dart';

class BeerListScreen extends StatelessWidget {
  final List<PhotoItem> photoList;
  final Function(int) onDismiss;
  final Function(PhotoItem) onTap;
  final Function() onTakePhoto;

  const BeerListScreen({
    required this.photoList,
    required this.onDismiss,
    required this.onTap,
    required this.onTakePhoto,
    Key? key,
  }) : super(key: key);

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
                  onDismiss(index);
                },
                onTap: () {
                  onTap(photoList[index]);
                },
              );
            },
          ),
        ),
      ),
    );
  }
}