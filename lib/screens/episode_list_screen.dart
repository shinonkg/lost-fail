import 'package:flutter/material.dart';

import '../models/episode.dart';
import '../models/save_state.dart';
import '../services/content_repository.dart';
import '../services/save_service.dart';
import '../widgets/case_panel.dart';
import 'episode_intro_screen.dart';

class EpisodeListScreen extends StatelessWidget {
  const EpisodeListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ContentRepository();
    return Scaffold(
      appBar: AppBar(title: const Text('Dosyalar')),
      body: FutureBuilder<_EpisodeListData>(
        future: _loadData(repository),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          final episodes = data.index.episodes;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: episodes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final episode = episodes[index];
              final unlocked = _isUnlocked(episode, data.saveState);
              final playable = episode.isPlayable && unlocked;
              return CasePanel(
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${episode.caseNumber}: ${episode.title}'),
                  subtitle: Text(_statusLabel(episode, unlocked)),
                  trailing: Icon(
                    playable ? Icons.chevron_right : Icons.lock_clock,
                  ),
                  onTap: playable
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => EpisodeIntroScreen(episode: episode),
                            ),
                          );
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

  Future<_EpisodeListData> _loadData(ContentRepository repository) async {
    final index = await repository.loadEpisodeIndex();
    final saveState = await SaveService().load();
    return _EpisodeListData(index: index, saveState: saveState);
  }

  bool _isUnlocked(EpisodeSummary episode, SaveState saveState) {
    final requiredEpisode = episode.requiresCompletedEpisode;
    return requiredEpisode == null ||
        saveState.completedEpisodes.contains(requiredEpisode);
  }

  String _statusLabel(EpisodeSummary episode, bool unlocked) {
    if (!unlocked) {
      return 'Kilitli / önce Dosya 01 tamamlanmalı';
    }
    if (episode.status == 'downloaded') {
      return episode.free ? 'Ücretsiz / indirildi' : 'İndirildi';
    }
    if (episode.status == 'coming_soon') {
      return 'Yakında';
    }
    return 'Kilitli';
  }
}

class _EpisodeListData {
  _EpisodeListData({required this.index, required this.saveState});

  final EpisodeIndex index;
  final SaveState saveState;
}
