import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

String capitalizeFirst(String word) {
  return word[0].toUpperCase() + word.substring(1);
}

double convertDecimeterToMeter(int decimeters) {
  return decimeters / 10;
}

double convertHectogramToKilogram(int hectograms) {
  return hectograms / 10;
}

void showSnackBar(BuildContext context, String message) {
  SnackBar snackBar = SnackBar(
    content: Text(message),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

CachedNetworkImage loadImage(String url) {
  return CachedNetworkImage(
    imageUrl: url,
    placeholder: (context, url) => Shimmer(
      child: const SizedBox(
        height: 80.0,
      ),
    ),
    errorWidget: (context, url, error) =>
        const Center(child: Icon(Icons.error)),
  );
}
