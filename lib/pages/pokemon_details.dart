import 'package:flutter/material.dart';
import 'package:pokemon_list/models/details.dart';

class PokemonPage extends StatelessWidget {
  const PokemonPage({super.key, required this.pokemon});

  final PokemonDetail pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon.name),
      ),
    );
  }
}
