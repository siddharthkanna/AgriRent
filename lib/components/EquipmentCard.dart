import 'package:agrirent/models/equipment.model.dart'; // Assuming Equipment model is defined
import 'package:agrirent/screens/productDetail.dart'; // Assuming ProductDetailsPage is defined
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:animations/animations.dart';

class EquipmentCard extends StatelessWidget {
  final Equipment equipment;

  EquipmentCard({required this.equipment});

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      closedElevation: 0,
      closedColor: Palette.white,
      closedBuilder: (context, openContainer) {
        return InkWell(
          onTap: openContainer,
          child: Container(
            width: 200,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(15),
                      ),
                      child: Image.network(
                        equipment.images?.first ?? '',
                        width: double.infinity,
                        height: 88,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            equipment.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '${equipment.features}',
                            style: const TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
      openBuilder: (context, _) {
        return ProductDetailsPage(equipment: equipment);
      },
      transitionType: ContainerTransitionType.fadeThrough,
    );
  }
}
