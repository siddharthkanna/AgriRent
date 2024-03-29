import 'package:agrirent/models/EquipmentCategory.model.dart';
import 'package:agrirent/providers/language_provider.dart';
import 'package:agrirent/screens/categoryList.dart';
import 'package:agrirent/screens/search.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MarketScreen extends ConsumerStatefulWidget {
  const MarketScreen({Key? key}) : super(key: key);

  @override
  _MarketScreenState createState() => _MarketScreenState();
}

class _MarketScreenState extends ConsumerState<MarketScreen> {
  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(selectedLocaleProvider);
    final appLoc = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Padding(
          padding: const EdgeInsets.only(left: 8, top: 8),
          child: Text(
            appLoc.marketPlace,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(14.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Column(
                children: [
                  OpenContainer(
                    openBuilder: (context, _) => const SearchScreen(),
                    closedBuilder: (_, VoidCallback openContainer) {
                      return Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                            border:
                                Border.all(color: Colors.black26, width: 1.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.3),
                                spreadRadius: 1,
                                blurRadius: 4,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: TextField(
                            enabled: false,
                            onTap: openContainer,
                            decoration: InputDecoration(
                              hintText: appLoc.searchForEquipment,
                              prefixIcon:
                                  const Icon(Icons.search, color: Colors.black),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.all(16.0),
                            ),
                          ),
                        ),
                      );
                    },
                    closedElevation: 0,
                    closedColor: Palette.white,
                    openElevation: 4,
                    transitionDuration: const Duration(milliseconds: 500),
                    tappable: true,
                    closedShape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                  ),
                  const SizedBox(height: 20.0), // Spacer
                  _buildCategoriesGrid(constraints.maxWidth),
                  const SizedBox(height: 50.0),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriesGrid(double screenWidth) {
    int crossAxisCount = screenWidth > 600 ? 3 : 2;
    double crossAxisSpacing = screenWidth > 600 ? 24.0 : 16.0;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: crossAxisSpacing,
      mainAxisSpacing: 16.0,
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      children: MarketCategories.getMarketCategories(context).map((category) {
        return categoryItem(category.localName, category.iconUrl,
            category.englishName, context);
      }).toList(),
    );
  }

  // Modify the categoryItem widget to include a gesture detector for clicking
  Widget categoryItem(String categoryName, String iconUrl, String englishName,
      BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToCategoryScreen(categoryName, englishName, context);
      },
      child: Card(
        elevation: 2.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        color: const Color(0xFFF5A9A9),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.black87, width: 1.0),
                ),
                child: Image.asset(
                  iconUrl,
                  width: 35.0,
                  height: 35.0,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                categoryName,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToCategoryScreen(
      String categoryName, String englishName, BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EquipmentListScreen(
          categoryTitle: englishName,
          displayTitle: categoryName,
        ),
      ),
    );
  }
}
