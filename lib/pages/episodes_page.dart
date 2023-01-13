import 'package:flutter/material.dart';
import 'package:rick_and_morty_episodes_display/enums/rm_page_enum.dart';
import 'package:rick_and_morty_episodes_display/inner_pages/episode_page.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_page.dart';

class EpisodesPage extends StatelessWidget {
  const EpisodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RMPage(
        pageEnum: PageEnum.episodes,
        query: allEpisodesGraphQL,
        params: const ['id', 'name', 'episode'],
        buildItem: (({
          index = 0,
          required p1,
          required p2,
          required p3,
        }) =>
            EpisodeItem(index: index, id: p1, name: p2, episode: p3)));
  }
}

class EpisodeItem extends StatelessWidget {
  const EpisodeItem({
    Key? key,
    required this.id,
    required this.name,
    required this.episode,
    required this.index,
  }) : super(key: key);

  final String id;
  final String name;
  final String episode;
  final int index;

  @override
  Widget build(BuildContext context) {
    String title = 'Episode $id: $name';
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
        subtitle: Text(episode),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => EpisodePage(id: index + 1, title: title),
          ));
        },
      ),
    );
  }
}
