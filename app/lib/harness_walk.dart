/// Harness walk utility for story 1259
/// Implements the "harness walk" acceptance criteria

class HarnessWalk {
  final String name;
  final int step;

  HarnessWalk({required this.name, this.step = 1});

  /// Execute the harness walk
  String execute() {
    return 'Harness walk "$name" at step $step';
  }

  /// Create a new walk with incremented step
  HarnessWalk nextStep() {
    return HarnessWalk(name: name, step: step + 1);
  }

  /// Check if walk is complete (arbitrary completion at step 5)
  bool isComplete() {
    return step >= 5;
  }
}
