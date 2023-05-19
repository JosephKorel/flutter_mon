import 'package:flutter/material.dart';

@immutable
class Pokemon {
  final String name;
  final String avatar;

  const Pokemon({required this.name, required this.avatar});
}
