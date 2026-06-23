import 'package:flutter/material.dart';

import '../models/episode.dart';
import '../models/save_state.dart';
import '../services/content_repository.dart';
import '../services/save_service.dart';
import '../widgets/case_panel.dart';

class EvidenceArchiveScreen extends StatelessWidget {
  const EvidenceArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = ContentRepository();
    final saveService = SaveService();
    return Scaffold(
      appBar: AppBar(title: const Text('Delil Arşivi')),
      body: FutureBuilder<_ArchiveData>(
        future: _load(repository, saveService),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final data = snapshot.data!;
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: data.manifest.evidenceCatalog.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final evidence = data.manifest.evidenceCatalog[index];
              final found = data.save.foundEvidence.contains(evidence.id);
              return Opacity(
                opacity: found ? 1 : 0.46,
                child: CasePanel(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(found ? Icons.check_circle : Icons.lock),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(found ? evidence.title : 'Kilitli delil', style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 5),
                            Text(found ? evidence.description : 'Bu delil henüz bulunmadı.'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<_ArchiveData> _load(ContentRepository repository, SaveService saveService) async {
    final index = await repository.loadEpisodeIndex();
    final episode = index.episodes.firstWhere((item) => item.id == 'dosya_01');
    final manifest = await repository.loadManifest(episode);
    final save = await saveService.load();
    return _ArchiveData(manifest: manifest, save: save);
  }
}

class _ArchiveData {
  _ArchiveData({required this.manifest, required this.save});

  final EpisodeManifest manifest;
  final SaveState save;
}
