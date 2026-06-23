class SaveState {
  SaveState({
    this.currentEpisodeId,
    this.currentNodeId,
    Map<String, dynamic>? playerVariables,
    Set<String>? foundEvidence,
    Set<String>? completedEndings,
    Set<String>? downloadedEpisodes,
  })  : playerVariables = playerVariables ?? <String, dynamic>{},
        foundEvidence = foundEvidence ?? <String>{},
        completedEndings = completedEndings ?? <String>{},
        downloadedEpisodes = downloadedEpisodes ?? {'dosya_01_kirik_saat'};

  factory SaveState.fromJson(Map<String, dynamic> json) {
    return SaveState(
      currentEpisodeId: json['current_episode_id'] as String?,
      currentNodeId: json['current_node_id'] as String?,
      playerVariables:
          Map<String, dynamic>.from(json['player_variables'] as Map? ?? {}),
      foundEvidence:
          Set<String>.from(json['found_evidence'] as List<dynamic>? ?? []),
      completedEndings:
          Set<String>.from(json['completed_endings'] as List<dynamic>? ?? []),
      downloadedEpisodes:
          Set<String>.from(json['downloaded_episodes'] as List<dynamic>? ?? ['dosya_01_kirik_saat']),
    );
  }

  final String? currentEpisodeId;
  final String? currentNodeId;
  final Map<String, dynamic> playerVariables;
  final Set<String> foundEvidence;
  final Set<String> completedEndings;
  final Set<String> downloadedEpisodes;

  Map<String, dynamic> toJson() {
    return {
      'current_episode_id': currentEpisodeId,
      'current_node_id': currentNodeId,
      'player_variables': playerVariables,
      'found_evidence': foundEvidence.toList(),
      'completed_endings': completedEndings.toList(),
      'downloaded_episodes': downloadedEpisodes.toList(),
    };
  }

  SaveState copyWith({
    String? currentEpisodeId,
    String? currentNodeId,
    Map<String, dynamic>? playerVariables,
    Set<String>? foundEvidence,
    Set<String>? completedEndings,
    Set<String>? downloadedEpisodes,
  }) {
    return SaveState(
      currentEpisodeId: currentEpisodeId ?? this.currentEpisodeId,
      currentNodeId: currentNodeId ?? this.currentNodeId,
      playerVariables: playerVariables ?? Map<String, dynamic>.from(this.playerVariables),
      foundEvidence: foundEvidence ?? Set<String>.from(this.foundEvidence),
      completedEndings: completedEndings ?? Set<String>.from(this.completedEndings),
      downloadedEpisodes:
          downloadedEpisodes ?? Set<String>.from(this.downloadedEpisodes),
    );
  }
}
