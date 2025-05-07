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
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text(
            appLoc.postYourEquipment,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
              letterSpacing: -0.5,
            ),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(
            color: Colors.grey[200],
            height: 1.0,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          imagePicker(constraints.maxWidth),
                          const SizedBox(height: 32.0),
                          _buildInputSection(appLoc),
                          const SizedBox(height: 32.0),
                          nextButton(context, appLoc),
                          const SizedBox(height: 96.0),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection(AppLocalizations appLoc) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInputField(appLoc.name, _nameController),
          const SizedBox(height: 24.0),
          categoryDropdown(appLoc.category),
          const SizedBox(height: 24.0),
          _buildInputField(appLoc.description, _descriptionController, maxLines: 3),
          const SizedBox(height: 24.0),
          _buildInputField(appLoc.rentalPrice, _rentalPriceController, 
            prefixIcon: const Icon(Icons.attach_money, size: 20)),
          const SizedBox(height: 24.0),
          _buildInputField(appLoc.location, _locationController,
            prefixIcon: const Icon(Icons.location_on_outlined, size: 20)),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, 
      {int maxLines = 1, Icon? prefixIcon}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.red.withOpacity(0.5), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget imagePicker(double width) {
    final appLoc = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Equipment Photos',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          if (_imageFiles.isEmpty)
            Container(
              height: 200,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined, 
                      size: 48, color: Colors.grey[400]),
                    const SizedBox(height: 12),
                    Text(
                      'Add photos of your equipment',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _imageFiles.length + (_imageFiles.length < 4 ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _imageFiles.length) {
                    return _buildAddPhotoButton();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Stack(
                        children: [
                          Image.file(
                            _imageFiles[index],
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _imageFiles.removeAt(index);
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildImageButton(
                  appLoc.takePhoto,
                  Icons.camera_alt_outlined,
                  _takePhoto,
                  isPrimary: true,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildImageButton(
                  appLoc.pickImage,
                  Icons.photo_library_outlined,
                  _pickImage,
                  isPrimary: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAddPhotoButton() {
    return Container(
      width: 200,
      height: 200,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Center(
        child: Icon(
          Icons.add_circle_outline,
          size: 40,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  Widget _buildImageButton(
    String text,
    IconData icon,
    VoidCallback onPressed, {
    bool isPrimary = false,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 20,
        color: isPrimary ? Colors.white : Colors.black87,
      ),
      label: Text(
        text,
        style: TextStyle(
          color: isPrimary ? Colors.white : Colors.black87,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: isPrimary ? Palette.red : Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isPrimary ? Colors.transparent : Colors.grey[300]!,
          ),
        ),
        elevation: 0,
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
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: _selectedCategory ?? EquipmentCategories.getEquipmentCategories(context).first.englishTitle,
          items: EquipmentCategories.getEquipmentCategories(context)
              .map<DropdownMenuItem<String>>((category) {
            return DropdownMenuItem<String>(
              value: category.englishTitle,
              child: Text(
                category.localTitle,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
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
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Palette.red.withOpacity(0.5), width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          isExpanded: true,
        ),
      ],
    );
  }

  Widget nextButton(BuildContext context, AppLocalizations appLoc) {
    return ElevatedButton(
      onPressed: () {
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
            builder: (context) => PostScreenAdditional(
              imageFiles: _imageFiles,
              equipment: equipment,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Text(
        appLoc.next,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
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
}
