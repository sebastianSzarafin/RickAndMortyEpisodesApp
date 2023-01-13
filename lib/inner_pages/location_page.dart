import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/inner_pages/episode_page.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';
import 'package:rick_and_morty_episodes_display/utils/functions/inner_page_parameter.dart';
import 'package:rick_and_morty_episodes_display/utils/widgets/rm_circullarprogressindicator.dart';

class LocationPage extends HookWidget {
  const LocationPage({
    super.key,
    required this.id,
    required this.name,
  });

  final int id;
  final String name;

  Future<void> _onPressed(BuildContext context, List<dynamic> residentsData) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Theme.of(context).backgroundColor,
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
                'All location\'s residents',
              ),
            ),
            const Divider(),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 250, mainAxisExtent: 250),
                itemCount: residentsData.length,
                itemBuilder: (_, index) {
                  final characterData = residentsData[index];

                  return EpisodeItem(characterData: characterData);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _getBody(QueryResult<Object?> result, BuildContext context) {
    final location = result.data?['location'];

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
                    getParameter(data: location, p: "id", fontSize: 15),
                    getParameter(data: location, p: "name", fontSize: 15),
                    getParameter(data: location, p: "type", fontSize: 15),
                    getParameter(data: location, p: "dimension", fontSize: 15),
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
                child: Center(child: Text('Check out all residents!')),
              ),
              onPressed: () => _onPressed(context, location['residents']),
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
          document: gql(singleLocationGraphQL),
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
