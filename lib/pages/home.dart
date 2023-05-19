import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
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
        Map<String, dynamic> sprites = body['sprites'];
        final avatar = sprites['other']['official-artwork']['front_shiny'];
        final pokemon = Pokemon(name: element['name'], avatar: avatar);
        fetchedPokemons.add(pokemon);
      });

      return fetchedPokemons;
    } catch (e) {
      debugPrint(e.toString());
      debugPrint('Some error ocurred');
      throw e;
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
        title: const Text('Pokemons'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _fetchPokemons,
              child: const Text('Test'),
            ),
            FutureBuilder(
              future: _pokemons,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return const Text('No Pokemon was found');
                } else if (!snapshot.hasData) {
                  return const Text('No Pokemon was found');
                }
                final pokemonList = snapshot.data!;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 52.0),
                    child: ListView.builder(
                      itemCount: pokemonList.length,
                      itemBuilder: (_, index) {
                        final pokemonList = snapshot.data!;
                        final pokemon = pokemonList[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Stack(
                                alignment: Alignment.bottomCenter,
                                children: [
                                  SizedBox(
                                    width: double.infinity,
                                    child: Image(
                                      image: NetworkImage(pokemon.avatar),
                                    ),
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 10.0, sigmaY: 10.0),
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
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  capitalizeFirst(pokemon.name),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge,
                                                ),
                                                IconButton(
                                                  onPressed: () {},
                                                  icon:
                                                      Icon(Icons.chevron_right),
                                                ),
                                              ],
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
                      },
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
