import 'package:flutter/material.dart';

class CircularProgress extends StatelessWidget {
  const CircularProgress([this.size = double.infinity, Key? key])
      : super(key: key);

  final double size;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onPrimary,
        ),
      ),
    );
  }
}
