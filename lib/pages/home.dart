import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_list/components/pokemon_card.dart';
import 'package:pokemon_list/helper/utils.dart';
import 'package:pokemon_list/models/pokemon.dart';

const _baseUrl = "https://pokeapi.co/api/v2/pokemon?limit=5";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Pokemon>> _pokemons;

  Future<List<Pokemon>> _fetchPokemons() async {
    List<Pokemon> fetchedPokemons = [];

    try {
      final request = await http.get(Uri.parse(_baseUrl));
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

      return fetchedPokemons;
    } catch (e) {
      showSnackBar(context, 'Error while fetching pokemons');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _pokemons = _fetchPokemons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterMon'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder(
          future: _pokemons,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return const Text('Error while fetching pokemons');
            } else if (!snapshot.hasData) {
              return const Text('No Pokemon was found');
            }
            final pokemonList = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 52.0),
              child: ListView.builder(
                itemCount: pokemonList.length,
                itemBuilder: (_, index) {
                  final pokemonList = snapshot.data!;
                  final pokemon = pokemonList[index];
                  return PokemonCard(pokemon: pokemon);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
