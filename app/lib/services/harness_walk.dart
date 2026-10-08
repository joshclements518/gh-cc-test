/// Harness walk utility for story 1252.
/// Provides test harness functionality for walking through app states.
class HarnessWalk {
  final List<String> _steps = [];
  int _currentStep = 0;

  /// Records a step in the harness walk.
  void recordStep(String step) {
    _steps.add(step);
  }

  /// Advances to the next step in the walk.
  bool nextStep() {
    if (_currentStep < _steps.length - 1) {
      _currentStep++;
      return true;
    }
    return false;
  }

  /// Returns to the previous step in the walk.
  bool previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      return true;
    }
    return false;
  }

  /// Gets the current step description.
  String? get currentStep =>
      _steps.isEmpty ? null : _steps[_currentStep];

  /// Gets the total number of steps recorded.
  int get stepCount => _steps.length;

  /// Gets the current step index (0-based).
  int get currentIndex => _currentStep;

  /// Resets the walk to the beginning.
  void reset() {
    _currentStep = 0;
  }

  /// Clears all recorded steps.
  void clear() {
    _steps.clear();
    _currentStep = 0;
  }
}
