import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/enums/rm_page_enum.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_circullarprogressindicator.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_scaffold.dart';

class RMPage extends StatefulHookWidget {
  const RMPage({
    Key? key,
    required this.pageEnum,
    required this.query,
    required this.params,
    required this.buildItem,
  }) : super(key: key);

  final PageEnum pageEnum;
  final String query;
  final List<String> params;
  final Widget Function({
    required String p1,
    required String p2,
    required String p3,
    int index,
  }) buildItem;

  @override
  State<RMPage> createState() => _RMPage();
}

class _RMPage extends State<RMPage> {
  bool _isFetchingMore = false;

  _getFetchMoreOptions(int page, String pageString) {
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
          ...previousResultData[pageString]['results'],
          ...fetchMoreResultData[pageString]['results'],
        ];

        previousResultData[pageString]['results'] = results;

        previousResultData[pageString]['info'] =
            fetchMoreResultData[pageString]['info'];
        return previousResultData;
      },
    );
  }

  _fetchMore(fetchMore, page, pageString) async {
    await fetchMore?.call(
      _getFetchMoreOptions(page, pageString),
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
    final String pageString = getPageString(widget.pageEnum);
    final length = result.data?[pageString]?['results']?.length;
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            'All ${pageString[0].toUpperCase()}${pageString.substring(1)}',
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

                final itemData = result.data?[pageString]['results'][index];

                return widget.buildItem(
                  p1: itemData[widget.params[0]],
                  p2: itemData[widget.params[1]],
                  p3: itemData[widget.params[2]],
                  index: index,
                );
              },
              itemCount: _isFetchingMore ? length + 1 : length,
            ),
            onNotification: (notification) {
              if (notification.metrics.axis != Axis.vertical) {
                return true;
              }

              if (result.data?[pageString]?['info']?['next'] == null) {
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
                    result.data?[pageString]?['info']?['prev'] == null
                        ? 2
                        : result.data?[pageString]?['info']?['next'] == null
                            ? (result.data?[pageString]?['info']?['prev'])
                            : (result.data?[pageString]?['info']?['next']);

                _fetchMore(fetchMore, nextPage, pageString);
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
          document: gql(widget.query),
          fetchPolicy: FetchPolicy.cacheAndNetwork,
          cacheRereadPolicy: CacheRereadPolicy.mergeOptimistic,
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
