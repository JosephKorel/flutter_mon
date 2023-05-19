import 'package:flutter/material.dart';
import 'package:pokemon_list/models/pokemon.dart';

@immutable
class Details {
  final Pokemon pokemon;
  final int id;
  final int height;
  final int weight;
  final String type;
  final String hability;

  const Details({
    required this.pokemon,
    required this.id,
    required this.height,
    required this.weight,
    required this.type,
    required this.hability,
  });
}
