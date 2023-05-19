import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_list/components/pokemon_card.dart';
import 'package:pokemon_list/helper/utils.dart';
import 'package:pokemon_list/models/pokemon.dart';

const pageSize = 12;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _scrollController = ScrollController();
  final List<Pokemon> _pokemons = [];
  bool loading = false;
  int offset = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchPokemons() async {
    if (loading) {
      return;
    }

    setState(() {
      loading = true;
    });

    String baseUrl =
        'https://pokeapi.co/api/v2/pokemon?limit=$pageSize&offset=$offset';
    List<Pokemon> fetchedPokemons = [];

    try {
      final request = await http.get(Uri.parse(baseUrl));
      Map<String, dynamic> body = jsonDecode(request.body);
      List<dynamic> results = body['results'];

      await Future.forEach(results, (element) async {
        final pokemonUrl =
            'https://pokeapi.co/api/v2/pokemon/${element['name']}';

        final pokemonRequest = await http.get(Uri.parse(pokemonUrl));

        Map<String, dynamic> body = jsonDecode(pokemonRequest.body);

        final pokemon = Pokemon.fromJson(body);

        fetchedPokemons.add(pokemon);
      });

      offset += pageSize;

      setState(() {
        _pokemons.addAll(fetchedPokemons);
        loading = false;
      });
    } catch (e) {
      showSnackBar(context, 'Error while fetching pokemons');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterMon'),
        centerTitle: true,
      ),
      floatingActionButton: loading ? const CircularProgressIndicator() : null,
      body: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.atEdge && notification.metrics.pixels > 0) {
            _fetchPokemons();
          }
          return false;
        },
        child: Scrollbar(
          controller: _scrollController,
          child: GridView.builder(
            controller: _scrollController,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
            ),
            padding: const EdgeInsets.all(8.0),
            itemCount: _pokemons.length,
            itemBuilder: (_, index) {
              final pokemon = _pokemons[index];
              return PokemonCard(pokemon: pokemon);
            },
          ),
        ),
      ),
    );
  }
}
