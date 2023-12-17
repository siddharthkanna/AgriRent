import 'dart:io';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PostScreen extends StatefulWidget {
  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _imageFile;

  final TextEditingController _equipmentNameController =
      TextEditingController();
  final TextEditingController _equipmentModelController =
      TextEditingController();
  final TextEditingController _equipmentDescriptionController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 6, top: 6),
          child: Text(
            'Post Your Equipment',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildImagePicker(constraints.maxWidth),
                  const SizedBox(height: 20.0),
                  _buildTextField("Equipment Name", _equipmentNameController),
                  const SizedBox(height: 10.0),
                  _buildTextField("Equipment Model", _equipmentModelController),
                  const SizedBox(height: 10.0),
                  _buildTextField(
                    "Equipment Description",
                    _equipmentDescriptionController,
                  ),
                  const SizedBox(height: 10.0),
                  _buildTextField("Price", _priceController),
                  const SizedBox(height: 10.0),
                  _buildPostButton(),
                  const SizedBox(height: 100.0),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildImagePicker(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
              image: _imageFile != null
                  ? DecorationImage(
                      image: FileImage(_imageFile!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: _imageFile == null
                ? const Center(
                    child: Icon(
                      Icons.camera_alt,
                      size: 40.0,
                      color: Colors.grey,
                    ),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                _takePhoto();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                backgroundColor: Palette.red,
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24.0,
                ), // Add padding around the button
                minimumSize: Size(170, 0), // Increase button width
              ),
              child: const Text(
                'Take Photo',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(width: 10.0), // Add gap between buttons
            ElevatedButton(
              onPressed: () {
                _pickImageFromGallery();
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  side:
                      const BorderSide(color: Colors.black), // Add border line
                ),
                backgroundColor: Colors.white, // Set background color to white
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 24.0,
                ), // Add padding around the button
                minimumSize: const Size(170, 0), // Increase button width
              ),
              child: const Text(
                'Browse gallery',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.black), // Set text color to black
              ),
            ),
          ],
        ),
      ],
    );
  }

  Future _takePhoto() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future _pickImageFromGallery() async {
    final pickedFile =
        await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8.0),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[200], // Grey background color
              borderRadius: BorderRadius.circular(12.0), // Rounded corners
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  border: InputBorder.none, // No visible border
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement post functionality here
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        backgroundColor: Palette.red,
      ),
      child: const Text(
        'Post',
        style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
      ),
    );
  }
}
