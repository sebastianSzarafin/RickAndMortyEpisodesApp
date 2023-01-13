import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';
import 'package:rick_and_morty_episodes_display/inner_pages/episode_page.dart';

import '../graphql_client_mock.dart';

void main() {
  late MockGraphQLClient mockGraphQLClient;
  late Widget episodePageWidget;

  setUp(() {
    mockGraphQLClient = getMockGraphQLClient();
    episodePageWidget = GraphQLProvider(
      client: ValueNotifier(mockGraphQLClient),
      child: const MaterialApp(
        home: EpisodePage(
          id: 1,
          title: 'title',
        ),
      ),
    );
  });

  group('episode_page', () {
    testWidgets('Page shows exception when query result has exception',
        ((widgetTester) async {
      final result = generateMockObservableQuery(mockGraphQLClient);
      when(result.hasException).thenReturn(true);

      await widgetTester.pumpWidget(episodePageWidget);

      expect(find.text('There was an issue loading this page'), findsOneWidget);
    }));
    testWidgets(
        'Page shows circular progress indicator when query result is loading',
        ((widgetTester) async {
      final result = generateMockObservableQuery(mockGraphQLClient);
      when(result.hasException).thenReturn(false);
      when(result.isLoading).thenReturn(true);

      await widgetTester.pumpWidget(episodePageWidget);

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    }));
    testWidgets('Page shows content when query result is correct',
        ((widgetTester) async {
      final result = generateMockObservableQuery(mockGraphQLClient);
      when(result.hasException).thenReturn(false);
      when(result.isLoading).thenReturn(false);
      when(result.data).thenReturn({
        "episode": {
          "characters": [
            {
              "name": "name",
              "species": "species",
              "gender": "gender",
              "image": "image"
            }
          ]
        }
      });

      await mockNetworkImagesFor(
        () => widgetTester.pumpWidget(episodePageWidget),
      );

      expect(find.text('name'), findsWidgets);
    }));
  });
}
