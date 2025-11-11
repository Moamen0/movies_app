import 'package:flutter/material.dart';
import 'package:movies_app/ui/home_tab/home_tab.dart';
import 'package:movies_app/ui/search_tab/search_tab.dart';
import 'package:movies_app/utils/app_assets.dart';

import '../browse_tab/borwse_tab.dart';
import '../profile_tab/profile_tab.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<Widget> tabsList = [HomeTab(), ProfileTab(), BrowseTab(), SearchTab()];

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      bottomNavigationBar: Container(
        margin: EdgeInsets.symmetric(
          horizontal: width*0.04,
          vertical: height*0.03,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: BottomNavigationBar(
            currentIndex: selectedIndex,
            onTap: (index) {
              selectedIndex = index;
              setState(() {
              });
            },
              selectedFontSize: 0,
              unselectedFontSize: 0,
            items: [
              builtBottomNavItem(
                index: 0,
                unSelectedIconName: AppAssets.unSelectedIconHome,
                selectedIconName: AppAssets.selectedIconHome,
              ),
              builtBottomNavItem(
                index: 1,
                unSelectedIconName: AppAssets.unSelectedIconSearch,
                selectedIconName: AppAssets.selectedIconSearch,
              ),
              builtBottomNavItem(
                index: 2,
                unSelectedIconName: AppAssets.unSelectedIconBrowser,
                selectedIconName: AppAssets.selectedIconBrowser,
              ),
              builtBottomNavItem(
                index: 3,
                unSelectedIconName: AppAssets.unSelectedIconProfile,
                selectedIconName: AppAssets.selectedIconProfile,
              ),
          
            ]
          ),
        ),
      ),
      body: tabsList[selectedIndex],
    );
  }
  BottomNavigationBarItem builtBottomNavItem({
    required String selectedIconName,
    required String unSelectedIconName,
    required int index,
  }) {
    return BottomNavigationBarItem(
      icon: ImageIcon(
        AssetImage(
          selectedIndex == index ? selectedIconName : unSelectedIconName,
        ),
      ),
      label: ''
    );
  }
}
