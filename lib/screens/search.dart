import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchTextController = TextEditingController();

  late Future<List<Equipment>> _equipmentData;
  List<Equipment> _searchResults = [];

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(() {
      _updateSearchResults(_searchTextController.text);
    });
  }

  Future<void> _updateSearchResults(String query) async {
    try {
      if (query.isEmpty) {
        // If the query is empty, reset the search results
        setState(() {
          _searchResults = [];
        });
        return;
      }

      final List<Equipment> equipmentList =
          await EquipmentApi.getAllEquipmentData();
      final List<Equipment> filteredResults = equipmentList
          .where((equipment) =>
              equipment.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _searchResults = filteredResults;
      });
    } catch (error) {
      print('Error updating search results: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: TextField(
          controller: _searchTextController,
          decoration: const InputDecoration(
            hintText: 'Search equipment',
            border: InputBorder.none,
            hintStyle: TextStyle(color: Colors.grey),
          ),
        ),
      ),
      body: _searchResults.isEmpty
          ? const Center(
              child: Text('No search results found.'),
            )
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final Equipment equipment = _searchResults[index];
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: Colors.white,
                  ),
                  child: Container(
                    padding:const EdgeInsets.all(16),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 150,
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image:
                                  NetworkImage(equipment.images?.first ?? ''),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 30),
                        // Right Half: Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                equipment.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                equipment.category,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Price: \$${equipment.rentalPrice}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Palette.red,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Location: ${equipment.location}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
