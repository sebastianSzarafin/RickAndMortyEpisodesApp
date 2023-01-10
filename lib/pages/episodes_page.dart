import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/pages/episode_page.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/rm_circullarprogressindicator.dart';
import 'package:rick_and_morty_episodes_display/utils/rm_scaffold.dart';

class EpisodesPage extends HookWidget {
  const EpisodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final readEpisodesCount = useQuery(QueryOptions(
      document: gql(allEpisodesGraphQL),
    ));
    final result = readEpisodesCount.result;
    var resultList = tryGetEpisodesCount(result);
    if (!resultList[0]) return resultList[1];
    final episodesCount = resultList[1];

    return RMScaffold(
      getList: () {
        return SliverList(
            delegate: SliverChildListDelegate([
          for (var i = 0; i < episodesCount; i++) EpisodeItem(index: i)
        ]));
      },
    );
  }
}

class EpisodeItem extends StatelessWidget {
  const EpisodeItem({
    Key? key,
    required this.index,
  }) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Query(
        options: QueryOptions(
            document: gql(singleEpisodeGraphQL), variables: {'id': index + 1}),
        builder: ((result, {fetchMore, refetch}) {
          if (result.hasException) {
            return const Text('There was an issue loading this episode');
          }

          if (result.isLoading) {
            return Container();
          }

          String title =
              'Episode ${result.data?['episode']?['id']}: ${result.data?['episode']?['name']}';
          return ListTile(
            title: Text(
              title,
              style: const TextStyle(overflow: TextOverflow.ellipsis),
            ),
            subtitle: Text(result.data?['episode']?['episode']),
            trailing: const Icon(Icons.arrow_forward),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EpisodePage(id: index + 1, title: title),
              ));
            },
          );
        }),
      ),
    );
  }
}

List tryGetEpisodesCount(result) {
  if (result.hasException) {
    return [
      false,
      const Text('There was an issue loading this page'),
    ];
  }

  if (result.isLoading) {
    return [
      false,
      Scaffold(
        appBar: AppBar(
          title: const Text('Rick & Morty Episodes App'),
        ),
        body: const Center(
          child: RMCircullarProgressIndicator(),
        ),
      ),
    ];
  }

  return [
    true,
    result.data?['episodes']?['info']?['count'],
  ];
}
