// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, avoid_print, library_private_types_in_public_api, sort_child_properties_last

import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/constants/snackBar.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:intl/intl.dart';

class ProductInfoPagePost extends StatefulWidget {
  final Equipment equipment;

  const ProductInfoPagePost({Key? key, required this.equipment})
      : super(key: key);

  @override
  _ProductInfoPageState createState() => _ProductInfoPageState();
}

class _ProductInfoPageState extends State<ProductInfoPagePost> with SingleTickerProviderStateMixin {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _categoryController;
  late TextEditingController _rentalPriceController;
  late TextEditingController _locationController;
  late TextEditingController _conditionController;
  late TextEditingController _featuresController;
  late TextEditingController _deliveryModeController;
  bool _isEditing = false;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _setupAnimations();
  }

  void _initializeControllers() {
    _titleController = TextEditingController(text: widget.equipment.name);
    _descriptionController = TextEditingController(text: widget.equipment.description);
    _categoryController = TextEditingController(text: widget.equipment.category);
    _rentalPriceController = TextEditingController(text: widget.equipment.rentalPrice.toString());
    _locationController = TextEditingController(text: widget.equipment.location);
    _conditionController = TextEditingController(text: widget.equipment.condition ?? '');
    _featuresController = TextEditingController(text: widget.equipment.features ?? '');
    _deliveryModeController = TextEditingController(text: widget.equipment.deliveryMode ?? '');
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _disposeControllers();
    _animationController.dispose();
    super.dispose();
  }

  void _disposeControllers() {
    _titleController.dispose();
    _descriptionController.dispose();
    _categoryController.dispose();
    _rentalPriceController.dispose();
    _locationController.dispose();
    _conditionController.dispose();
    _featuresController.dispose();
    _deliveryModeController.dispose();
  }

  void _toggleEditing() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  void _saveChanges() async {
    try {
      // Show loading indicator
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Center(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Palette.red),
                ),
                SizedBox(height: 16),
                Text(
                  'Saving changes...',
                  style: TextStyle(
                    color: Colors.grey[800],
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );

      // Update equipment data
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

      // Dismiss loading indicator
      Navigator.pop(context);

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 8),
              Text('Changes saved successfully'),
            ],
          ),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    } catch (e) {
      // Dismiss loading indicator
      Navigator.pop(context);
      
      // Show error message
      CustomSnackBar.showError(context, 'Error saving changes: $e');
    }
  }

  void _deletePosting() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_rounded, color: Colors.red[400], size: 28),
              SizedBox(width: 8),
              Text(
                'Delete Listing',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to delete this listing? This action cannot be undone.',
            style: TextStyle(color: Colors.black54, height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.grey[700]),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              ),
              child: Text(
                'Delete',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        // Show loading indicator
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Palette.red),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Deleting listing...',
                    style: TextStyle(
                      color: Colors.grey[800],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

      await EquipmentApi.deleteEquipment(context, widget.equipment.id!);
    } catch (e) {
        CustomSnackBar.showError(context, 'Error deleting the equipment!');
      print('Error deleting posting: $e');
    }
    }
  }

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey[50],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey[200]!, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Palette.red, width: 1),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    );
  }

  @override
  Widget build(BuildContext context) {
    final formattedPrice = NumberFormat.currency(
      symbol: '₹',
      decimalDigits: 0,
    ).format(widget.equipment.rentalPrice);

    return Hero(
      tag: 'equipment-${widget.equipment.id}',
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        title: Text(
            _isEditing ? 'Edit Listing' : 'Equipment Details',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
        ),
          iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            onPressed: _toggleEditing,
              icon: Icon(
                _isEditing ? Icons.close : Icons.edit,
                color: Colors.white,
              ),
          ),
        ],
      ),
        body: Stack(
          children: [
            // Image Section
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 350, // Increased height to accommodate the overlay
              child: _buildImageDisplay(widget.equipment.images),
            ),
            // Content Section
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 300), // Space for the image
                  SlideTransition(
                    position: _slideAnimation,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 20,
                              offset: Offset(0, -5),
                  ),
                          ],
                        ),
                        padding: EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Price Section
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: _isEditing
                      ? TextFormField(
                          controller: _titleController,
                                          decoration: _buildInputDecoration('Enter title'),
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                          ),
                        )
                      : Text(
                          widget.equipment.name,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                  ),
                                ),
                                if (!_isEditing) ...[
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Palette.red.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                  Text(
                                          formattedPrice,
                                          style: TextStyle(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                            color: Palette.red,
                          ),
                                        ),
                  Text(
                                          '/day',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ],
                        ),
                            SizedBox(height: 20),

                            // Status Badge
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                color: widget.equipment.isAvailable
                                    ? Colors.green[500]
                                    : Colors.red[500],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    widget.equipment.isAvailable
                                        ? Icons.check_circle
                                        : Icons.timer,
                                    color: Colors.white,
                                    size: 16,
                        ),
                                  SizedBox(width: 6),
                  Text(
                                    widget.equipment.isAvailable ? 'Available' : 'Rented',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                  ),
                            SizedBox(height: 24),

                            // Info Sections
                            ...[
                              _buildInfoRow(
                                icon: Icons.location_on_outlined,
                                title: 'Location',
                                value: widget.equipment.location,
                                controller: _locationController,
                              ),
                              _buildInfoRow(
                                icon: Icons.category_outlined,
                                title: 'Category',
                                value: widget.equipment.category,
                                controller: _categoryController,
                        ),
                              _buildInfoRow(
                                icon: Icons.description_outlined,
                                title: 'Description',
                                value: widget.equipment.description,
                                controller: _descriptionController,
                                isMultiLine: true,
                  ),
                              _buildInfoRow(
                                icon: Icons.handyman_outlined,
                                title: 'Condition',
                                value: widget.equipment.condition ?? 'Not specified',
                                controller: _conditionController,
                              ),
                              _buildInfoRow(
                                icon: Icons.featured_play_list_outlined,
                                title: 'Features',
                                value: widget.equipment.features ?? 'Not specified',
                          controller: _featuresController,
                                isMultiLine: true,
                        ),
                              _buildInfoRow(
                                icon: Icons.local_shipping_outlined,
                                title: 'Delivery Mode',
                                value: widget.equipment.deliveryMode ?? 'Not specified',
                          controller: _deliveryModeController,
                              ),
                            ],

                            SizedBox(height: 32),

                            // Action Buttons
                  if (_isEditing)
                              Container(
                      width: double.infinity,
                      child: ElevatedButton(
                                  onPressed: _saveChanges,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Palette.red,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                          child: Text(
                                    'Save Changes',
                            style: TextStyle(
                                      fontSize: 16,
                                fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                            if (!_isEditing)
                              Container(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: _deletePosting,
                                  icon: Icon(Icons.delete_outline),
                                  label: Text('Delete Listing'),
                          style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red[50],
                                    foregroundColor: Colors.red,
                                    padding: EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 0,
                                  ),
                            ),
                              ),
                          ],
                        ),
                      ),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
    required TextEditingController controller,
    bool isMultiLine = false,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, size: 18, color: Colors.grey[700]),
                SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12),
          _isEditing
              ? TextFormField(
                  controller: controller,
                  decoration: _buildInputDecoration('Enter $title'),
                  maxLines: isMultiLine ? 3 : 1,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    height: 1.5,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildImageDisplay(List<String>? images) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (images != null && images.isNotEmpty)
            Image.network(
              images.first,
              fit: BoxFit.cover,
            )
          else
            Container(
              color: Colors.grey[200],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.image_not_supported_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                'No images available',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.3),
                  Colors.black.withOpacity(0.6),
                ],
              ),
              ),
          ),
        ],
            ),
    );
  }
}
