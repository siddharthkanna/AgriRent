import 'package:agrirent/api/equipment_api.dart';
import 'package:agrirent/components/EquipmentListCard.dart';
import 'package:agrirent/models/equipment.model.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> with SingleTickerProviderStateMixin {
  final _searchTextController = TextEditingController();
  List<Equipment> _searchResults = [];
  bool _isTyping = false;
  bool _isLoading = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _searchTextController.addListener(() {
      setState(() {
        _isTyping = _searchTextController.text.isNotEmpty;
      });
      if (_isTyping) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
      _updateSearchResults(_searchTextController.text);
    });
  }

  @override
  void dispose() {
    _searchTextController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _updateSearchResults(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _isLoading = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final List<Equipment> equipmentList = await EquipmentApi.getAvailableEquipment();
      final List<Equipment> filteredResults = equipmentList
          .where((equipment) =>
              equipment.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        _searchResults = filteredResults;
        _isLoading = false;
      });
    } catch (error) {
      print('Error updating search results: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_rounded, size: 18),
            onPressed: () => Navigator.pop(context),
            color: Colors.black87,
          ),
          titleSpacing: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey[200]!),
              ),
              child: TextField(
                controller: _searchTextController,
                autofocus: true,
                textAlignVertical: TextAlignVertical.center,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: appLoc.searchForEquipment,
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 8),
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Icon(
                          Icons.search_rounded,
                          color: Color.lerp(Colors.grey[400], Palette.red, _animation.value),
                          size: 22,
                        );
                      },
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  suffixIcon: _isTyping
                    ? Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: IconButton(
                          icon: const Icon(Icons.close_rounded, size: 18),
                          onPressed: () {
                            _searchTextController.clear();
                            setState(() {
                              _isTyping = false;
                            });
                          },
                          color: Colors.grey[400],
                        ),
                      )
                    : null,
                  suffixIconConstraints: const BoxConstraints(
                    minWidth: 40,
                    minHeight: 40,
                  ),
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _buildBody(appLoc),
      ),
    );
  }

  Widget _buildBody(AppLocalizations appLoc) {
    if (_isLoading) {
      return const Center(
        child: SizedBox(
          width: 30,
          height: 30,
          child: CircularProgressIndicator(
            color: Palette.red,
            strokeWidth: 2.5,
          ),
        ),
      );
    }

    if (_searchResults.isEmpty) {
      return _buildEmptyState(appLoc);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      itemCount: _searchResults.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        final Equipment equipment = _searchResults[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: EquipmentListCard(equipment: equipment),
        );
      },
    );
  }

  Widget _buildEmptyState(AppLocalizations appLoc) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Icon(
                _isTyping ? Icons.search_off_rounded : Icons.search_rounded,
                size: 70,
                color: Color.lerp(Colors.grey[300], Colors.grey[400], _animation.value),
              );
            },
          ),
          const SizedBox(height: 20),
          Text(
            _isTyping ? appLoc.noSearchResultsFound : appLoc.searchForEquipment,
            style: TextStyle(
              fontSize: 17,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
              letterSpacing: -0.3,
            ),
          ),
          if (_isTyping) ...[
            const SizedBox(height: 8),
            Text(
              'Try different keywords or filters',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[400],
                height: 1.5,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
