import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_episodes_display/pages/episodes_page.dart';

import 'helper.dart';

void main() {
  late MockGraphQLClient mockGraphQLClient;

  setUp(() {
    mockGraphQLClient = generateMockGraphQLClient();
  });

  Widget _buildTestScaffold() {
    return GraphQLProvider(
      client: ValueNotifier(mockGraphQLClient),
      child: const MaterialApp(
        home: EpisodesPage(),
      ),
    );
  }

  group('episodes_page', () {
    testWidgets('Page shows exception when query result has exception',
        ((widgetTester) async {
      final result = generateMockWatchQuery(mockGraphQLClient);
      when(() => result.hasException).thenReturn(true);

      await widgetTester.pumpWidget(_buildTestScaffold());

      expect(find.text('There was an issue loading this page'), findsOneWidget);
    }));
    testWidgets(
        'Page shows circular progress indicator when query result is loading',
        ((widgetTester) async {
      final result = generateMockWatchQuery(mockGraphQLClient);
      when(() => result.hasException).thenReturn(false);
      when(() => result.isLoading).thenReturn(true);

      await widgetTester.pumpWidget(_buildTestScaffold());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    }));
    testWidgets('Page shows content when query result is correct',
        ((widgetTester) async {
      final result = generateMockWatchQuery(mockGraphQLClient);
      when(() => result.hasException).thenReturn(false);
      when(() => result.isLoading).thenReturn(false);
      when(() => result.data).thenReturn({
        "episodes": {
          "info": {
            "count": 1,
          }
        },
        "episode": {
          "id": "1",
          "name": "Pilot",
          "episode": "S01E01",
        }
      });

      await widgetTester.pumpWidget(_buildTestScaffold());

      expect(find.byType(ListTile), findsWidgets);
    }));
  });
}
