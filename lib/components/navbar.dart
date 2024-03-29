import 'package:flutter/material.dart';
import 'package:awesome_bottom_bar/awesome_bottom_bar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Navbar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTabTapped;

  Navbar({
    required this.selectedIndex,
    required this.onTabTapped,
  });

  @override
  Widget build(BuildContext context) {
    final appLoc = AppLocalizations.of(context)!;

    List<TabItem> items = [
      TabItem(
        icon: Icons.home,
        title: appLoc.home,
      ),
      TabItem(
        icon: Icons.search_sharp,
        title: appLoc.rent,
      ),
      TabItem(
        icon: Icons.add_circle_rounded,
        title: appLoc.post,
      ),
      TabItem(
        icon: Icons.chat_bubble_sharp,
        title: appLoc.chat,
      ),
      TabItem(
        icon: Icons.person_outline,
        title: appLoc.profile,
      ),
    ];

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
