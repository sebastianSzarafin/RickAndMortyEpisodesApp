import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rick_and_morty_episodes_display/pages/episode_page.dart';

class EpisodesPage extends StatefulWidget {
  const EpisodesPage({super.key});

  @override
  State<EpisodesPage> createState() => _EpisodesPageState();
}

class _EpisodesPageState extends State<EpisodesPage> {
  @override
  Widget build(BuildContext context) {
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
              itemCount: 7,
              itemBuilder: ((context, index) => Card(
                    child: ListTile(
                      title: Text('Episode $index'),
                      trailing: const Icon(Icons.arrow_forward),
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EpisodePage(id: index),
                        ));
                      },
                    ),
                  )),
            ),
          )
        ],
      ),
    );
  }
}
