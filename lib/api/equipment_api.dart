import 'dart:convert';
import 'package:agrirent/config/dio.dart';
import 'package:agrirent/config/url.dart';
import 'package:agrirent/constants/snackBar.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/screens/postScreen/success.dart';
import 'package:agrirent/screens/profileScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EquipmentApi {
  static Future<void> postEquipmentData(
      List<String> imageUrls, Equipment equipment, BuildContext context) async {
    try {
      equipment.images = imageUrls;
      String jsonData = json.encode(equipment.toJson());
      await dio.post(addEquipmentUrl, data: jsonData);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessScreen(),
        ),
      );
    } catch (error) {
      print("Error posting equipment data: $error");
      // Handle error as needed
    }
  }

  static Future<List<Equipment>> getAllEquipmentData() async {
    try {
      final response = await dio.get(getEquipmentUrl);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;

        final currentUserID = FirebaseAuth.instance.currentUser?.uid;

        List<Equipment> equipmentList = jsonData
            .map((json) => Equipment.fromJson(json))
            .where((equipment) => equipment.ownerId != currentUserID)
            .toList();

        return equipmentList;
      } else {
        // Handle error
        throw Exception(
            'Failed to load equipment data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle Dio errors or other exceptions
      print('Error getting equipment data: $error');
      rethrow;
    }
  }

  static Future<List<Equipment>> fetchRentalHistory(String userId) async {
    try {
      final response = await dio.get(rentalHistoryUrl + userId);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;

        List<Equipment> rentalHistoryList =
            jsonData.map((json) => Equipment.fromJson(json)).toList();

        return rentalHistoryList;
      } else {
        // Handle error
        throw Exception(
            'Failed to load rental history data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle Dio errors or other exceptions
      print('Error getting rental history data: $error');
      rethrow;
    }
  }

  static Future<void> rentEquipment(
      String equipmentId, String renterId, BuildContext context) async {
    try {
      final Map<String, dynamic> requestData = {
        'equipmentId': equipmentId,
        'renterId': renterId,
      };

      final response = await dio.post(rentEquipmentUrl, data: requestData);

      if (response.statusCode == 200) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const SuccessScreen(),
          ),
        );
      } else {
        throw Exception(
            'Failed to rent equipment. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error renting equipment: $error');
      // Handle error as needed
    }
  }

  static Future<void> deleteEquipment(
      BuildContext context, String equipmentId) async {
    try {
      final response = await dio.delete('$deleteEquipmentUrl/$equipmentId');

      if (response.statusCode == 200) {
        CustomSnackBar.showError(context, 'Equipment deleted successfully!');
        // Navigate to profile screen after deletion
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const ProfileScreen(),
          ),
        );
      } else {
        throw Exception(
            'Failed to delete equipment. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error deleting equipment: $error');
      // Handle error as needed
    }
  }
}
