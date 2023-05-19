import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:pokemon_list/components/pokemon_tab.dart';
import 'package:pokemon_list/models/abilities.dart';
import 'package:pokemon_list/helper/utils.dart';
import 'package:pokemon_list/models/pokemon.dart';
import 'package:http/http.dart' as http;

class PokemonPage extends StatefulWidget {
  const PokemonPage({super.key, required this.pokemon});

  final Pokemon pokemon;

  @override
  State<PokemonPage> createState() => _PokemonPageState();
}

class _PokemonPageState extends State<PokemonPage> {
  final List<Ability> abilities = [];

  Future<void> _fetchAbilities() async {
    final pokemon = widget.pokemon;

    List<Ability> pokemonAbilities = [];

    try {
      await Future.forEach(pokemon.abilities, (element) async {
        final abilityUrl = 'https://pokeapi.co/api/v2/ability/$element';

        final abilityRequest = await http.get(Uri.parse(abilityUrl));

        Map<String, dynamic> body = jsonDecode(abilityRequest.body);

        final ability = Ability.fromJson(element, body);

        pokemonAbilities.add(ability);
      });

      setState(() {
        abilities.addAll(pokemonAbilities);
      });
    } catch (e) {
      showSnackBar(context, 'Error while fetching pokemon abilities');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAbilities();
  }

  @override
  Widget build(BuildContext context) {
    final weight = convertHectogramToKilogram(widget.pokemon.weight);
    final height = convertDecimeterToMeter(widget.pokemon.height);

    final type =
        widget.pokemon.types.map((e) => capitalizeFirst(e)).toList().join(', ');

    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return const [
            SliverAppBar(
              pinned: true,
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                child: loadImage(widget.pokemon.avatar),
              ),
              DecoratedBox(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    '#${widget.pokemon.id}',
                    style: Theme.of(context).textTheme.titleMedium!.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                  ),
                ),
              ),
              Text(
                capitalizeFirst(widget.pokemon.name),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(letterSpacing: 1.4),
              ),
              Text(
                'Type: $type',
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.7)),
              ),
              const SizedBox(
                height: 6.0,
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            'ID: ',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            widget.pokemon.id.toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Weight: ',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '$weight kg',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            'Height: ',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            '$height m',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withOpacity(0.7),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: PokemonDetailTab(
                    stats: widget.pokemon.stats, abilities: abilities),
              )
            ],
          ),
        ),
      ),
    );
  }
}
