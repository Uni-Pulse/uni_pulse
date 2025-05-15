import 'package:flutter/material.dart';
import 'package:uni_pulse/Screens/organizations/org_list_events.dart';
import 'package:uni_pulse/Screens/profile_screen.dart';
//import 'package:shop_app_flutter/cart_page.dart';
//import 'package:shop_app_flutter/product_list.dart';

// This is the home page for organisation users.
// It contains two main screens: one for listing and another for the profile page.
class OrgHomePage extends StatefulWidget {
  const OrgHomePage({super.key});

  @override
  State<OrgHomePage> createState() => _OrgHomePageState();
}

class _OrgHomePageState extends State<OrgHomePage> {
  // Holds the index of the currently selected bottom navigation item
  int currentPage = 0;

  // List of widgets representing the different screens the user can switch betwee
  List<Widget> pages = [OrgListEvents(), ProfileScreen()];

  /// Builds the UI of the home screen, including page switching and bottom navigation bar
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      // Displays the selected page based on currentPage index
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 35,
        selectedFontSize: 0,
        unselectedFontSize: 0,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        currentIndex: currentPage,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Events',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
//inherited widget is used for state management by the flutter framework whenever it wants to talk to the parent widget.
