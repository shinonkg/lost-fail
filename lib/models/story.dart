class StoryPackage {
  StoryPackage({
    required this.episodeId,
    required this.startNode,
    required this.fallbackNode,
    required this.nodes,
  });

  factory StoryPackage.fromJson(Map<String, dynamic> json) {
    final nodeList = (json['nodes'] as List<dynamic>? ?? [])
        .map((item) => StoryNode.fromJson(item as Map<String, dynamic>))
        .toList();
    return StoryPackage(
      episodeId: json['episodeId'] as String,
      startNode: json['startNode'] as String,
      fallbackNode: json['fallbackNode'] as String? ?? json['startNode'] as String,
      nodes: {for (final node in nodeList) node.id: node},
    );
  }

  final String episodeId;
  final String startNode;
  final String fallbackNode;
  final Map<String, StoryNode> nodes;

  StoryNode nodeById(String id) {
    final node = nodes[id];
    if (node == null) {
      throw StateError('Story node not found: $id');
    }
    return node;
  }
}

class StoryNode {
  StoryNode({
    required this.id,
    required this.title,
    required this.text,
    required this.type,
    required this.choices,
    required this.effects,
    this.image,
    this.endingId,
  });

  factory StoryNode.fromJson(Map<String, dynamic> json) {
    return StoryNode(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      text: json['text'] as String? ?? '',
      type: json['type'] as String? ?? 'story',
      image: json['image'] as String?,
      endingId: json['endingId'] as String?,
      effects: Map<String, dynamic>.from(json['effects'] as Map? ?? {}),
      choices: (json['choices'] as List<dynamic>? ?? [])
          .map((item) => StoryChoice.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String title;
  final String text;
  final String type;
  final String? image;
  final String? endingId;
  final List<StoryChoice> choices;
  final Map<String, dynamic> effects;

  bool get isEnding => type == 'ending' || endingId != null;
}

class StoryChoice {
  StoryChoice({
    required this.label,
    required this.next,
    required this.requires,
    required this.effects,
  });

  factory StoryChoice.fromJson(Map<String, dynamic> json) {
    return StoryChoice(
      label: json['label'] as String,
      next: json['next'] as String,
      requires: Map<String, dynamic>.from(json['requires'] as Map? ?? {}),
      effects: Map<String, dynamic>.from(json['effects'] as Map? ?? {}),
    );
  }

  final String label;
  final String next;
  final Map<String, dynamic> requires;
  final Map<String, dynamic> effects;
}
