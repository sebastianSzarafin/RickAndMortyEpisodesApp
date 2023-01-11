import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/inner_pages/character_page.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/rm_circullarprogressindicator.dart';
import 'package:rick_and_morty_episodes_display/utils/rm_scaffold.dart';

class CharactersPage extends StatefulHookWidget {
  const CharactersPage({super.key});

  @override
  State<CharactersPage> createState() => _CharactersPageState();
}

class _CharactersPageState extends State<CharactersPage> {
  bool _isFetchingMore = false;

  _getFetchMoreOptions(int page) {
    return FetchMoreOptions(
      variables: {'page': page},
      updateQuery: (
        Map<String, dynamic>? previousResultData,
        Map<String, dynamic>? fetchMoreResultData,
      ) {
        if (previousResultData == null || fetchMoreResultData == null) {
          return previousResultData;
        }

        final results = [
          ...previousResultData['characters']['results'],
          ...fetchMoreResultData['characters']['results'],
        ];

        previousResultData['characters']['results'] = results;

        previousResultData['characters']['info'] =
            fetchMoreResultData['characters']['info'];
        return previousResultData;
      },
    );
  }

  _fetchMore(fetchMore, page) async {
    await fetchMore?.call(
      _getFetchMoreOptions(page),
    );

    if (mounted) {
      setState(() {
        _isFetchingMore = false;
      });
    }
  }

  Widget _getBody(
    QueryResult<Object?> result,
    Future<QueryResult<Object?>> Function(FetchMoreOptions)? fetchMore,
    bool isFetchingMore,
  ) {
    final length = result.data?['characters']?['results']?.length;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: NotificationListener<ScrollNotification>(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (_isFetchingMore == true && index == length) {
                  return const Center(child: RMCircullarProgressIndicator());
                }

                final characterData =
                    result.data?['characters']['results'][index];

                return CharacterItem(
                  id: characterData['id'],
                  name: characterData['name'],
                  image: characterData['image'],
                );
              },
              itemCount: _isFetchingMore ? length + 1 : length,
            ),
            onNotification: (notification) {
              if (notification.metrics.axis != Axis.vertical) {
                return true;
              }

              if (result.data?['characters']?['info']?['next'] == null) {
                return true;
              }

              final pixels = notification.metrics.pixels;
              final maxPixels = notification.metrics.maxScrollExtent;
              if (!_isFetchingMore &&
                  !result.isLoading &&
                  pixels + 200 >= maxPixels) {
                setState(() {
                  _isFetchingMore = true;
                });

                final nextPage =
                    result.data?['characters']?['info']?['prev'] == null
                        ? 2
                        : result.data?['characters']?['info']?['next'] == null
                            ? (result.data?['characters']?['info']?['prev'])
                            : (result.data?['characters']?['info']?['next']);

                _fetchMore(fetchMore, nextPage);
              }

              return true;
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return RMScaffold(
      getBody: () => Query(
        options: QueryOptions(
          document: gql(allCharactersGraphQL),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.hasException) {
            return const Text('There was an issue loading this page');
          }

          if (result.isLoading && _isFetchingMore == false) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: RMCircullarProgressIndicator(),
                ),
              ],
            );
          }

          return _getBody(result, fetchMore, _isFetchingMore);
        },
      ),
    );
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
