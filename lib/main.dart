import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:rick_and_morty_episodes_display/screens/home_screen.dart';
import 'package:rick_and_morty_episodes_display/themes/theme.dart';

void main() {
  runApp(MyApp(appTheme: AppTheme()));
}

class MyApp extends StatelessWidget {
  MyApp({super.key, required this.appTheme});

  final AppTheme appTheme;
  final client = getGraphQlClient();

  @override
  Widget build(BuildContext context) {
    setWindowMinSize(context);
    return ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      builder: (context, _) {
        final themeProvider = Provider.of<ThemeProvider>(context);

        return GraphQLProvider(
          client: client,
          child: MaterialApp(
            theme: appTheme.light,
            darkTheme: appTheme.dark,
            themeMode: themeProvider.themeMode,
            home: HomeScreen(),
          ),
        );
      },
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
