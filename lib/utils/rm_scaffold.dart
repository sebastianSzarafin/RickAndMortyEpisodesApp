import 'package:flutter/material.dart';

class RMScaffold extends StatelessWidget {
  const RMScaffold({super.key, required this.getList});

  final Widget Function() getList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            backgroundColor: Theme.of(context).cardColor,
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: SafeArea(
                child: Column(
                  children: [
                    const Image(
                      image:
                          AssetImage("assets/images/rick-and-morty-home.png"),
                      height: 195,
                    ),
                    Container(
                      height: 5,
                      color: Theme.of(context).colorScheme.secondary,
                    )
                  ],
                ),
              ),
            ),
          ),
          getList(),
        ],
      ),
    );
  }
}
