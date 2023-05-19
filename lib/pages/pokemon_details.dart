import 'package:flutter/material.dart';
import 'package:pokemon_list/helper/utils.dart';
import 'package:pokemon_list/models/pokemon.dart';

class PokemonPage extends StatelessWidget {
  const PokemonPage({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Image(
              image: NetworkImage(pokemon.avatar),
            ),
            Text(
              capitalizeFirst(pokemon.name),
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .copyWith(letterSpacing: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
