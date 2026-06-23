import 'package:flutter/material.dart';

import '../models/episode.dart';
import '../services/content_repository.dart';
import '../widgets/case_panel.dart';
import 'episode_intro_screen.dart';

class EpisodeListScreen extends StatelessWidget {
  const EpisodeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ContentRepository();
    return Scaffold(
      appBar: AppBar(title: const Text('Dosyalar')),
      body: FutureBuilder<EpisodeIndex>(
        future: repository.loadEpisodeIndex(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final episodes = snapshot.data!.episodes;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: episodes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final episode = episodes[index];
              return CasePanel(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${episode.caseNumber}: ${episode.title}'),
                  subtitle: Text(_statusLabel(episode)),
                  trailing: Icon(episode.isPlayable ? Icons.chevron_right : Icons.lock_clock),
                  onTap: episode.isPlayable
                      ? () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (_) => EpisodeIntroScreen(episode: episode)));
                        }
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _statusLabel(EpisodeSummary episode) {
    if (episode.status == 'downloaded') {
      return episode.free ? 'Ücretsiz / indirildi' : 'İndirildi';
    }
    if (episode.status == 'coming_soon') {
      return 'Yakında';
    }
    return 'Kilitli';
  }
}
