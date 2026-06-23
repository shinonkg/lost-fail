import 'package:flutter/material.dart';

import '../models/story.dart';
import '../services/save_service.dart';
import '../widgets/case_button.dart';
import 'home_screen.dart';

class EndingScreen extends StatelessWidget {
  const EndingScreen({required this.node, required this.successRate, super.key});

  final StoryNode node;
  final int successRate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(node.title, style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: const Color(0xffffdf9e), fontWeight: FontWeight.w700)),
            const SizedBox(height: 18),
            SelectableText(node.text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.5)),
            const SizedBox(height: 24),
            LinearProgressIndicator(value: successRate / 100, minHeight: 8, borderRadius: BorderRadius.circular(8)),
            const SizedBox(height: 8),
            Text('Başarı oranı: %$successRate'),
            const SizedBox(height: 24),
            CaseButton(
              label: 'Yeniden Oyna',
              icon: Icons.replay,
              onPressed: () async {
                await SaveService().clear();
                if (!context.mounted) return;
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
              },
            ),
            const SizedBox(height: 12),
            CaseButton(
              label: 'Ana Menüye Dön',
              icon: Icons.home,
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (_) => const HomeScreen()), (_) => false);
              },
            ),
          ],
        ),
      ),
    );
  }
}
