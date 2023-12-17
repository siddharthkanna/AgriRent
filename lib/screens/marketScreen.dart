import 'package:flutter/material.dart';

class MarketScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Padding(
          padding: EdgeInsets.only(left: 8, top: 8),
          child: Text(
            'Market Place',
            style: TextStyle(
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
                  _buildSearchField(),
                  const SizedBox(height: 20.0), // Spacer
                  _buildCategoriesGrid(constraints.maxWidth),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: const TextField(
          decoration: InputDecoration(
            hintText: 'Search for equipment',
            prefixIcon: Icon(Icons.search, color: Colors.grey),
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16.0),
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
      children: [
        _buildCategoryItem('Category 1', Icons.category),
        _buildCategoryItem('Category 2', Icons.category),
        _buildCategoryItem('Category 3', Icons.category),
        _buildCategoryItem('Category 4', Icons.category),
        _buildCategoryItem('Category 5', Icons.category),
        _buildCategoryItem('Category 6', Icons.category),
      ],
    );
  }

  Widget _buildCategoryItem(String categoryName, IconData iconData) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      color: const Color(0xFFF5A9A9), // Background color
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.black87, width: 1.0),
              ),
              child: Icon(iconData, size: 35.0, color: Colors.black87),
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
    );
  }
}
