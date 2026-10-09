/// Harness walker utility for Epic 1352 Story A
/// Provides navigation and inspection capabilities for the app structure
library harness_walker;

/// Walk result containing information about the traversal
class WalkResult {
  const WalkResult({
    required this.path,
    required this.visited,
    required this.timestamp,
  });

  final String path;
  final List<String> visited;
  final DateTime timestamp;

  @override
  String toString() => 'WalkResult(path: $path, visited: ${visited.length} nodes, at: $timestamp)';
}

/// Harness walker for navigating app structure
class HarnessWalker {
  HarnessWalker({List<String>? initialNodes}) 
      : _nodes = initialNodes ?? _defaultNodes;

  final List<String> _nodes;
  final List<String> _visited = [];

  static const List<String> _defaultNodes = [
    'home',
    'plans',
    'explore',
    'messages',
    'account',
  ];

  /// Walk through the provided path and collect visited nodes
  WalkResult walk(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    _visited.clear();

    for (final segment in segments) {
      if (_nodes.contains(segment)) {
        _visited.add(segment);
      }
    }

    return WalkResult(
      path: path,
      visited: List.unmodifiable(_visited),
      timestamp: DateTime.now(),
    );
  }

  /// Get all available nodes
  List<String> get availableNodes => List.unmodifiable(_nodes);

  /// Get visited nodes
  List<String> get visitedNodes => List.unmodifiable(_visited);

  /// Check if a specific node has been visited
  bool hasVisited(String node) => _visited.contains(node);

  /// Reset the walker state
  void reset() => _visited.clear();
}
