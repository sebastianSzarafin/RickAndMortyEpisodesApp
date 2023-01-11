import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/rm_circullarprogressindicator.dart';

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

  Widget _getBody(QueryResult<Object?> result, BuildContext context) {
    final character = result.data?['character'];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              color: Theme.of(context).cardColor),
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
                    borderRadius: const BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                const SizedBox(height: 25),
                Parameter(character: character, p: "name", def: "Name"),
                Parameter(character: character, p: "status", def: "Status"),
                Parameter(character: character, p: "species", def: "Species"),
                Parameter(character: character, p: "gender", def: "Gender"),
                Parameter(
                  character: character['origin'],
                  p: "name",
                  def: 'Origin location',
                ),
                Parameter(
                  character: character['location'],
                  p: "name",
                  def: 'Last known location',
                ),
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
        title: Text(name),
      ),
      body: Query(
        options: QueryOptions(
          document: gql(singleCharacterGraphQL),
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
    required this.character,
    required this.p,
    required this.def,
  });

  final Map<String, dynamic>? character;
  final String p;
  final String def;

  @override
  Widget build(BuildContext context) {
    TextStyle parameterStyle = const TextStyle(
      overflow: TextOverflow.ellipsis,
      fontSize: 15,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: Text(
              '$def:',
              style: parameterStyle,
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(character?[p],
                textAlign: TextAlign.right, style: parameterStyle),
          )
        ],
      ),
    );
  }
}
