import 'package:agrirent/screens/categoryList.dart';
import 'package:flutter/material.dart';

class EquipmentCategoryCard extends StatelessWidget {
  final String title;
  final String displayTitle;
  final String iconUrl;

  EquipmentCategoryCard(
      {required this.title, required this.iconUrl, required this.displayTitle});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EquipmentListScreen(
              categoryTitle: title,
              displayTitle: displayTitle,
            ),
          ),
        );
      },
      child: Container(
        width: 100,
        margin: const EdgeInsets.symmetric(horizontal: 6),
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              Image.asset(
                iconUrl,
                width: 55,
                height: 55,
                fit: BoxFit.cover,
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                displayTitle,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
