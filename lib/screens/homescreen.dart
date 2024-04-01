import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/components/EquipmentCard.dart';
import 'package:agrirent/components/category_card.dart';
import 'package:agrirent/constants/cardLoading.dart';
import 'package:agrirent/models/EquipmentCategory.model.dart';
import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/providers/language_provider.dart';
import 'package:agrirent/screens/postScreen/postScreen.dart';
import 'package:agrirent/screens/search.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:animations/animations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  late Future<List<Equipment>> equipmentData;

  @override
  void initState() {
    super.initState();
    equipmentData = _fetchAvailableEquipment();
  }

  Future<List<Equipment>> _fetchAvailableEquipment() async {
    try {
      final List<Equipment> allEquipment =
          await EquipmentApi.getAllEquipmentData();
      final List<Equipment> availableEquipment =
          allEquipment.where((equipment) => equipment.isAvailable).toList();
      return availableEquipment;
    } catch (error) {
      print('Error fetching available equipment: $error');
      throw error;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authNotifier = ref.read(authProvider);
    final User? user = authNotifier.user;
    String dp = user?.photoURL ?? '';
    String name = user?.displayName ?? '';
    final locale = ref.watch(selectedLocaleProvider);
    final appLoc = AppLocalizations.of(context)!;

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
                  Text(
                    appLoc.welcome,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    name.split(" ")[0],
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
                              decoration: InputDecoration(
                                hintText: appLoc.searchForEquipment,
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
              child: FutureBuilder<List<Equipment>>(
                future: equipmentData,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SkeletonLoading(itemCount: 3);
                  } else if (snapshot.hasError || !snapshot.hasData) {
                    return const Text('Error loading equipment data');
                  } else {
                    List<Equipment> equipmentList = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          appLoc.popularEquipment,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
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
                        ),
                        const SizedBox(height: 20),
                        Text(
                          appLoc.equipmentCategories,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children:
                                EquipmentCategories.getEquipmentCategories(
                                        context)
                                    .map((category) {
                              return EquipmentCategoryCard(
                                displayTitle: category.localTitle,
                                title: category.englishTitle,
                                iconUrl: category.iconUrl,
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 25),
                        rentEquipmentSection(context),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget rentEquipmentSection(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Have an Equipment?',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black, // Text color
          ),
        ),
        const SizedBox(width: 25),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const  PostScreen(),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Palette.red, // Text color
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), // Decrease border radius
            ),
          ),
          child: const Text(
            'Post here',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Text color
            ),
          ),
        ),
      ],
    );
  }
}
