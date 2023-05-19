import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pokemon_list/models/abilities.dart';
import 'package:pokemon_list/models/stats.dart';
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
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
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
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                capitalizeFirst(widget.pokemon.name),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium!
                    .copyWith(letterSpacing: 1.4),
              ),
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
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
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
                          'Peso: ',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '$weight kg',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
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
                          'Altura: ',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '$height m',
                          style:
                              Theme.of(context).textTheme.titleMedium!.copyWith(
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
            PokemonDetailTab(
              stats: widget.pokemon.stats,
              abilities: abilities,
            ),
          ],
        ),
      ),
    );
  }
}

class PokemonDetailTab extends StatefulWidget {
  const PokemonDetailTab(
      {super.key, required this.stats, required this.abilities});

  final List<Stats> stats;
  final List<Ability> abilities;

  @override
  State<PokemonDetailTab> createState() => _PokemonDetailTabState();
}

class _PokemonDetailTabState extends State<PokemonDetailTab>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final stats = widget.stats;
    final abilities = widget.abilities;

    List<Widget> pokemonStats = stats
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  capitalizeFirst(e.name),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  e.value.toString(),
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        )
        .toList();

    List<Widget> pokemonAbilities = abilities
        .map(
          (e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              children: [
                Text(
                  capitalizeFirst(e.name),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  e.description,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.7),
                      ),
                ),
              ],
            ),
          ),
        )
        .toList();

    return Expanded(
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const <Widget>[
              Tab(
                text: 'Stats',
              ),
              Tab(
                text: 'Abilities',
              ),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12.0),
                  child: Column(
                    children: pokemonStats,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 12.0),
                  child: Column(
                    children: pokemonAbilities,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
