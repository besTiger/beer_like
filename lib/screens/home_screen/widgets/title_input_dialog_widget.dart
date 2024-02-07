import 'package:flutter/material.dart';

class TitleInputDialog {
  static Future<String?> show(BuildContext context) async {
    TextEditingController titleController = TextEditingController();

    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return _buildDialog(context, titleController);
      },
    ).then((result) {
      return result;
    });
  }

  static Widget _buildDialog(
      BuildContext context,
      TextEditingController titleController,
      ) {
    return Stack(
      children: [
        ModalBarrier(
          color: Colors.black.withOpacity(0.5),
          dismissible: false,
        ),
        AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.favorite),
              SizedBox(width: 8.0),
              Text('Enter Title'),
            ],
          ),
          content: TextField(
            controller: titleController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Title',
              prefixIcon: Icon(Icons.edit),
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
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ],
    );
  }
}
