import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mocktail/mocktail.dart';

class MockGraphQLClient extends Mock implements GraphQLClient {}

class MockQueryManager extends Mock implements QueryManager {}

MockGraphQLClient generateMockGraphQLClient() {
  final graphQLClient = MockGraphQLClient();
  final queryManager = MockQueryManager();

  when(() => graphQLClient.defaultPolicies).thenReturn(DefaultPolicies());
  when(() => graphQLClient.queryManager).thenReturn(queryManager);

  return graphQLClient;
}

class MockQueryResult extends Mock implements QueryResult {}

class FakeQueryOptions extends Fake implements QueryOptions {}

MockQueryResult generateMockQuery<T>(MockGraphQLClient graphQLClient) {
  registerFallbackValue(FakeQueryOptions());

  final result = MockQueryResult();
  when(() => graphQLClient.query(any())).thenAnswer((_) async => result);

  final queryManager = graphQLClient.queryManager;
  when(() => queryManager.query(any())).thenAnswer((_) async => result);

  return result;
}

class _FakeWatchQueryOptions extends Fake implements WatchQueryOptions {}

class MockObservableQuery extends Mock implements ObservableQuery {}

MockQueryResult generateMockWatchQuery<T>(MockGraphQLClient graphQLClient) {
  registerFallbackValue(_FakeWatchQueryOptions());

  final query = MockObservableQuery();
  final result = MockQueryResult();

  when(query.close).thenReturn(QueryLifecycle.closed);
  when(() => query.stream).thenAnswer((_) => Stream.value(result));
  when(() => query.latestResult).thenReturn(result);
  when(() => query.onData(any())).thenReturn(() {});
  when(() => graphQLClient.watchQuery(any())).thenReturn(query);

  final queryManager = graphQLClient.queryManager;
  when(() => queryManager.watchQuery(any())).thenReturn(query);

  return result;
}
