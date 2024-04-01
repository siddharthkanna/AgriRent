import 'dart:io';
import 'package:agrirent/components/image_picker.dart';
import 'package:agrirent/components/textField.dart';
import 'package:agrirent/models/EquipmentCategory.model.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/screens/postScreen/postScreenAdditional.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  _PostScreenState createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ImagePickerHelper _imagePickerHelper = ImagePickerHelper();
  final List<File> _imageFiles = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _rentalPriceController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 6, top: 6),
          child: Text(
            appLoc.postYourEquipment,
            style: const TextStyle(
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
                    WidgetUtils.textField(appLoc.name, _nameController),
                    const SizedBox(height: 20.0),
                    categoryDropdown(appLoc.category),
                    const SizedBox(height: 20.0),
                    WidgetUtils.textField(
                      appLoc.description,
                      _descriptionController,
                    ),
                    const SizedBox(height: 20.0),
                    WidgetUtils.textField(
                      appLoc.rentalPrice,
                      _rentalPriceController,
                    ),
                    const SizedBox(height: 20.0),
                    WidgetUtils.textField(appLoc.location, _locationController),
                    const SizedBox(height: 20.0),
                    const SizedBox(height: 10.0),
                    nextButton(context, appLoc),
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
    final appLoc = AppLocalizations.of(context)!;
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
            elevatedButton(appLoc.takePhoto, Palette.red, _takePhoto),
            elevatedButton(appLoc.pickImage, Colors.white, _pickImage),
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

  Widget nextButton(BuildContext context, AppLocalizations appLoc) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to the next screen for additional details
        Equipment equipment = Equipment(
          name: _nameController.text,
          category: _selectedCategory ?? '',
          description: _descriptionController.text,
          rentalPrice: double.tryParse(_rentalPriceController.text) ?? 0.0,
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
      child: Text(
        appLoc.next,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

Widget categoryDropdown(String label) {
  final appLoc = AppLocalizations.of(context)!;

  return Column(
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
      DropdownButtonFormField<String>(
        value: _selectedCategory ?? EquipmentCategories.getEquipmentCategories(context).first.englishTitle,
        items: EquipmentCategories.getEquipmentCategories(context)
            .map<DropdownMenuItem<String>>((category) {
          return DropdownMenuItem<String>(
            value: category.englishTitle,
            child: Text(
              category.localTitle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.black,
              ),
            ),
          );
        }).toList(),
        onChanged: (String? value) {
          setState(() {
            _selectedCategory = value!;
          });
        },
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey[200]!),
            borderRadius: BorderRadius.circular(12.0),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    ],
  );
}
}
