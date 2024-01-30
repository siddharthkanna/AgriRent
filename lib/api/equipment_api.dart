import 'dart:convert';
import 'package:agrirent/config/dio.dart';
import 'package:agrirent/config/url.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/screens/postScreen/success.dart';
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
          builder: (context) => SuccessScreen(),
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
        List<Equipment> equipmentList =
            jsonData.map((json) => Equipment.fromJson(json)).toList();

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
}
