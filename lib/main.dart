import 'package:flutter/material.dart';
import 'package:rick_and_morty_episodes_display/pages/episodes_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: EpisodesPage(),
    );
  }
}
