import 'package:flutter/material.dart';

class SettingItemModel {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SettingItemModel({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
