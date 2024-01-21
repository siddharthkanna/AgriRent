import 'dart:io';
import 'package:agrirent/components/image_picker.dart';
import 'package:agrirent/components/textField.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/screens/postScreen/postScreenAdditional.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();
  final List<File> _imageFiles = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rentalPriceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    imagePicker(constraints.maxWidth),
                    const SizedBox(height: 20.0),
                    WidgetUtils.textField('Name', _nameController),
                    const SizedBox(height: 20.0),
                    WidgetUtils.textField('Category', _categoryController),
                    const SizedBox(height: 20.0),
                    WidgetUtils.textField(
                        'Description', _descriptionController),
                    const SizedBox(height: 20.0),
                    WidgetUtils.textField(
                        'Rental Price', _rentalPriceController),
                    const SizedBox(height: 20.0),
                    WidgetUtils.textField('Location', _locationController),
                    const SizedBox(height: 20.0),
                    const SizedBox(height: 10.0),
                    nextButton(),
                    const SizedBox(height: 100.0),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget imagePicker(double width) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            for (int i = 0; i < _imageFiles.length && i < 4; i++)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: DecorationImage(
                      image: FileImage(_imageFiles[i]),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            elevatedButton('Take Photo', Palette.red, _takePhoto),
            elevatedButton('Pick Image', Colors.white, _pickImage),
          ],
        ),
      ],
    );
  }

  Widget elevatedButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
          side: BorderSide(color: color == Colors.white ? Colors.black : color),
        ),
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(
          vertical: 12.0,
          horizontal: 24.0,
        ),
        minimumSize: const Size(144, 0),
      ),
      child: Text(
        text,
        style: TextStyle(
            fontSize: 16,
            color: color == Colors.white ? Colors.black : Colors.white),
      ),
    );
  }

  void _takePhoto() async {
    File? imageFile = await _imagePickerHelper.takePhoto();
    if (imageFile != null) {
      setState(() {
        _imageFiles.add(imageFile);
      });
    }
  }

  void _pickImage() async {
    File? imageFile = await _imagePickerHelper.pickImageFromGallery();
    if (imageFile != null) {
      setState(() {
        _imageFiles.add(imageFile);
      });
    }
  }

  Widget nextButton() {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the next screen for additional details
        Equipment equipment = Equipment(
          name: _nameController.text,
          category: _categoryController.text,
          description: _descriptionController.text,
          rentalPrice: double.parse(_rentalPriceController.text),
          location: _locationController.text,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdditionalDetailsScreen(
              imageFiles: _imageFiles,
              equipment: equipment,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        backgroundColor: Palette.red,
      ),
      child: const Text(
        'Next',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
