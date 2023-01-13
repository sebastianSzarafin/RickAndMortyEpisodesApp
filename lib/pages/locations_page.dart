import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/inner_pages/episode_page.dart';
import 'package:rick_and_morty_episodes_display/inner_pages/location_page.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_circullarprogressindicator.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_scaffold.dart';

class LocationsPage extends StatefulHookWidget {
  const LocationsPage({super.key});

  @override
  State<LocationsPage> createState() => _LocationsPageState();
}

class _LocationsPageState extends State<LocationsPage> {
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
          ...previousResultData['locations']['results'],
          ...fetchMoreResultData['locations']['results'],
        ];

        previousResultData['locations']['results'] = results;

        previousResultData['locations']['info'] =
            fetchMoreResultData['locations']['info'];
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
    final length = result.data?['locations']?['results']?.length;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'All Locations',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        Expanded(
          child: NotificationListener<ScrollNotification>(
            child: ListView.builder(
              itemBuilder: (context, index) {
                if (_isFetchingMore == true && index == length) {
                  return const Center(child: RMCircullarProgressIndicator());
                }

                final locationsData =
                    result.data?['locations']['results'][index];

                return LocationItem(
                  id: locationsData['id'],
                  name: locationsData['name'],
                  type: locationsData['type'],
                );
              },
              itemCount: _isFetchingMore ? length + 1 : length,
            ),
            onNotification: (notification) {
              if (notification.metrics.axis != Axis.vertical) {
                return true;
              }

              if (result.data?['locations']?['info']?['next'] == null) {
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
                    result.data?['locations']?['info']?['prev'] == null
                        ? 2
                        : result.data?['locations']?['info']?['next'] == null
                            ? (result.data?['locations']?['info']?['prev'])
                            : (result.data?['locations']?['info']?['next']);

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
          document: gql(allLocationsGraphQL),
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

class LocationItem extends StatelessWidget {
  const LocationItem({
    Key? key,
    required this.id,
    required this.name,
    required this.type,
  }) : super(key: key);

  final String id;
  final String name;
  final String type;

  @override
  Widget build(BuildContext context) {
    String title = 'Name: $name';
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        ),
        subtitle: Text(type),
        trailing: const Icon(Icons.arrow_forward),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => LocationPage(
              id: int.parse(id),
              name: name,
            ),
          ));
        },
      ),
    );
  }
}
