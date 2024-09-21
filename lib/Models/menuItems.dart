import 'package:flutter/material.dart';

import 'menuItem.dart';

class MenuItems {
  static const itemProfile = DropMenuItem(
      text: "Evalyevaly@gmail.com", icon: Icons.person_outline_outlined);

  static const itemSignOut = DropMenuItem(text: "Sign Out", icon: Icons.logout);

  static const List<DropMenuItem> itemsFirst = [
    itemProfile,
    itemSignOut,
  ];
}
