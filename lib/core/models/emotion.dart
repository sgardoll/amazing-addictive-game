import 'package:flutter/material.dart';

enum Emotion {
  anger(Color(0xFFE53935), 'Anger', '😠'),
  joy(Color(0xFFFDD835), 'Joy', '😊'),
  calm(Color(0xFF42A5F5), 'Calm', '😌'),
  love(Color(0xFFEC407A), 'Love', '😍'),
  hope(Color(0xFF66BB6A), 'Hope', '🌱'),
  wonder(Color(0xFFAB47BC), 'Wonder', '✨');

  const Emotion(this.color, this.name, this.emoji);
  final Color color;
  final String name;
  final String emoji;
}
