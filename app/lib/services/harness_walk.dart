/// Harness walk utility for story 1513.
/// Provides a simple walk-through validation mechanism.
class HarnessWalk {
  final List<String> _steps = [];
  
  /// Records a step in the walk.
  void step(String name) {
    _steps.add(name);
  }
  
  /// Returns all recorded steps.
  List<String> get steps => List.unmodifiable(_steps);
  
  /// Checks if a specific step was recorded.
  bool hasStep(String name) => _steps.contains(name);
  
  /// Clears all recorded steps.
  void reset() {
    _steps.clear();
  }
  
  /// Returns the number of steps recorded.
  int get stepCount => _steps.length;
  
  /// Validates that the walk contains expected steps.
  bool validate(List<String> expectedSteps) {
    if (expectedSteps.length != _steps.length) return false;
    for (int i = 0; i < expectedSteps.length; i++) {
      if (_steps[i] != expectedSteps[i]) return false;
    }
    return true;
  }
}
