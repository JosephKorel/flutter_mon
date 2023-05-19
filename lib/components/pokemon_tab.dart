import 'package:flutter/material.dart';
import 'package:pokemon_list/helper/utils.dart';
import 'package:pokemon_list/models/abilities.dart';
import 'package:pokemon_list/models/stats.dart';

List<Widget> pokemonAbilities(List<Ability> abilities, BuildContext context) {
  final abilityList = abilities
      .map(
        (e) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                capitalizeFirst(e.name),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(
                height: 4.0,
              ),
              Text(
                e.description,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
      )
      .toList();

  return abilityList;
}

List<Widget> pokemonStats(List<Stats> stats, BuildContext context) {
  final statsList = stats
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

  return statsList;
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

    return Column(
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
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: pokemonStats(stats, context),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12.0, vertical: 12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: pokemonAbilities(abilities, context),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
