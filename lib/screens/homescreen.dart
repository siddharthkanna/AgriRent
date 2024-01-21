import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/components/card.dart';
import 'package:agrirent/components/category_card.dart';
import 'package:agrirent/constants/skeletonLoading.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<Equipment>> equipmentData;

  @override
  void initState() {
    super.initState();
    equipmentData = EquipmentApi.getAllEquipmentData();
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider);
    final User? user = authNotifier.user;
    String dp = user?.photoURL ?? '';
    String name = user?.displayName ?? '';
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const SizedBox(height: 30),
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: NetworkImage(dp),
                  ),
                  const SizedBox(width: 14),
                  const Text(
                    'Welcome, ',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.grey[200],
                  border: Border.all(
                    color: Colors.black12,
                    width: 0.5,
                  ),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        // Implement search functionality here
                      },
                    ),
                    const Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search equipment',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.filter_list),
                      onPressed: () {
                        // Implement filter functionality here
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular Equipment',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Equipment>>(
                    future: equipmentData,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return SkeletonLoading(itemCount: 3);
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return Text('Error loading equipment data');
                      } else {
                        List<Equipment> equipmentList = snapshot.data!;
                        return SizedBox(
                          height: 150,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: equipmentList.length,
                            itemBuilder: (context, index) {
                              final equipment = equipmentList[index];
                              return EquipmentCard(
                                name: equipment.name,
                                rating:
                                    '4.5', // Replace with actual rating from equipment data
                                imageUrl: equipment.images?.first ?? '',
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Equipment Categories',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        EquipmentCategoryCard(
                          title: 'Tractors',
                          iconUrl:
                              'https://cdn-icons-png.flaticon.com/512/6678/6678123.png',
                        ),
                        const SizedBox(width: 5),
                        EquipmentCategoryCard(
                          title: 'Harvesters',
                          iconUrl:
                              'https://cdn-icons-png.flaticon.com/512/9236/9236346.png',
                        ),
                        const SizedBox(width: 5),
                        EquipmentCategoryCard(
                          title: 'Plows',
                          iconUrl:
                              'https://cdn-icons-png.flaticon.com/512/6678/6678111.png',
                        ),
                        const SizedBox(width: 20),
                      ],
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
