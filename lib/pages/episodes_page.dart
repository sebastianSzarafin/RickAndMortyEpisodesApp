import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:rick_and_morty_episodes_display/pages/episode_page.dart';
import 'package:rick_and_morty_episodes_display/queries/queries.dart';

class EpisodesPage extends HookWidget {
  const EpisodesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final readEpisodesCount = useQuery(QueryOptions(
      document: gql(allEpisodesGraphQL),
    ));

    final result = readEpisodesCount.result;

    if (result.hasException) {
      return Text(result.exception.toString());
    }

    if (result.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Rick & Morty Episodes App'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    final episodesCount = result.data?['episodes']?['info']?['count'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick & Morty Episodes App'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 25),
          const Text(
            'All episodes',
            style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
              itemCount: episodesCount,
              itemBuilder: ((context, index) => Card(
                    // child: ListTile(
                    //   title: Text('Episode ${index + 1}'),
                    //   subtitle: Text('sub'),
                    //   trailing: const Icon(Icons.arrow_forward),
                    //   onTap: () {
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //       builder: (context) => EpisodePage(id: index),
                    //     ));
                    //   },
                    // ),
                    child: Query(
                      options: QueryOptions(
                          document: gql(singleEpisodeGraphQL),
                          variables: {'id': index + 1}),
                      builder: ((result, {fetchMore, refetch}) {
                        if (result.hasException) {
                          return Text(result.exception.toString());
                        }

                        if (result.isLoading) {
                          return Container();
                        }

                        return ListTile(
                          title: Text(
                            'Episode ${result.data?['episode']?['id']}: ${result.data?['episode']?['name']}',
                            style: const TextStyle(
                                overflow: TextOverflow.ellipsis),
                          ),
                          subtitle: Text(result.data?['episode']?['episode']),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EpisodePage(id: index),
                            ));
                          },
                        );
                      }),
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}

// class EpisodesPage extends StatelessWidget {
//   EpisodesPage({super.key});

//   final client = getGraphQlClient();

//   @override
//   Widget build(BuildContext context) {
//     return GraphQLProvider(
//       client: client,
//       child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Rick & Morty Episodes App'),
//           ),
//           body: Query(
//             options: QueryOptions(
//               document: gql(allEpisodesGraphQL),
//             ),
//             builder: ((result, {fetchMore, refetch}) {
//               if (result.hasException) {
//                 return Text(result.exception.toString());
//               }

//               if (result.isLoading) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }

//               final episodesCount = result.data?['episodes']?['info']?['count'];

//               return Column(
//                 children: [
//                   const SizedBox(height: 25),
//                   const Text(
//                     'All episodes',
//                     style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
//                   ),
//                   const SizedBox(height: 25),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: episodesCount,
//                       itemBuilder: ((context, index) => Card(
//                             child: ListTile(
//                               title: Text('Episode ${index + 1}'),
//                               subtitle: Text('dupa'),
//                               trailing: const Icon(Icons.arrow_forward),
//                               onTap: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => EpisodePage(id: index),
//                                 ));
//                               },
//                             ),
//                           )),
//                     ),
//                   )
//                 ],
//               );
//             }),
//           )),
//     );
//   }
// }

// class _EpisodesPageState extends State {
//   final client = getGraphQlClient();

//   @override
//   Widget build(BuildContext context) {
//     // return GraphQLProvider(
//     //   client: client,
//     //   child: Scaffold(
//     //     appBar: AppBar(
//     //       title: const Text('Rick & Morty Episodes App'),
//     //     ),
//     //     body: Column(
//     //       children: [
//     //         const SizedBox(height: 25),
//     //         const Text(
//     //           'All episodes',
//     //           style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
//     //         ),
//     //         const SizedBox(height: 25),
//     //         Expanded(
//     //           child: ListView.builder(
//     //             itemCount: 7,
//     //             itemBuilder: ((context, index) => Card(
//     //                   child: ListTile(
//     //                     title: Text('Episode $index'),
//     //                     subtitle: Text('dupa'),
//     //                     trailing: const Icon(Icons.arrow_forward),
//     //                     onTap: () {
//     //                       Navigator.of(context).push(MaterialPageRoute(
//     //                         builder: (context) => EpisodePage(id: index),
//     //                       ));
//     //                     },
//     //                   ),
//     //                 )),
//     //           ),
//     //         )
//     //       ],
//     //     ),
//     //   ),
//     // );

//     // final readEpisodesCount = useQuery(QueryOptions(
//     //   document: gql(allEpisodesGraphQL),
//     // ));

//     // final result = readEpisodesCount.result;

//     // if (result.hasException) {
//     //   return Text(result.exception.toString());
//     // }

//     // if (result.isLoading) {
//     //   return const Center(
//     //     child: CircularProgressIndicator(),
//     //   );
//     // }

//     // final episodesCount = result.data?['episodes']?['info']?['count'];

//     // return GraphQLProvider(
//     //   client: client,
//     //   child: Scaffold(
//     //       appBar: AppBar(
//     //         title: const Text('Rick & Morty Episodes App'),
//     //       ),
//     //       body: Query(
//     //         options: QueryOptions(
//     //           document: gql(allEpisodesGraphQL),
//     //         ),
//     //         builder: ((result, {fetchMore, refetch}) {
//     //           if (result.hasException) {
//     //             return Text(result.exception.toString());
//     //           }

//     //           if (result.isLoading) {
//     //             return const Center(
//     //               child: CircularProgressIndicator(),
//     //             );
//     //           }

//     //           final episodesCount = result.data?['episodes']?['info']?['count'];

//     //           return Column(
//     //             children: [
//     //               const SizedBox(height: 25),
//     //               const Text(
//     //                 'All episodes',
//     //                 style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
//     //               ),
//     //               const SizedBox(height: 25),
//     //               Expanded(
//     //                 child: ListView.builder(
//     //                   itemCount: episodesCount,
//     //                   itemBuilder: ((context, index) => Card(
//     //                         child: ListTile(
//     //                           title: Text('Episode ${index + 1}'),
//     //                           subtitle: Text('dupa'),
//     //                           trailing: const Icon(Icons.arrow_forward),
//     //                           onTap: () {
//     //                             Navigator.of(context).push(MaterialPageRoute(
//     //                               builder: (context) => EpisodePage(id: index),
//     //                             ));
//     //                           },
//     //                         ),
//     //                       )),
//     //                 ),
//     //               )
//     //             ],
//     //           );
//     //         }),
//     //       )),
//     // );

//     return GraphQLProvider(
//       client: client,
//       child: Scaffold(
//           appBar: AppBar(
//             title: const Text('Rick & Morty Episodes App'),
//           ),
//           body: Query(
//             options: QueryOptions(
//               document: gql(allEpisodesGraphQL),
//             ),
//             builder: ((result, {fetchMore, refetch}) {
//               if (result.hasException) {
//                 return Text(result.exception.toString());
//               }

//               if (result.isLoading) {
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               }

//               final episodesCount = result.data?['episodes']?['info']?['count'];

//               return Column(
//                 children: [
//                   const SizedBox(height: 25),
//                   const Text(
//                     'All episodes',
//                     style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
//                   ),
//                   const SizedBox(height: 25),
//                   Expanded(
//                     child: ListView.builder(
//                       itemCount: episodesCount,
//                       itemBuilder: ((context, index) => Card(
//                             child: ListTile(
//                               title: Text('Episode ${index + 1}'),
//                               subtitle: Text('dupa'),
//                               trailing: const Icon(Icons.arrow_forward),
//                               onTap: () {
//                                 Navigator.of(context).push(MaterialPageRoute(
//                                   builder: (context) => EpisodePage(id: index),
//                                 ));
//                               },
//                             ),
//                           )),
//                     ),
//                   )
//                 ],
//               );
//             }),
//           )),
//     );
//   }
// }

// int getEpisodesCount() {
//   final readEpisodesCount = useQuery(QueryOptions(
//     document: gql(allEpisodesGraphQL),
//   ));

//   final result = readEpisodesCount.result;

//   if (result.hasException) {
//     return 0;
//   }

//   if (result.isLoading) {
//     Scaffold(
//       appBar: AppBar(
//         title: const Text('Rick & Morty Episodes App'),
//       ),
//       body: const Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }

//   return result.data?['episodes']?['info']?['count'];
// }
