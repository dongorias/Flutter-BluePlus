import 'package:flutter/material.dart';

class ShowErroTile extends StatelessWidget {
  const ShowErroTile({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Center(child: Text(text, textAlign: TextAlign.center,)),
    );
  }
}
