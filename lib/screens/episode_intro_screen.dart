import 'package:flutter/material.dart';

import '../models/episode.dart';
import '../services/content_repository.dart';
import '../widgets/case_button.dart';
import '../widgets/case_panel.dart';
import 'story_screen.dart';

class EpisodeIntroScreen extends StatelessWidget {
  const EpisodeIntroScreen({required this.episode, super.key});

  final EpisodeSummary episode;

  @override
  Widget build(BuildContext context) {
    final repository = ContentRepository();
    return Scaffold(
      appBar: AppBar(title: Text(episode.caseNumber)),
      body: FutureBuilder<EpisodeManifest>(
        future: repository.loadManifest(episode),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final manifest = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (manifest.cover != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    manifest.cover!,
                    height: 220,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const SizedBox(
                      height: 220,
                      child: ColoredBox(color: Color(0xff24201a)),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              Text('${manifest.caseNumber}: ${manifest.title}', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 6),
              Text(manifest.subtitle),
              const SizedBox(height: 16),
              CasePanel(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoLine(label: 'Kayıp kişi', value: manifest.missingPerson.name),
                    _InfoLine(label: 'Yaş', value: '${manifest.missingPerson.age}'),
                    _InfoLine(label: 'Son görülme', value: manifest.missingPerson.lastSeen),
                    _InfoLine(label: 'Kritik saat', value: manifest.missingPerson.criticalTime),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              CaseButton(
                label: 'Dosyayı Aç',
                icon: Icons.folder_open,
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => StoryScreen(episode: episode)));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}

class _InfoLine extends StatelessWidget {
  const _InfoLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 96, child: Text(label, style: const TextStyle(color: Color(0xffc8b99c)))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
