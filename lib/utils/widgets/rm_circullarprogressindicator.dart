import 'package:flutter/material.dart';

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
