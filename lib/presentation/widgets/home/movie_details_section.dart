import 'package:flutter/material.dart';

class MovieDetailsSection extends StatelessWidget {
  final String title;
  final Widget child;

  const MovieDetailsSection({
    super.key,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        child,
      ],
    );
  }
}
