import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/functions/inner_page_parameter.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_circullarprogressindicator.dart';

class CharacterPage extends HookWidget {
  const CharacterPage({
    super.key,
    required this.id,
    required this.name,
    required this.image,
  });

  final int id;
  final String name;
  final String image;

  Future<void> _onPressed(BuildContext context, List<dynamic> episodeData) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.background,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      builder: (BuildContext context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(8.0, 4.0, 0, 0),
              child: Text(
                'All episodes in which this character appeared',
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView.builder(
                itemBuilder: ((BuildContext context, int index) {
                  return EpisodeItem(
                    index: index,
                    id: episodeData[index]['id'],
                    name: episodeData[index]['name'],
                    episode: episodeData[index]['episode'],
                  );
                }),
                itemCount: episodeData.length,
              ),
            )
          ],
        );
      },
    );
  }

  Widget _getBody(QueryResult<Object?> result, BuildContext context) {
    final character = result.data?['character'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                color: Theme.of(context).cardColor,
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      height: MediaQuery.of(context).size.width / 2,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(image), fit: BoxFit.cover),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    const SizedBox(height: 25),
                    getParameter(data: character, p: "id", fontSize: 15),
                    getParameter(data: character, p: "name", fontSize: 15),
                    getParameter(data: character, p: "status", fontSize: 15),
                    getParameter(data: character, p: "species", fontSize: 15),
                    getParameter(data: character, p: "gender", fontSize: 15),
                    getParameter(
                        data: character['origin'],
                        p: "name",
                        def: 'Origin location',
                        fontSize: 15),
                    getParameter(
                        data: character['location'],
                        p: "name",
                        def: 'Last known location',
                        fontSize: 15),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            TextButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).cardColor),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ))),
              child: const SizedBox(
                height: 30,
                child: Center(
                    child: Text('Check out where this character appeared!')),
              ),
              onPressed: () => _onPressed(context, character['episode']),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(singleCharacterGraphQL),
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
          variables: {'id': id},
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return const Text('There was an issue loading this page');
          }

          if (result.isLoading) {
            return const Center(
              child: RMCircullarProgressIndicator(),
            );
          }

          return _getBody(result, context);
        },
      ),
    );
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

  final int index;
  final String id;
  final String name;
  final String episode;

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
      ),
    );
  }
}
