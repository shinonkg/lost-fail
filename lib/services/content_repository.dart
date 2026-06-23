import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/episode.dart';
import '../models/story.dart';

class ContentRepository {
  Future<EpisodeIndex> loadEpisodeIndex() async {
    final raw = await rootBundle.loadString('data/episode_index.json');
    return EpisodeIndex.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<EpisodeManifest> loadManifest(EpisodeSummary episode) async {
    final manifestPath = episode.manifest;
    if (manifestPath == null) {
      throw StateError('Episode has no local manifest: ${episode.id}');
    }
    final raw = await rootBundle.loadString(manifestPath);
    return EpisodeManifest.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<StoryPackage> loadStory(EpisodeManifest manifest) async {
    final raw = await rootBundle.loadString(manifest.story);
    return StoryPackage.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
