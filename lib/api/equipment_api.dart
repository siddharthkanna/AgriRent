import 'dart:convert';
import 'package:agrirent/config/dio.dart';
import 'package:agrirent/config/url.dart';
import 'package:agrirent/constants/snackBar.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/screens/postScreen/success.dart';
import 'package:agrirent/screens/profileScreen.dart';
import 'package:agrirent/config/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class EquipmentApi {
  static Future<void> postEquipmentData(
      List<String> imageUrls, Equipment equipment, BuildContext context) async {
    try {
      print("Starting postEquipmentData...");
      print("Received imageUrls: $imageUrls");
      print("Received equipment: ${equipment.toJson()}");

      equipment.images = imageUrls;
      String jsonData = json.encode(equipment.toJson());
      print("Encoded JSON data: $jsonData");
      print("Posting to URL: $addEquipmentUrl");

      final response = await dio.post(addEquipmentUrl, data: jsonData);
      print("Post response status: ${response.statusCode}");
      print("Post response data: ${response.data}");

      print("Navigating to success screen...");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SuccessScreenPosting(),
        ),
      );
      print("Navigation complete");
    } catch (error) {
      print("Error posting equipment data: $error");
      print("Error stack trace: ${StackTrace.current}");
      // Handle error as needed
    }
  }

  static Future<List<Equipment>> getAvailableEquipment() async {
    try {
      final response = await dio.get(getAvailableEquipmentUrl);

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;

        final currentUser = SupabaseConfig.currentUser;
        final currentUserID = currentUser?.id;

        List<Equipment> equipmentList = jsonData
            .map((json) => Equipment.fromJson(json))
            .where((equipment) => equipment.ownerId != currentUserID)
            .toList();

        return equipmentList;
      } else {
        throw Exception(
            'Failed to load equipment data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      rethrow;
    }
  }

  static Future<List<Equipment>> fetchRentalHistory() async {
    print('Fetching rental history...');
    try {
      print('Making GET request to: $rentalHistoryUrl');
      final response = await dio.get(rentalHistoryUrl);

      print('Response status code: ${response.statusCode}');
      if (response.statusCode == 200) {
        print('Successfully got response');
        List<dynamic> jsonData = response.data;
        print('Response data: $jsonData');

        List<Equipment> rentalHistoryList =
            jsonData.map((json) => Equipment.fromJson(json)).toList();
        print('Parsed ${rentalHistoryList.length} equipment items');

        return rentalHistoryList;
      } else {
        // Handle error
        print('Request failed with status: ${response.statusCode}');
        throw Exception(
            'Failed to load rental history data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle Dio errors or other exceptions
      print('Error getting rental history data: $error');
      print('Error stack trace: ${error.toString()}');
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
            builder: (context) => const SuccessScreenRent(),
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

  static Future<void> createEquipment(BuildContext context, Equipment equipment) async {
    try {
      final session = SupabaseConfig.supabase.auth.currentSession;
      if (session == null) {
        throw Exception('Authentication required');
      }

      final response = await dio.post(
        equipmentUrl,
        data: {
          ...equipment.toJson(),
          'owner_id': session.user.id,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer ${session.accessToken}',
          },
        ),
      );

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw Exception('Failed to create equipment: ${response.statusMessage}');
      }
    } catch (e) {
      print('Error creating equipment: $e');
      throw Exception('Failed to create equipment: $e');
    }
  }
}
