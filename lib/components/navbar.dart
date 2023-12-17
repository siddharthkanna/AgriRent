import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;

  List<TabItem> items = const[
    TabItem(
      icon: Icons.home,
      title: 'Home',
    ),
    TabItem(
      icon: Icons.search_sharp,
      title: 'Market',
    ),
    TabItem(
      icon: Icons.add_circle_rounded,
      title: 'Post',
    ),
    TabItem(
      icon: Icons.chat_bubble_sharp,
      title: 'Chat',
    ),
    TabItem(
      icon: Icons.person_outline,
      title: 'Profile',
    ),
  ];

  Navbar({
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          BottomBarInspiredFancy(
            items: items,
            backgroundColor: Colors.transparent,
            color: Colors.grey, 
            colorSelected: Colors.black,
            indexSelected: selectedIndex,
            onTap: onTabTapped,
            pad: 4,
            iconSize: 22,
            enableShadow: true,
          ),
        ],
      ),
    );
  }
}
