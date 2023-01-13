import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:rick_and_morty_episodes_display/pages/locations_page.dart';

import '../graphql_client_mock.dart';

void main() {
  late MockGraphQLClient mockGraphQLClient;
  late Widget charactersPageWidget;

  setUp(() {
    mockGraphQLClient = getMockGraphQLClient();
    charactersPageWidget = GraphQLProvider(
      client: ValueNotifier(mockGraphQLClient),
      child: const MaterialApp(
        home: LocationsPage(),
      ),
    );
  });

  group('locations_page', () {
    testWidgets('Page shows exception when query result has exception',
        ((widgetTester) async {
      final result = generateMockObservableQuery(mockGraphQLClient);
      when(result.hasException).thenReturn(true);

      await widgetTester.pumpWidget(charactersPageWidget);

      expect(find.text('There was an issue loading this page'), findsOneWidget);
    }));
    testWidgets(
        'Page shows circular progress indicator when query result is loading',
        ((widgetTester) async {
      final result = generateMockObservableQuery(mockGraphQLClient);
      when(result.hasException).thenReturn(false);
      when(result.isLoading).thenReturn(true);

      await widgetTester.pumpWidget(charactersPageWidget);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    }));
    testWidgets('Page shows content when query result is correct',
        ((widgetTester) async {
      final result = generateMockObservableQuery(mockGraphQLClient);
      when(result.hasException).thenReturn(false);
      when(result.isLoading).thenReturn(false);
      when(result.data).thenReturn({
        "locations": {
          "info": {
            "count": 1,
            "next": 2,
            "prev": null,
          },
          "results": [
            {
              "id": "1",
              "name": "name",
              "type": "type",
            },
          ]
        }
      });
      await widgetTester.pumpWidget(charactersPageWidget);

      expect(find.byType(ListTile), findsWidgets);
    }));
  });
}
