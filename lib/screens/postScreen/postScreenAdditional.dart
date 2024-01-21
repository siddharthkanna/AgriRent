// ignore_for_file: file_names
import 'dart:io';
import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/components/textField.dart';
import 'package:agrirent/config/image_upload.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AdditionalDetailsScreen extends ConsumerStatefulWidget {
  final List<File> imageFiles;
  final Equipment equipment;

  const AdditionalDetailsScreen({
    Key? key,
    required this.imageFiles,
    required this.equipment,
  }) : super(key: key);

  @override
  _AdditionalDetailsScreenState createState() =>
      _AdditionalDetailsScreenState();
}

class _AdditionalDetailsScreenState
    extends ConsumerState<AdditionalDetailsScreen> {
  DateTime? _startDate;
  DateTime? _endDate;
  final TextEditingController _featuresController = TextEditingController();
  final TextEditingController _conditionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Additional Details',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              WidgetUtils.textField('Features', _featuresController),
              const SizedBox(height: 20.0),
              WidgetUtils.textField('Condition', _conditionController),
              const SizedBox(height: 20.0),
              dateRangePicker('Availability Dates'),
              Spacer(),
              postButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget dateRangePicker(String label) {
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
        InkWell(
          onTap: _selectDateRange,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _startDate != null && _endDate != null
                        ? '${_formatDate(_startDate!)} to ${_formatDate(_endDate!)}'
                        : 'Select Dates',
                    style: const TextStyle(color: Colors.black),
                  ),
                  const Icon(Icons.calendar_today, color: Colors.black),
                ],
              ),
            ),
          ),
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
    );

    if (pickedDateRange != null) {
      setState(() {
        _startDate = pickedDateRange.start;
        _endDate = pickedDateRange.end;
      });
    }
  }

  Widget postButton() {
    return ElevatedButton(
      onPressed: () {
        // Implement post functionality here
        _postEquipment();
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
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _postEquipment() async {
    try {
      List<String> imageUrls =
          await ImageUploadFirebase.uploadImages(widget.imageFiles);

      // Retrieve the current user ID
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
        print("User not authenticated");
        return;
      }

      Equipment equipment = Equipment(
        name: widget.equipment.name,
        category: widget.equipment.category,
        description: widget.equipment.description,
        rentalPrice: widget.equipment.rentalPrice,
        location: widget.equipment.location,
        features: _featuresController.text,
        condition: _conditionController.text,
        availabilityDates: _generateDateList(_startDate, _endDate),
        images: imageUrls,
        ownerId: userId,
      );

      await EquipmentApi.postEquipmentData(imageUrls, equipment, context);
    } catch (error) {
      print("Error posting equipment: $error");
    }
  }

  List<String>? _generateDateList(DateTime? startDate, DateTime? endDate) {
    if (startDate != null && endDate != null) {
      List<String> dateList = [];
      for (DateTime date = startDate;
          date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
          date = date.add(const Duration(days: 1))) {
        dateList.add(date.toIso8601String().substring(0, 10));
      }
      return dateList;
    } else {
      return null;
    }
  }
}
