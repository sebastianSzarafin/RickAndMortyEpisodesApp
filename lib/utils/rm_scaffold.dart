import 'package:flutter/cupertino.dart';
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
                    Stack(
                      children: [
                        const SizedBox(
                          width: double.infinity,
                          child: Image(
                            image: AssetImage(
                                "assets/images/rick-and-morty-home.png"),
                            height: 195,
                          ),
                        ),
                        IconButton(
                          padding:
                              const EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                          alignment: Alignment.centerLeft,
                          color: Theme.of(context).colorScheme.secondary,
                          onPressed: () => Scaffold.of(context).openDrawer(),
                          icon: const Icon(
                            CupertinoIcons.line_horizontal_3,
                            size: 30,
                          ),
                        )
                      ],
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
