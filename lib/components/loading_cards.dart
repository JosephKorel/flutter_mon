import 'package:flutter/material.dart';

class LoadingCards extends StatefulWidget {
  const LoadingCards({super.key});

  @override
  State<LoadingCards> createState() => _LoadingCardsState();
}

class _LoadingCardsState extends State<LoadingCards> {
  final cards = List.generate(6, (index) => 1).toList();

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
      ),
      padding: const EdgeInsets.all(8.0),
      itemCount: cards.length,
      itemBuilder: (_, index) {
        return SizedBox(
          width: double.infinity,
          child: Card(),
        );
      },
    );
  }
}
