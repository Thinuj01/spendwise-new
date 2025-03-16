import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex; // Add this parameter
  final void Function(int)? onTabChange;

  const BottomNavBar({
    super.key,
    required this.currentIndex, // Pass the current index
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20),
      child: GNav(
        color: Colors.grey[400],
        activeColor: Colors.white,
        tabActiveBorder: Border.all(color: Color(0xFF272973)),
        tabBackgroundColor: Color(0xFF272973),
        mainAxisAlignment: MainAxisAlignment.center,
        tabBorderRadius: 16,
        selectedIndex: currentIndex, // Use the currentIndex here
        onTabChange: (value) => onTabChange!(value),
        tabs: const [
          GButton(
            icon: Icons.home,
            text: ' Home',
            textStyle: TextStyle(
                fontFamily: 'Jura',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          GButton(
            icon: Icons.bar_chart,
            text: ' Statistics',
            textStyle: TextStyle(
                fontFamily: 'Jura',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
          GButton(
            icon: Icons.history,
            text: ' Recents',
            textStyle: TextStyle(
                fontFamily: 'Jura',
                fontWeight: FontWeight.bold,
                color: Colors.white),
          ),
        ],
      ),
    );
  }
}
