import 'package:flutter/material.dart';
import 'package:rick_and_morty_episodes_display/enums/rm_page_enum.dart';
import 'package:rick_and_morty_episodes_display/inner_pages/character_page.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_page.dart';

class CharactersPage extends StatelessWidget {
  const CharactersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RMPage(
        pageEnum: PageEnum.characters,
        query: allCharactersGraphQL,
        params: const ['id', 'name', 'image'],
        buildItem: (({
          index = 0,
          required p1,
          required p2,
          required p3,
        }) =>
            CharacterItem(id: p1, name: p2, image: p3)));
  }
}

class CharacterItem extends StatelessWidget {
  const CharacterItem({
    Key? key,
    required this.id,
    required this.name,
    required this.image,
  }) : super(key: key);

  final String id;
  final String name;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(
          name,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
        subtitle: Text('ID: $id'),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(image),
        ),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) =>
                CharacterPage(id: int.parse(id), name: name, image: image),
          ));
        },
      ),
    );
  }
}
