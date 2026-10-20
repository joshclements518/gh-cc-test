/// Harness walk utility for Story A (Epic 1677)
/// 
/// This utility provides simple walking functionality for harness testing.
class HarnessWalk {
  /// Performs a walk operation with the given steps
  /// 
  /// Returns a summary of the walk including distance and status
  static WalkResult walk(int steps) {
    if (steps < 0) {
      throw ArgumentError('Steps must be non-negative');
    }
    
    final distance = steps * 0.75; // Assume 0.75 meters per step
    final status = steps > 0 ? 'completed' : 'no movement';
    
    return WalkResult(
      steps: steps,
      distance: distance,
      status: status,
    );
  }
  
  /// Starts a new walking session
  static WalkSession startSession() {
    return WalkSession();
  }
}

/// Result of a walk operation
class WalkResult {
  const WalkResult({
    required this.steps,
    required this.distance,
    required this.status,
  });
  
  final int steps;
  final double distance;
  final String status;
  
  @override
  String toString() {
    return 'WalkResult(steps: $steps, distance: ${distance.toStringAsFixed(2)}m, status: $status)';
  }
}

/// A walking session that tracks cumulative progress
class WalkSession {
  int _totalSteps = 0;
  double _totalDistance = 0.0;
  
  /// Add steps to the session
  void addSteps(int steps) {
    if (steps < 0) {
      throw ArgumentError('Steps must be non-negative');
    }
    _totalSteps += steps;
    _totalDistance += steps * 0.75;
  }
  
  /// Get the current total steps
  int get totalSteps => _totalSteps;
  
  /// Get the current total distance in meters
  double get totalDistance => _totalDistance;
  
  /// Get a summary of the session
  WalkResult getResult() {
    return WalkResult(
      steps: _totalSteps,
      distance: _totalDistance,
      status: _totalSteps > 0 ? 'active' : 'idle',
    );
  }
  
  /// Reset the session
  void reset() {
    _totalSteps = 0;
    _totalDistance = 0.0;
  }
}
