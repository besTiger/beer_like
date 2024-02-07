import 'package:flutter/material.dart';
import 'dart:io';
import 'package:intl/intl.dart';
import '../data/photo_model.dart';

class PhotoCardWidget extends StatelessWidget {
  final PhotoItem photoItem;
  final VoidCallback onDismissed;
  final VoidCallback onTap;

  const PhotoCardWidget({
    Key? key,
    required this.photoItem,
    required this.onDismissed,
    required this.onTap,
  }) : super(key: key);

  String _formatTimestamp(DateTime timestamp) {
    return DateFormat('yyyy-MM-dd HH:mm').format(timestamp);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        child: Card(
          elevation: 4,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  photoItem.title,
                  style: const TextStyle(
                      fontSize: 16.0, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
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
                        width: 1.0,
                      ),
                    ),
                    child: Image.file(
                      File(photoItem.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatTimestamp(photoItem.timestamp),
                      style: const TextStyle(fontSize: 15.0),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
