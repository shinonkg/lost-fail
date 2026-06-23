import 'package:flutter/material.dart';

class CasePanel extends StatelessWidget {
  const CasePanel({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: const Color(0xff1a1a1a),
        border: Border.all(color: const Color(0xff35302a)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}
