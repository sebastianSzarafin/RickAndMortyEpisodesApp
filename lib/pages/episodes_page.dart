import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/inner_pages/episode_page.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/rm_circullarprogressindicator.dart';
import 'package:rick_and_morty_episodes_display/utils/rm_scaffold.dart';

class EpisodesPage extends StatefulHookWidget {
  const EpisodesPage({super.key});

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
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
          ...previousResultData['episodes']['results'],
          ...fetchMoreResultData['episodes']['results'],
        ];

        previousResultData['episodes']['results'] = results;

        previousResultData['episodes']['info'] =
            fetchMoreResultData['episodes']['info'];
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
    final length = result.data?['episodes']?['results']?.length;
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

                final episodeData = result.data?['episodes']['results'][index];

                return EpisodeItem(
                  index: index,
                  id: episodeData['id'],
                  name: episodeData['name'],
                  episode: episodeData['episode'],
                );
              },
              itemCount: _isFetchingMore ? length + 1 : length,
            ),
            onNotification: (notification) {
              if (notification.metrics.axis != Axis.vertical) {
                return true;
              }

              if (result.data?['episodes']?['info']?['next'] == null) {
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
                    result.data?['episodes']?['info']?['prev'] == null
                        ? 2
                        : result.data?['episodes']?['info']?['next'] == null
                            ? (result.data?['episodes']?['info']?['prev'])
                            : (result.data?['episodes']?['info']?['next']);

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
          document: gql(allEpisodesGraphQL),
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
