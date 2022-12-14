import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/pages/episodes_page.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final client = getGraphQlClient();

  @override
  Widget build(BuildContext context) {
    setWindowMinSize(context);
    return GraphQLProvider(
      client: client,
      child: const MaterialApp(
        home: EpisodesPage(),
      ),
    );
  }
}

ValueNotifier<GraphQLClient> getGraphQlClient() {
  final HttpLink httpLink = HttpLink("https://rickandmortyapi.com/graphql");

  return ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    ),
  );
}

Future setWindowMinSize(context) async {
  var platform = Theme.of(context).platform;
  if (!kIsWeb && !(platform == TargetPlatform.iOS)) {
    await DesktopWindow.setMinWindowSize(const Size(400, 400));
  }
}
