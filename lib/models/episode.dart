class EpisodeIndex {
  EpisodeIndex({required this.episodes});

  factory EpisodeIndex.fromJson(Map<String, dynamic> json) {
    final items = (json['episodes'] as List<dynamic>? ?? [])
        .map((item) => EpisodeSummary.fromJson(item as Map<String, dynamic>))
        .toList();
    return EpisodeIndex(episodes: items);
  }

  final List<EpisodeSummary> episodes;
}

class EpisodeSummary {
  EpisodeSummary({
    required this.id,
    required this.title,
    required this.caseNumber,
    required this.status,
    required this.free,
    required this.local,
    this.manifest,
    this.remoteManifestUrl,
  });

  factory EpisodeSummary.fromJson(Map<String, dynamic> json) {
    return EpisodeSummary(
      id: json['id'] as String,
      title: json['title'] as String,
      caseNumber: json['caseNumber'] as String,
      status: json['status'] as String,
      free: json['free'] as bool? ?? false,
      local: json['local'] as bool? ?? false,
      manifest: json['manifest'] as String?,
      remoteManifestUrl: json['remoteManifestUrl'] as String?,
    );
  }

  final String id;
  final String title;
  final String caseNumber;
  final String status;
  final bool free;
  final bool local;
  final String? manifest;
  final String? remoteManifestUrl;

  bool get isPlayable => status == 'downloaded' && manifest != null;
}

class EpisodeManifest {
  EpisodeManifest({
    required this.id,
    required this.title,
    required this.caseNumber,
    required this.subtitle,
    required this.cover,
    required this.story,
    required this.missingPerson,
    required this.evidenceCatalog,
  });

  factory EpisodeManifest.fromJson(Map<String, dynamic> json) {
    return EpisodeManifest(
      id: json['id'] as String,
      title: json['title'] as String,
      caseNumber: json['caseNumber'] as String,
      subtitle: json['subtitle'] as String? ?? '',
      cover: json['cover'] as String?,
      story: json['story'] as String,
      missingPerson:
          MissingPerson.fromJson(json['missingPerson'] as Map<String, dynamic>),
      evidenceCatalog: (json['evidenceCatalog'] as List<dynamic>? ?? [])
          .map((item) => EvidenceDefinition.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String title;
  final String caseNumber;
  final String subtitle;
  final String? cover;
  final String story;
  final MissingPerson missingPerson;
  final List<EvidenceDefinition> evidenceCatalog;
}

class MissingPerson {
  MissingPerson({
    required this.name,
    required this.age,
    required this.lastSeen,
    required this.criticalTime,
  });

  factory MissingPerson.fromJson(Map<String, dynamic> json) {
    return MissingPerson(
      name: json['name'] as String,
      age: json['age'] as int,
      lastSeen: json['lastSeen'] as String,
      criticalTime: json['criticalTime'] as String,
    );
  }

  final String name;
  final int age;
  final String lastSeen;
  final String criticalTime;
}

class EvidenceDefinition {
  EvidenceDefinition({
    required this.id,
    required this.title,
    required this.description,
  });

  factory EvidenceDefinition.fromJson(Map<String, dynamic> json) {
    return EvidenceDefinition(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
    );
  }

  final String id;
  final String title;
  final String description;
}
