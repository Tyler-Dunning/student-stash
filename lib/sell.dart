import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'db_operations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Sell(),
    );
  }
}

class Sell extends StatelessWidget {
  const Sell({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Text(
              "Sell Page",
              style: TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            right: 16,
            child: FloatingActionButton(
              onPressed: () {
                _showProductEntryDialog(context);
              },
              child: Icon(Icons.edit),
            ),
          ),
        ],
      ),
    );
  }

  void _showProductEntryDialog(BuildContext context) async {
    ImagePicker imagePicker = ImagePicker();

    TextEditingController titleController = TextEditingController();
    TextEditingController descriptionController = TextEditingController();

    List<XFile> imageFiles = [];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Enter Product Information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Description'),
              ),
              ElevatedButton(
                onPressed: () async {
                  XFile? file = await imagePicker.pickImage(
                    source: ImageSource.gallery,
                  );

                  if (file != null) {
                    imageFiles.add(file);
                  }
                },
                child: Text('Upload Images'),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                String title = titleController.text;
                String description = descriptionController.text;

                // Upload images
                for (XFile file in imageFiles) {
                  await DbOperations.uploadListing(file, title, description);
                }

                // You can use the user input for other backend stuff here.
                Navigator.of(context).pop();
              },
              child: Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
