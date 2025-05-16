// ignore_for_file: prefer_const_constructors

import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/pages/profile/RentingHistory/ProductDetail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:agrirent/providers/auth_provider.dart'; // Import your provider for authentication

class RentalHistoryPage extends ConsumerStatefulWidget {
  const RentalHistoryPage({Key? key}) : super(key: key);

  @override
  _RentalHistoryPageState createState() => _RentalHistoryPageState();
}

class _RentalHistoryPageState extends ConsumerState<RentalHistoryPage> {
  late Future<List<Equipment>> _equipmentHistoryFuture;

  @override
  void initState() {
    super.initState();
    _equipmentHistoryFuture = fetchEquipmentHistory();
  }

  Future<List<Equipment>> fetchEquipmentHistory() async {
    try {
      final equipmentHistory = await EquipmentApi.fetchRentalHistory();
      return equipmentHistory;
    } catch (e) {
      throw Exception('Failed to fetch equipment rental history: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Rental History',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: FutureBuilder<List<Equipment>>(
        future: _equipmentHistoryFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'No rental history available',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    'Looks like you haven\'t rented anything yet.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            );
          } else {
            final equipmentHistory = snapshot.data!;
            return ListView.builder(
              itemCount: equipmentHistory.length,
              itemBuilder: (context, index) {
                final equipment = equipmentHistory[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: EquipmentHistoryItem(
                    equipment: equipment,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class EquipmentHistoryItem extends StatelessWidget {
  final Equipment equipment;

  const EquipmentHistoryItem({
    required this.equipment,
  });

  @override
  Widget build(BuildContext context) {
    String returnDate = equipment.availabilityDates!.isNotEmpty
        ? equipment.availabilityDates!.last
        : 'N/A';

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ProductInfoPageRent(
              equipment: equipment,
            ),
          ),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the image
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                equipment.images!.isNotEmpty
                    ? equipment.images!.first
                    : '', // Use first image if available
                width: 100.0,
                height: 100.0,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    equipment.name,
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text('Rented: ${equipment.availabilityDates!.first}'),
                  SizedBox(height: 8.0),
                  Text('Returned: $returnDate'),
                  SizedBox(height: 8.0),
                  Text(
                    'Price: \$${equipment.rentalPrice}',
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
