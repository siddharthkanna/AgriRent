// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:io';
import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/constants/snackBar.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/screens/postScreen/success.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:agrirent/services/storage_service.dart';

class PostScreenAdditional extends ConsumerStatefulWidget {
  final Equipment equipment;
  final List<File> imageFiles;

  const PostScreenAdditional({
    Key? key,
    required this.equipment,
    required this.imageFiles,
  }) : super(key: key);

  @override
  ConsumerState<PostScreenAdditional> createState() => _PostScreenAdditionalState();
}

class _PostScreenAdditionalState extends ConsumerState<PostScreenAdditional> {
  DateTime? _startDate;
  DateTime? _endDate;

  final TextEditingController _featuresController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();
  final TextEditingController _deliveryModeController = TextEditingController();
  String? _selectedDeliveryMode;

  late Future<void> _postEquipmentFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _postEquipmentFuture = Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 6),
          child: Text(
            appLoc.additionalDetails,
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildDetailsSection(appLoc),
                const SizedBox(height: 32.0),
                _buildSubmitButton(appLoc.post),
                const SizedBox(height: 96.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(AppLocalizations appLoc) {
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
          _buildInputField(appLoc.features, _featuresController, maxLines: 3),
          const SizedBox(height: 24.0),
          _buildInputField(appLoc.condition, _conditionController, maxLines: 2),
          const SizedBox(height: 24.0),
          dateRangePicker(appLoc.availabilityDates),
          const SizedBox(height: 24.0),
          deliveryModeDropdown('Delivery Mode'),
        ],
      ),
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {int maxLines = 1}) {
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

  Widget dateRangePicker(String label) {
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
        InkWell(
          onTap: _selectDateRange,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, 
                  size: 20, 
                  color: Colors.grey[600]
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _startDate != null && _endDate != null
                        ? '${_formatDate(_startDate!)} to ${_formatDate(_endDate!)}'
                        : appLoc.selectDates,
                    style: TextStyle(
                      color: _startDate != null ? Colors.black87 : Colors.grey[600],
                      fontSize: 14,
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget deliveryModeDropdown(String label) {
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
          value: _selectedDeliveryMode ?? 'Renter Pickup',
          items: ['Renter Pickup', 'Owner Delivery', 'Both']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _selectedDeliveryMode = value!;
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
          icon: Icon(Icons.arrow_drop_down, color: Colors.grey[600]),
          isExpanded: true,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDateRange() async {
    DateTimeRange? pickedDateRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Palette.red,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black87,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
      });
    }
  }

  Widget _buildSubmitButton(String label) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submitEquipment,
      style: ElevatedButton.styleFrom(
        backgroundColor: Palette.red,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
      ),
      child: Text(
        _isLoading ? 'Creating Listing...' : label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _submitEquipment() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Palette.red),
            ),
          );
        },
      );

      final List<String> imageUrls = await StorageService.uploadImages(widget.imageFiles);

      final updatedEquipment = widget.equipment.copyWith(
        condition: _conditionController.text,
        features: _featuresController.text,
        deliveryMode: _selectedDeliveryMode ?? 'Renter Pickup',
        images: imageUrls,
      );

      await EquipmentApi.createEquipment(context, updatedEquipment);

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessScreenPosting(),
        ),
      );
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      print('Error submitting equipment: $e');
      CustomSnackBar.showError(
        context, 
        'Failed to create listing. Please try again.',
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
