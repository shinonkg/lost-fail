import 'package:flutter/material.dart';

import '../models/episode.dart';
import '../models/save_state.dart';
import '../models/story.dart';
import '../services/content_repository.dart';
import '../services/save_service.dart';
import '../services/story_engine.dart';
import '../widgets/case_button.dart';
import 'ending_screen.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({required this.episode, this.continueSave = false, super.key});

  final EpisodeSummary episode;
  final bool continueSave;

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final _repository = ContentRepository();
  final _saveService = SaveService();

  StoryPackage? _story;
  StoryEngine? _engine;
  StoryNode? _node;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final manifest = await _repository.loadManifest(widget.episode);
    final story = await _repository.loadStory(manifest);
    final saved = await _saveService.load();
    final startNode = widget.continueSave && saved.currentEpisodeId == widget.episode.id
        ? saved.currentNodeId ?? story.startNode
        : story.startNode;
    final initialState = widget.continueSave
        ? saved.copyWith(currentEpisodeId: widget.episode.id, currentNodeId: startNode)
        : SaveState(currentEpisodeId: widget.episode.id, currentNodeId: startNode, downloadedEpisodes: saved.downloadedEpisodes);
    final engine = StoryEngine(story, initialState);
    final node = story.nodeById(startNode);
    if (widget.continueSave && saved.currentEpisodeId == widget.episode.id) {
      await _saveService.save(initialState);
    } else {
      final nextState = engine.enterNode(widget.episode.id, node);
      await _saveService.save(nextState);
    }
    if (!mounted) return;
    setState(() {
      _story = story;
      _engine = engine;
      _node = node;
      _loading = false;
    });
    _openEndingIfNeeded(node);
  }

  Future<void> _choose(StoryChoice choice) async {
    final engine = _engine!;
    final state = engine.choose(widget.episode.id, choice);
    final nextNode = _story!.nodeById(choice.next);
    await _saveService.save(state);
    if (!mounted) return;
    setState(() => _node = nextNode);
    _openEndingIfNeeded(nextNode);
  }

  void _openEndingIfNeeded(StoryNode node) {
    if (!node.isEnding || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => EndingScreen(node: node, successRate: _engine!.successRate())),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || _node == null || _engine == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final node = _node!;
    final choices = _engine!.visibleChoicesFor(node);
    return Scaffold(
      appBar: AppBar(title: Text(widget.episode.caseNumber)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (node.image != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(node.image!, height: 190, fit: BoxFit.cover, errorBuilder: (_, __, ___) => const SizedBox.shrink()),
              ),
            ),
          Text(node.title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: const Color(0xffffdf9e), fontWeight: FontWeight.w700)),
          const SizedBox(height: 14),
          SelectableText(node.text, style: Theme.of(context).textTheme.bodyLarge?.copyWith(height: 1.48, color: const Color(0xffeee6d8))),
          const SizedBox(height: 24),
          for (final choice in choices) ...[
            CaseButton(label: choice.label, onPressed: () => _choose(choice)),
            const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }
}
