import 'dart:async';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mockito/mockito.dart';

class MockGraphQLCache extends Mock implements GraphQLCache {}

class MockQueryResult<T> extends Mock implements QueryResult<T> {
  @override
  bool get isOptimistic => super.noSuchMethod(
        Invocation.getter(#isOptimistic),
        returnValue: true,
      );

  @override
  bool get isLoading => super.noSuchMethod(
        Invocation.getter(#isLoading),
        returnValue: true,
      );

  @override
  bool get hasException => super.noSuchMethod(
        Invocation.getter(#hasException),
        returnValue: true,
      );
}

class MockMultiSourceResult<T> extends Mock implements MultiSourceResult<T> {}

class MockObservableQuery<T> extends Mock implements ObservableQuery<T> {
  List<OnData<T>> onDataCallbacks = [];

  Map<String, dynamic> usedVariables = {};

  @override
  set variables(Map<String, dynamic> variables) {
    usedVariables = variables;
  }

  @override
  void onData(Iterable<OnData<T>> callbacks) =>
      onDataCallbacks.addAll(callbacks);

  @override
  final String queryId = 'queryId';

  @override
  MultiSourceResult<T> fetchResults() {
    return super.noSuchMethod(
      Invocation.method(
        #fetchResults,
        null,
      ),
      returnValue: MockMultiSourceResult<T>(),
    );
  }

  @override
  Stream<QueryResult<T>> get stream {
    return super.noSuchMethod(
      Invocation.getter(#stream),
      returnValue: Stream.value(MockQueryResult<T>()),
    );
  }

  @override
  FutureOr<QueryLifecycle> close({
    bool force = false,
    bool fromManager = false,
  }) async {
    return super.noSuchMethod(
      Invocation.method(
        #close,
        null,
        {#force: force, #fromManager: fromManager},
      ),
      returnValue: QueryLifecycle.closed,
    );
  }
}

class MockQueryManager extends Mock implements QueryManager {
  @override
  ObservableQuery<TParsed> watchQuery<TParsed>(
    WatchQueryOptions<TParsed>? options,
  ) {
    return super.noSuchMethod(
      Invocation.method(
        #watchQuery,
        [options],
      ),
      returnValue: MockObservableQuery<TParsed>(),
    );
  }
}

class MockGraphQLClient extends Mock implements GraphQLClient {
  @override
  DefaultPolicies get defaultPolicies => DefaultPolicies();

  @override
  final GraphQLCache cache = MockGraphQLCache();

  @override
  MockQueryManager get queryManager => super.noSuchMethod(
        Invocation.getter(#queryManager),
        returnValue: MockQueryManager(),
      );
}

MockGraphQLClient getMockGraphQLClient() {
  final client = MockGraphQLClient();
  final queryManager = MockQueryManager();

  when(client.queryManager).thenReturn(queryManager);

  return client;
}

MockQueryResult<T> generateMockObservableQuery<T>(
  MockGraphQLClient graphQLClient, [
  MockObservableQuery<T>? query,
]) {
  final result = MockQueryResult<T>();
  when(result.isOptimistic).thenReturn(false);

  final queryManager = graphQLClient.queryManager;

  final mockedQuery = query ?? MockObservableQuery<T>();

  when(mockedQuery.close()).thenReturn(QueryLifecycle.closed);
  when(mockedQuery.stream).thenAnswer((_) => Stream.value(result));
  when(mockedQuery.latestResult).thenReturn(result);
  when(mockedQuery.fetchResults()).thenAnswer((_) {
    for (final callback in mockedQuery.onDataCallbacks) {
      callback(result);
    }
    return MockMultiSourceResult();
  });

  when(queryManager.watchQuery<T>(any)).thenReturn(mockedQuery);
  return result;
}
