import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class RMCircullarProgressIndicator extends StatelessWidget {
  const RMCircullarProgressIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
          Theme.of(context).colorScheme.secondary),
    );
  }
}
