import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rick_and_morty_episodes_display/main.dart';
import 'package:rick_and_morty_episodes_display/pages/characters_page.dart';
import 'package:rick_and_morty_episodes_display/pages/episodes_page.dart';
import 'package:rick_and_morty_episodes_display/pages/locations_page.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_navigationbar.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_navigationdrawer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final pages = const [
    CharactersPage(),
    EpisodesPage(),
    LocationsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<RMPageController>(
      builder: (context, controller, child) {
        return Scaffold(
          body: ColorfulSafeArea(
            color: Theme.of(context).cardColor,
            child: pages[controller.index],
          ),
          bottomNavigationBar: RMBottomNavigationBar(
            onItemSelected: (index) {
              controller.setIndex(index);
            },
          ),
          drawer: const RMNavigationDrawer(),
        );
      },
    );
  }
}
