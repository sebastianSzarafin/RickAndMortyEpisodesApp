import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rick_and_morty_episodes_display/pages/episodes_page.dart';

import 'helper.dart';

void main() {
  late MockGraphQLClient mockGraphQLClient;

  setUp(() {
    mockGraphQLClient = generateMockGraphQLClient();
  });

  group('tryGetEpisodesCount', () {
    test('return false when query result has exception', () {
      final result = generateMockQuery(mockGraphQLClient);
      when(() => result.hasException).thenReturn(true);
      expect(tryGetEpisodesCount(result)[0], false);
    });
    test('return false when query result is loading', () {
      final result = generateMockQuery(mockGraphQLClient);
      when(() => result.hasException).thenReturn(false);
      when(() => result.isLoading).thenReturn(true);
      expect(tryGetEpisodesCount(result)[0], false);
    });
    test('return true when query result is correct', () {
      final result = generateMockQuery(mockGraphQLClient);
      when(() => result.hasException).thenReturn(false);
      when(() => result.isLoading).thenReturn(false);
      expect(tryGetEpisodesCount(result)[0], true);
    });
  });
}
