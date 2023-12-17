import 'package:agrirent/screens/chatScreen.dart';
import 'package:agrirent/screens/homescreen.dart';
import 'package:agrirent/components/navbar.dart';
import 'package:agrirent/screens/marketScreen.dart';
import 'package:agrirent/screens/postScreen.dart';
import 'package:agrirent/screens/profileScreen.dart';
import 'package:flutter/material.dart';

class PageViewScreen extends StatefulWidget {
  final int initialPage;
  const PageViewScreen({Key? key, this.initialPage = 0}) : super(key: key);

  @override
  State<PageViewScreen> createState() => _PageViewScreenState();
}

class _PageViewScreenState extends State<PageViewScreen> {
  PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _currentPage = widget.initialPage;
    _pageController = PageController(initialPage: widget.initialPage);
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onNavItemTapped(int index) {
    setState(() {
      _currentPage = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: PageView(
            controller: _pageController,
            onPageChanged: _onPageChanged,
            children: [
              KeepAlivePage(child: HomeScreen()),
              KeepAlivePage(child: MarketScreen()),
              KeepAlivePage(child: PostScreen()),
              KeepAlivePage(child: ChatScreen()),
              KeepAlivePage(child: ProfileScreen()),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Navbar(
        selectedIndex: _currentPage,
        onTabTapped: _onNavItemTapped,
      ),
    );
  }
}

class KeepAlivePage extends StatefulWidget {
  final Widget child;

  const KeepAlivePage({Key? key, required this.child}) : super(key: key);

  @override
  State<KeepAlivePage> createState() => _KeepAlivePageState();
}

class _KeepAlivePageState extends State<KeepAlivePage>
    with AutomaticKeepAliveClientMixin<KeepAlivePage> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}
