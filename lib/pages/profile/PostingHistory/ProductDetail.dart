// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, library_private_types_in_public_api, sort_child_properties_last

import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/constants/snackBar.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:agrirent/models/equipment.model.dart';

class ProductInfoPagePost extends StatefulWidget {
  final Equipment equipment;

  const ProductInfoPagePost({Key? key, required this.equipment})
      : super(key: key);

  @override
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPagePost> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _rentalPriceController;
  late TextEditingController _locationController;
  late TextEditingController _conditionController;
  late TextEditingController _featuresController;
  late TextEditingController _deliveryModeController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.equipment.name);
    _descriptionController =
        TextEditingController(text: widget.equipment.description);
    _categoryController =
        TextEditingController(text: widget.equipment.category);
    _rentalPriceController =
        TextEditingController(text: widget.equipment.rentalPrice.toString());
    _locationController =
        TextEditingController(text: widget.equipment.location);
    _conditionController =
        TextEditingController(text: widget.equipment.condition ?? '');
    _featuresController =
        TextEditingController(text: widget.equipment.features ?? '');
    _deliveryModeController =
        TextEditingController(text: widget.equipment.deliveryMode ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _rentalPriceController.dispose();
    _locationController.dispose();
    _conditionController.dispose();
    _featuresController.dispose();
    _deliveryModeController.dispose();
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() {
    final editedTitle = _titleController.text;
    final editedDescription = _descriptionController.text;
    final editedCategory = _categoryController.text;
    final editedRentalPrice = double.parse(_rentalPriceController.text);
    final editedLocation = _locationController.text;
    final editedCondition = _conditionController.text;
    final editedFeatures = _featuresController.text;
    final editedDeliveryMode = _deliveryModeController.text;

    setState(() {
      widget.equipment.name = editedTitle;
      widget.equipment.description = editedDescription;
      widget.equipment.category = editedCategory;
      widget.equipment.rentalPrice = editedRentalPrice;
      widget.equipment.location = editedLocation;
      widget.equipment.condition = editedCondition;
      widget.equipment.features = editedFeatures;
      widget.equipment.deliveryMode = editedDeliveryMode;
      _isEditing = false;
    });
  }

  void _deletePosting() async {
    try {
      await EquipmentApi.deleteEquipment(context, widget.equipment.id!);
    } catch (e) {
      CustomSnackBar.showError(context, 'Error Deleting the equipment!');
      print('Error deleting posting: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Detail',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: _toggleEditing,
            icon: Icon(_isEditing ? Icons.close : Icons.edit),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageDisplay(widget.equipment.images),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Title:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  _isEditing
                      ? TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'Enter title',
                          ),
                        )
                      : Text(
                          widget.equipment.name,
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),
                  Text(
                    'Description:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  _isEditing
                      ? TextFormField(
                          controller: _descriptionController,
                          decoration: InputDecoration(
                            hintText: 'Enter description',
                          ),
                        )
                      : Text(
                          widget.equipment.description,
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),
                  Text(
                    'Category:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  _isEditing
                      ? TextFormField(
                          controller: _categoryController,
                          decoration: InputDecoration(
                            hintText: 'Enter category',
                          ),
                        )
                      : Text(
                          widget.equipment.category,
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),
                  Text(
                    'Rental Price:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  _isEditing
                      ? TextFormField(
                          controller: _rentalPriceController,
                          decoration: InputDecoration(
                            hintText: 'Enter rental price',
                          ),
                          keyboardType: TextInputType.number,
                        )
                      : Text(
                          widget.equipment.rentalPrice.toString(),
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),
                  Text(
                    'Location:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  _isEditing
                      ? TextFormField(
                          controller: _locationController,
                          decoration: InputDecoration(
                            hintText: 'Enter location',
                          ),
                        )
                      : Text(
                          widget.equipment.location,
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),
                  Text(
                    'Condition:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  _isEditing
                      ? TextFormField(
                          controller: _conditionController,
                          decoration: InputDecoration(
                            hintText: 'Enter condition',
                          ),
                        )
                      : Text(
                          widget.equipment.condition ?? 'Not specified',
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),
                  Text(
                    'Features:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  _isEditing
                      ? TextFormField(
                          controller: _featuresController,
                          decoration: InputDecoration(
                            hintText: 'Enter features',
                          ),
                        )
                      : Text(
                          widget.equipment.features ?? 'Not specified',
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),
                  Text(
                    'Delivery Mode:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                  SizedBox(height: 8),
                  _isEditing
                      ? TextFormField(
                          controller: _deliveryModeController,
                          decoration: InputDecoration(
                            hintText: 'Enter delivery mode',
                          ),
                        )
                      : Text(
                          widget.equipment.deliveryMode ?? 'Not specified',
                          style: TextStyle(fontSize: 16),
                        ),
                  SizedBox(height: 16),
                  if (_isEditing)
                    ElevatedButton(
                      onPressed: _saveChanges,
                      child: Text('Save'),
                    ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: _deletePosting,
                          child: Text(
                            'Delete Posting',
                            style: TextStyle(
                                color: Palette.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Palette.red,
                            padding: EdgeInsets.all(16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageDisplay(List<String>? images) {
    return SizedBox(
      height: 300,
      child: images != null && images.isNotEmpty
          ? Image.network(
              images.first,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            )
          : Center(
              child: Text(
                'No images available',
                style: TextStyle(fontSize: 16),
              ),
            ),
    );
  }
}
