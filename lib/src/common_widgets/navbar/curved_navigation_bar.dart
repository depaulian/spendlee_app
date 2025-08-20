import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/src/constants/image_strings.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:expense_tracker/src/constants/colors.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final ValueChanged<int> onTap;
  final bool isDark;

  const CustomBottomNavigationBar({
    required this.selectedIndex,
    required this.isDark,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      buttonBackgroundColor: tPrimaryColor,
      color: tPrimaryColor,
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      items:  <Widget>[
        Image(image: AssetImage(tLogo), height: 30),
        Icon(Icons.shopping_bag, size: 26, color: Colors.white),
        Icon(Icons.pin_drop, size: 26, color: Colors.white),
        Icon(Icons.settings, size: 26, color: Colors.white),
      ],
      onTap: onTap,
      index: selectedIndex, // Set the current index
    );
  }
}