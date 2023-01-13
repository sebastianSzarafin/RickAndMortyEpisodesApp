import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/functions/inner_page_parameter.dart';
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
                getParameter(character: characterList[index], p: "name"),
                getParameter(character: characterList[index], p: "species"),
                getParameter(character: characterList[index], p: "gender"),
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
