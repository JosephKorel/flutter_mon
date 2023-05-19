import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokemon_list/pages/home.dart';

void main() {
  CachedNetworkImage.logLevel = CacheManagerLogLevel.debug;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Mon',
      theme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
