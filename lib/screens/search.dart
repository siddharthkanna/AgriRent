import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/components/EquipmentListCard.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchTextController = TextEditingController();
  List<Equipment> _searchResults = [];
  bool _isTyping = true;

  @override
  void initState() {
    super.initState();
    _searchTextController.addListener(() {
      setState(() {
        _isTyping = _searchTextController.text.isNotEmpty;
      });
      _updateSearchResults(_searchTextController.text);
    });
    // Fetch initial search results when the screen is opened
    _updateSearchResults('');
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
    final appLoc = AppLocalizations.of(context)!;
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: AppBar(
           
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            leadingWidth: 40,
            title: TextField(
              controller: _searchTextController,
              decoration:  InputDecoration(
                hintText: appLoc.searchForEquipment,
                prefixIcon: const Icon(
                  Icons.search,
                  color: Colors.black,
                  size: 24,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  borderSide: BorderSide(color: Colors.black),
                ),
                hintStyle: const TextStyle(
                  color: Colors.grey,
                  fontStyle: FontStyle.italic,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              ),
            ),
          ),
        ),
        body: _searchResults.isEmpty
            ? Center(
                child: Text(_isTyping
                    ? appLoc.noSearchResultsFound
                    : appLoc.searchForEquipment),
              )
            : ListView.separated(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final Equipment equipment = _searchResults[index];
                  return EquipmentListCard(equipment: equipment);
                },
                separatorBuilder: (context, index) {
                  return const Divider(
                    height: 0.5,
                    color: Colors.black26,
                    indent: 20,
                    endIndent: 20,
                  );
                },
              ),
      ),
    );
  }
}
