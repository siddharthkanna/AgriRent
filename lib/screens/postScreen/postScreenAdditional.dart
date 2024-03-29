// ignore_for_file: file_names, use_build_context_synchronously
import 'dart:io';
import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/components/textField.dart';
import 'package:agrirent/config/image_upload.dart';
import 'package:agrirent/constants/loading.dart';
import 'package:agrirent/constants/snackBar.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/screens/postScreen/success.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String? _selectedDeliveryMode;

  late Future<void> _postEquipmentFuture;

  @override
  void initState() {
    super.initState();
    _postEquipmentFuture = Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appLoc.additionalDetails,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      WidgetUtils.textField(
                          appLoc.features, _featuresController),
                      const SizedBox(height: 20.0),
                      WidgetUtils.textField(
                          appLoc.condition, _conditionController),
                      const SizedBox(height: 20.0),
                      dateRangePicker(appLoc.availabilityDates),
                      const SizedBox(height: 20.0),
                      deliveryModeDropdown(appLoc.ownerDelivery),
                      const SizedBox(height: 20.0),
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: postButton('Post'),
              ),
            ),
          ],
        ),
      ),
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
                        : appLoc.selectDates,
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

  Widget deliveryModeDropdown(String label) {
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
          value: _selectedDeliveryMode ?? appLoc.renterPickup,
          items: [appLoc.renterPickup, appLoc.ownerDelivery, appLoc.both]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (String? value) {
            setState(() {
              _selectedDeliveryMode = value!;
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

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _selectDateRange() async {
    final appLoc = AppLocalizations.of(context)!;

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

  Widget postButton(String label) {
    final appLoc = AppLocalizations.of(context)!;

    return ElevatedButton(
      onPressed: () {
        // Trigger posting equipment details
        _postEquipment();
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        padding: const EdgeInsets.all(16.0),
        backgroundColor: Palette.red,
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Future<void> _postEquipment() async {
    setState(() {
      // Reset the error if any, and set the loading state
      _postEquipmentFuture =
          _postEquipmentInternal().whenComplete(() => setState(() {}));
    });
  }

  Future<void> _postEquipmentInternal() async {
    try {
      // Show loading overlay
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Loading();
        },
      );

      List<String> imageUrls =
          await ImageUploadFirebase.uploadImages(widget.imageFiles);

      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null) {
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
        deliveryMode: _selectedDeliveryMode ?? 'Renter Pickup',
      );

      await EquipmentApi.postEquipmentData(imageUrls, equipment, context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SuccessScreen()),
      );
    } catch (error) {
      CustomSnackBar.showError(context, 'Error posting Equipment!');
      throw error;
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
