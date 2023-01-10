import 'package:flutter/material.dart';
import 'package:rick_and_morty_episodes_display/pages/characters_page.dart';
import 'package:rick_and_morty_episodes_display/pages/episodes_page.dart';
import 'package:rick_and_morty_episodes_display/pages/locations_page.dart';
import 'package:rick_and_morty_episodes_display/utils/rm_navigationbar.dart';
import 'package:rick_and_morty_episodes_display/utils/rm_navigationdrawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final ValueNotifier<int> pageIndex = ValueNotifier(1);

  final pages = const [
    CharactersPage(),
    EpisodesPage(),
    LocationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: pageIndex,
        builder: (BuildContext context, int value, _) {
          return pages[value];
        },
      ),
      bottomNavigationBar: RMBottomNavigationBar(
        onItemSelected: (index) {
          pageIndex.value = index;
        },
      ),
      drawer: const RMNavigationDrawer(),
    );
  }
}
