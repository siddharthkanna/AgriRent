import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/components/EquipmentListCard.dart';
import 'package:agrirent/constants/cardListLoading.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';

class EquipmentListScreen extends StatelessWidget {
  final String categoryTitle;
  final String displayTitle;

  const EquipmentListScreen(
      {required this.categoryTitle, required this.displayTitle, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Palette.white),
        backgroundColor: Palette.red,
        title: Text(
          displayTitle,
          style: const TextStyle(
              color: Palette.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<Equipment>>(
        future: EquipmentApi.getAllEquipmentData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SkeletonCardList(itemCount: 5);
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Text('Error loading equipment data');
          } else {
            List<Equipment> allEquipment = snapshot.data!;
            List<Equipment> filteredEquipment = allEquipment
                .where((equipment) =>
                    equipment.category == categoryTitle &&
                    equipment.isAvailable == true)
                .toList();

            if (filteredEquipment.isEmpty) {
              return const Center(
                child: Text(
                  'Oops!No equipment found in this category.',
                  style: TextStyle(fontWeight: FontWeight.normal),
                ),
              );
            }

            return ListView.builder(
              itemCount: filteredEquipment.length,
              itemBuilder: (context, index) {
                final equipment = filteredEquipment[index];
                return EquipmentListCard(equipment: equipment);
              },
            );
          }
        },
      ),
    );
  }
}
