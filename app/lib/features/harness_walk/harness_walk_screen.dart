import 'package:flutter/material.dart';
import '../../services/services.dart';
import '../../theme/tokens.dart';

/// Harness walk screen for testing walk point tracking
class HarnessWalkScreen extends StatefulWidget {
  const HarnessWalkScreen({
    required this.harnessWalk,
    super.key,
  });

  final HarnessWalkService harnessWalk;

  @override
  State<HarnessWalkScreen> createState() => _HarnessWalkScreenState();
}

class _HarnessWalkScreenState extends State<HarnessWalkScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _recordWalkPoint() {
    final point = _controller.text.trim();
    if (point.isNotEmpty) {
      widget.harnessWalk.recordWalkPoint(point);
      _controller.clear();
      setState(() {});
    }
  }

  void _clearWalk() {
    widget.harnessWalk.clearWalk();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harness Walk'),
        backgroundColor: HLTokens.brandPrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Walk Points: ${widget.harnessWalk.walkCount}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Walk Point',
                hintText: 'Enter a walk point',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _recordWalkPoint(),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _recordWalkPoint,
                    child: const Text('Record Point'),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _clearWalk,
                  child: const Text('Clear'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Expanded(
              child: widget.harnessWalk.walkPoints.isEmpty
                  ? const Center(
                      child: Text('No walk points recorded yet'),
                    )
                  : ListView.builder(
                      itemCount: widget.harnessWalk.walkPoints.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(widget.harnessWalk.walkPoints[index]),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
