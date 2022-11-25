import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/pages/episode_page.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';

class EpisodesPage extends HookWidget {
  const EpisodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final readEpisodesCount = useQuery(QueryOptions(
      document: gql(allEpisodesGraphQL),
    ));

    final result = readEpisodesCount.result;

    if (result.hasException) {
      return Text(result.exception.toString());
    }

    if (result.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rick & Morty Episodes App'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final episodesCount = result.data?['episodes']?['info']?['count'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick & Morty Episodes App'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          const Text(
            'All episodes',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
              itemCount: episodesCount,
              itemBuilder: ((context, index) => Card(
                    child: Query(
                      options: QueryOptions(
                          document: gql(singleEpisodeGraphQL),
                          variables: {'id': index + 1}),
                      builder: ((result, {fetchMore, refetch}) {
                        if (result.hasException) {
                          return Text(result.exception.toString());
                        }

                        if (result.isLoading) {
                          return Container();
                        }

                        String title =
                            'Episode ${result.data?['episode']?['id']}: ${result.data?['episode']?['name']}';
                        return ListTile(
                          title: Text(
                            title,
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                          subtitle: Text(result.data?['episode']?['episode']),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  EpisodePage(id: index + 1, title: title),
                            ));
                          },
                        );
                      }),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
