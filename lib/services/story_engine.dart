import '../models/save_state.dart';
import '../models/story.dart';

class StoryEngine {
  StoryEngine(this.story, SaveState state)
      : state = state.copyWith(
          playerVariables: Map<String, dynamic>.from(state.playerVariables),
          foundEvidence: Set<String>.from(state.foundEvidence),
          completedEndings: Set<String>.from(state.completedEndings),
        );

  final StoryPackage story;
  SaveState state;

  StoryNode currentNode() {
    return story.nodeById(state.currentNodeId ?? story.startNode);
  }

  List<StoryChoice> visibleChoicesFor(StoryNode node) {
    final visible = node.choices.where(_requirementsMet).toList();
    if (visible.isNotEmpty || node.isEnding) {
      return visible;
    }
    return [
      StoryChoice(
        label: 'Dosyayı yeniden değerlendir',
        next: story.fallbackNode,
        requires: const {},
        effects: const {},
      ),
    ];
  }

  SaveState enterNode(String episodeId, StoryNode node) {
    _applyEffects(node.effects);
    if (node.isEnding && node.endingId != null) {
      state.completedEndings.add(node.endingId!);
    }
    state = state.copyWith(
      currentEpisodeId: episodeId,
      currentNodeId: node.id,
      playerVariables: state.playerVariables,
      foundEvidence: state.foundEvidence,
      completedEndings: state.completedEndings,
    );
    return state;
  }

  SaveState choose(String episodeId, StoryChoice choice) {
    _applyEffects(choice.effects);
    final nextNode = story.nodeById(choice.next);
    return enterNode(episodeId, nextNode);
  }

  bool _requirementsMet(StoryChoice choice) {
    for (final entry in choice.requires.entries) {
      final actual = _valueFor(entry.key);
      if (actual != entry.value) {
        return false;
      }
    }
    return true;
  }

  dynamic _valueFor(String key) {
    if (state.playerVariables.containsKey(key)) {
      return state.playerVariables[key];
    }
    if (state.foundEvidence.contains(key)) {
      return true;
    }
    return null;
  }

  void _applyEffects(Map<String, dynamic> effects) {
    for (final entry in effects.entries) {
      final key = entry.key;
      final value = entry.value;
      if (key.startsWith('d_') && value == true) {
        state.foundEvidence.add(key);
      }
      if (value is int) {
        final previous = state.playerVariables[key];
        state.playerVariables[key] = (previous is int ? previous : 0) + value;
      } else {
        state.playerVariables[key] = value;
      }
    }
  }

  int successRate() {
    final evidenceScore = state.playerVariables['delil_puani'];
    final mistakeScore = state.playerVariables['hata_puani'];
    final score = (evidenceScore is int ? evidenceScore : 0) -
        (mistakeScore is int ? mistakeScore : 0);
    return score.clamp(0, 100).toInt();
  }
}
