import 'package:flutter/material.dart';

enum Ingredient {
  burger(Color(0xFFD32F2F), 'Burger', '🍔'),
  fries(Color(0xFFFBC02D), 'Fries', '🍟'),
  soda(Color(0xFFF57C00), 'Soda', '🥤'),
  pizza(Color(0xFFC62828), 'Pizza', '🍕'),
  hotdog(Color(0xFFE64A19), 'Hotdog', '🌭'),
  donut(Color(0xFFFFB300), 'Donut', '🍩');

  const Ingredient(this.color, this.name, this.emoji);
  final Color color;
  final String name;
  final String emoji;
}
