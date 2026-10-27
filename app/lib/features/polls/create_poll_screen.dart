import 'package:flutter/material.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _questionController = TextEditingController();
  final _deadlineController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _questionController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  Future<void> _submitPoll() async {
    if (_questionController.text.isEmpty || _deadlineController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final state = AppScope.of(context);
      final pollId = await state.createPoll(
        question: _questionController.text,
        deadline: _deadlineController.text,
      );

      if (mounted) {
        // Navigate to add options screen
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => AddPollOptionsScreen(pollId: pollId),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating poll: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Poll'),
        backgroundColor: HlTokens.sea,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Create a weekly snack poll',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _questionController,
              decoration: const InputDecoration(
                labelText: 'Question',
                hintText: 'What snack should we order this Friday?',
                border: OutlineInputBorder(),
              ),
              enabled: !_isSubmitting,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _deadlineController,
              decoration: const InputDecoration(
                labelText: 'Deadline',
                hintText: 'Friday 12:00 PM',
                border: OutlineInputBorder(),
              ),
              enabled: !_isSubmitting,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitPoll,
              style: ElevatedButton.styleFrom(
                backgroundColor: HlTokens.sea,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Create Poll', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}

class AddPollOptionsScreen extends StatefulWidget {
  const AddPollOptionsScreen({super.key, required this.pollId});

  final String pollId;

  @override
  State<AddPollOptionsScreen> createState() => _AddPollOptionsScreenState();
}

class _AddPollOptionsScreenState extends State<AddPollOptionsScreen> {
  final _optionController = TextEditingController();
  final List<String> _addedOptions = [];
  bool _isAdding = false;

  @override
  void dispose() {
    _optionController.dispose();
    super.dispose();
  }

  Future<void> _addOption() async {
    if (_optionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter an option')),
      );
      return;
    }

    setState(() => _isAdding = true);

    try {
      final state = AppScope.of(context);
      await state.addPollOption(
        pollId: widget.pollId,
        text: _optionController.text,
      );

      setState(() {
        _addedOptions.add(_optionController.text);
        _optionController.clear();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Option added')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding option: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    }
  }

  void _finish() {
    if (_addedOptions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one option')),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Poll created successfully!')),
    );
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Poll Options'),
        backgroundColor: HlTokens.sea,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Add options to your poll',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            if (_addedOptions.isNotEmpty) ...[
              const Text(
                'Added options:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              ..._addedOptions.map((option) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: HlCard(
                      child: Text(option),
                    ),
                  )),
              const SizedBox(height: 16),
            ],
            TextField(
              controller: _optionController,
              decoration: const InputDecoration(
                labelText: 'Option',
                hintText: 'Pizza',
                border: OutlineInputBorder(),
              ),
              enabled: !_isAdding,
              onSubmitted: (_) => _addOption(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _isAdding ? null : _addOption,
              style: ElevatedButton.styleFrom(
                backgroundColor: HlTokens.sea,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: _isAdding
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Add Option', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 16),
            OutlinedButton(
              onPressed: _addedOptions.isEmpty ? null : _finish,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(
                  color: _addedOptions.isEmpty
                      ? Colors.grey
                      : HlTokens.sea,
                ),
              ),
              child: const Text('Finish', style: TextStyle(fontSize: 16)),
            ),
          ],
        ),
      ),
    );
  }
}
