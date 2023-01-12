import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_circullarprogressindicator.dart';

class EpisodePage extends HookWidget {
  const EpisodePage({
    super.key,
    required this.id,
    required this.title,
  });

  final int id;
  final String title;

  Widget _getBody(QueryResult<Object?> result, BuildContext context) {
    final characterList = result.data?['episode']?['characters'];

    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 250, mainAxisExtent: 250),
      itemCount: characterList.length,
      itemBuilder: (_, index) => Padding(
        padding: const EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).cardColor),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Container(
                  width: 125,
                  height: 125,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(characterList[index]["image"]),
                        fit: BoxFit.cover),
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(height: 25),
                Parameter(
                    characterList: characterList, index: index, p: "name"),
                Parameter(
                    characterList: characterList, index: index, p: "species"),
                Parameter(
                    characterList: characterList, index: index, p: "gender"),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(singleEpisodeCharactersGraphQl),
          fetchPolicy: FetchPolicy.noCache,
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

class Parameter extends StatelessWidget {
  const Parameter({
    super.key,
    required this.characterList,
    required this.index,
    required this.p,
  });

  final characterList;
  final int index;
  final String p;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          flex: 4,
          child: Text('${p[0].toUpperCase()}${p.substring(1)}:'),
        ),
        Expanded(
          flex: 6,
          child: Text(
            characterList[index][p],
            textAlign: TextAlign.right,
            style: const TextStyle(overflow: TextOverflow.ellipsis),
          ),
        )
      ],
    );
  }
}
