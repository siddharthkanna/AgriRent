import 'package:agrirent/components/navbar.dart';
import 'package:agrirent/screens/chat/InboxScreen.dart';
import 'package:agrirent/screens/homescreen.dart';
import 'package:agrirent/screens/marketScreen.dart';
import 'package:agrirent/screens/postScreen/postScreen.dart';
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
    if (index != _currentPage) {
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.fastOutSlowIn,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_currentPage == 0) {
          // If on the first page, exit the app
          return await showDialog<bool>(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Exit App'),
                    content:
                        const Text('Are you sure you want to exit the app?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              ) ??
              false;
        } else {
          _pageController.previousPage(
            duration: const Duration(milliseconds: 300),
            curve: Curves.fastOutSlowIn,
          );
          return false;
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: PageView(
              controller: _pageController,
              onPageChanged: _onPageChanged,
              children: const [
                KeepAlivePage(child: HomeScreen()),
                KeepAlivePage(child: MarketScreen()),
                KeepAlivePage(child: PostScreen()),
                KeepAlivePage(child: InboxScreen()),
                KeepAlivePage(child: ProfileScreen()),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Navbar(
          selectedIndex: _currentPage,
          onTabTapped: _onNavItemTapped,
        ),
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
