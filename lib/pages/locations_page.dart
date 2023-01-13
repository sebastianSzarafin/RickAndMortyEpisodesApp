import 'package:flutter/material.dart';
import 'package:rick_and_morty_episodes_display/enums/rm_page_enum.dart';
import 'package:rick_and_morty_episodes_display/inner_pages/location_page.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_page.dart';

class LocationsPage extends StatelessWidget {
  const LocationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RMPage(
        pageEnum: PageEnum.locations,
        query: allLocationsGraphQL,
        params: const ['id', 'name', 'type'],
        buildItem: (({
          index = 0,
          required p1,
          required p2,
          required p3,
        }) =>
            LocationItem(id: p1, name: p2, type: p3)));
  }
}

class LocationItem extends StatelessWidget {
  const LocationItem({
    Key? key,
    required this.id,
    required this.name,
    required this.type,
  }) : super(key: key);

  final String id;
  final String name;
  final String type;

  @override
  Widget build(BuildContext context) {
    String title = 'Name: $name';
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
        subtitle: Text(type),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LocationPage(
              id: int.parse(id),
              name: name,
            ),
          ));
        },
      ),
    );
  }
}
