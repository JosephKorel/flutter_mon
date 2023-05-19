import 'package:flutter/material.dart';

@immutable
class PokemonDetail {
  final String name;
  final String avatar;
  final int id;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;

  const PokemonDetail({
    required this.name,
    required this.avatar,
    required this.id,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
  });

  factory PokemonDetail.fromJson(dynamic json) {
    Map<String, dynamic> sprites = json['sprites'];
    List<Map<String, dynamic>> typeList = json['types'];
    List<Map<String, dynamic>> abilitiesList = json['abilities'];
    String name = json['name'];
    String avatar = sprites['other']['official-artwork']['front_shiny'];
    int id = json['id'];
    int height = json['height'];
    int weight = json['weight'];
    List<String> types =
        typeList.map((e) => e['type']['name']).toList() as List<String>;
    List<String> abilities =
        abilitiesList.map((e) => e['ability']['name']).toList() as List<String>;

    return PokemonDetail(
        name: name,
        avatar: avatar,
        id: id,
        height: height,
        weight: weight,
        types: types,
        abilities: abilities);
  }
}
