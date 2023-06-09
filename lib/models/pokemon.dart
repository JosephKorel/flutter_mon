import 'package:flutter/material.dart';
import 'package:pokemon_list/models/stats.dart';

@immutable
class Pokemon {
  final String name;
  final String avatar;
  final int id;
  final int height;
  final int weight;
  final List<Stats> stats;
  final List<String> types;
  final List<String> abilities;

  const Pokemon({
    required this.name,
    required this.avatar,
    required this.id,
    required this.height,
    required this.weight,
    required this.stats,
    required this.types,
    required this.abilities,
  });

  // Trata os dados recebidos da API
  factory Pokemon.fromJson(dynamic json) {
    Map<String, dynamic> sprites = json['sprites'];
    List<dynamic> statsList = json['stats'];
    List<dynamic> typeList = json['types'];
    List<dynamic> abilitiesList = json['abilities'];
    String name = json['name'];
    String avatar = sprites['other']['official-artwork']['front_shiny'];
    int id = json['id'];
    int height = json['height'];
    int weight = json['weight'];
    List<Stats> stats = statsList
        .map((e) => Stats(name: e['stat']['name'], value: e['base_stat']))
        .toList();
    List<dynamic> typeNames = typeList.map((e) => e['type']['name']).toList();
    List<dynamic> abilitieNames =
        abilitiesList.map((e) => e['ability']['name']).toList();

    List<String> types = typeNames.map((e) => e.toString()).toList();

    List<String> abilities = abilitieNames.map((e) => e.toString()).toList();

    return Pokemon(
      name: name,
      avatar: avatar,
      id: id,
      height: height,
      weight: weight,
      stats: stats,
      types: types,
      abilities: abilities,
    );
  }
}
