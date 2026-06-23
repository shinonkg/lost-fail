import 'package:flutter/material.dart';

import '../models/save_state.dart';
import '../services/content_repository.dart';
import '../services/save_service.dart';
import '../widgets/case_button.dart';
import 'evidence_archive_screen.dart';
import 'episode_list_screen.dart';
import 'story_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _repository = ContentRepository();
  final _saveService = SaveService();
  SaveState? _saveState;

  @override
  void initState() {
    super.initState();
    _loadSave();
  }

  Future<void> _loadSave() async {
    final save = await _saveService.load();
    if (mounted) {
      setState(() => _saveState = save);
    }
  }

  Future<void> _startFirstEpisode({bool continueSave = false}) async {
    final index = await _repository.loadEpisodeIndex();
    final episode = index.episodes.firstWhere((item) => item.id == 'dosya_01');
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => StoryScreen(
          episode: episode,
          continueSave: continueSave,
        ),
      ),
    );
    await _loadSave();
  }

  @override
  Widget build(BuildContext context) {
    final canContinue = _saveState?.currentEpisodeId != null;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 36, 20, 24),
          children: [
            Text(
              'Kayıp Dosyalar',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Seçimli dedektif dosyaları',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xffc8b99c),
                  ),
            ),
            const SizedBox(height: 40),
            CaseButton(label: 'Başla', icon: Icons.play_arrow, onPressed: () => _startFirstEpisode()),
            const SizedBox(height: 12),
            CaseButton(label: 'Devam Et', icon: Icons.restore, onPressed: canContinue ? () => _startFirstEpisode(continueSave: true) : null),
            const SizedBox(height: 12),
            CaseButton(
              label: 'Dosyalar',
              icon: Icons.folder_open,
              onPressed: () async {
                await Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EpisodeListScreen()));
                await _loadSave();
              },
            ),
            const SizedBox(height: 12),
            CaseButton(
              label: 'Delil Arşivi',
              icon: Icons.inventory_2,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) => const EvidenceArchiveScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
