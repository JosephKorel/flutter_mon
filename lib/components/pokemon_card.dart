import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pokemon_list/helper/utils.dart';
import 'package:pokemon_list/models/pokemon.dart';
import 'package:pokemon_list/pages/pokemon_details.dart';

class PokemonCard extends StatelessWidget {
  const PokemonCard({
    super.key,
    required this.pokemon,
  });

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) {
    void seePokemonDetails() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PokemonPage(pokemon: pokemon),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              SizedBox(
                  width: double.infinity, child: loadImage(pokemon.avatar)),
              SizedBox(
                width: double.infinity,
                child: InkWell(
                  onTap: seePokemonDetails,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
                      child: Container(
                        color: Theme.of(context)
                            .colorScheme
                            .onSurface
                            .withOpacity(0.1),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8.0,
                            vertical: 2.0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                capitalizeFirst(pokemon.name),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              IconButton(
                                onPressed: () {},
                                icon: Icon(Icons.chevron_right),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
