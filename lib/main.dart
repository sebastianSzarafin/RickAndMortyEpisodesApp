import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/pages/episode_page.dart';
import 'package:rick_and_morty_episodes_display/pages/episodes_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final client = getGraphQlClient();

  @override
  Widget build(BuildContext context) {
    return GraphQLProvider(
      client: client,
      child: const MaterialApp(
        home: EpisodesPage(),
        //home: EpisodePage(id: 1),
      ),
    );
  }
}

ValueNotifier<GraphQLClient> getGraphQlClient() {
  final HttpLink httpLink = HttpLink("https://rickandmortyapi.com/graphql");

  return ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(
          store: InMemoryStore()), //, typePolicies: {FetchPolicy.noCache}
    ),
  );
}
