// category_card.dart

import 'package:flutter/material.dart';

class EquipmentCategoryCard extends StatelessWidget {
  final String title;
  final String iconUrl;

  EquipmentCategoryCard({required this.title, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
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
              title,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
