import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/components/EquipmentCard.dart';
import 'package:agrirent/components/category_card.dart';
import 'package:agrirent/constants/skeletonLoading.dart';
import 'package:agrirent/models/EquipmentCategory.model.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/screens/search.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:animations/animations.dart';
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
              child: OpenContainer(
                closedElevation: 0,
                closedColor: Palette.white,
                  transitionDuration: const Duration(milliseconds: 500),
                  openBuilder: (context, _) => const SearchScreen(),
                  closedBuilder: (context, VoidCallback openContainer) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
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
                            onPressed: openContainer,
                          ),
                          Expanded(
                            child: TextField(
                              enabled: false,
                              onTap: openContainer,
                              decoration: const InputDecoration(
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
                    );
                  }),
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
                        return const SkeletonLoading(itemCount: 3);
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return const Text('Error loading equipment data');
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
                                equipment: equipment,
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
                      children: equipmentCategories.map((category) {
                        return EquipmentCategoryCard(
                          title: category.title,
                          iconUrl: category.iconUrl,
                        );
                      }).toList(),
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
