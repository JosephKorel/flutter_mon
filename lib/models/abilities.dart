import 'package:flutter/material.dart';

@immutable
class Ability {
  final String name;
  final String description;

  const Ability({required this.name, required this.description});

  factory Ability.fromJson(String name, dynamic json) {
    List<dynamic> effectList = json['effect_entries'];
    Map<String, dynamic> enEffect = effectList
        .where((element) => element['language']['name'] == 'en')
        .single;

    final description = enEffect['short_effect'];

    return Ability(name: name, description: description);
  }
}
