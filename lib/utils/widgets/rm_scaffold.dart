import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const double appBarHeight = 200;

class RMScaffold extends StatelessWidget {
  const RMScaffold({super.key, required this.getBody});

  final Widget Function() getBody;

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverAppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).cardColor,
            expandedHeight: appBarHeight,
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
                            height: appBarHeight,
                          ),
                        ),
                        IconButton(
                          padding:
                              const EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
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
                  ],
                ),
              ),
            ),
          ),
        ];
      },
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 5,
            color: Theme.of(context).colorScheme.secondary,
          ),
          Expanded(child: getBody()),
        ],
      ),
    );
  }
}
