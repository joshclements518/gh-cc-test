import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class CreatePollScreen extends StatefulWidget {
  const CreatePollScreen({super.key});

  @override
  State<CreatePollScreen> createState() => _CreatePollScreenState();
}

class _CreatePollScreenState extends State<CreatePollScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController(text: 'Friday Snack Vote');
  final List<TextEditingController> _optionControllers = [
    TextEditingController(),
    TextEditingController(),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    for (var controller in _optionControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _addOption() {
    setState(() {
      _optionControllers.add(TextEditingController());
    });
  }

  void _removeOption(int index) {
    if (_optionControllers.length > 2) {
      setState(() {
        _optionControllers[index].dispose();
        _optionControllers.removeAt(index);
      });
    }
  }

  void _savePoll() {
    if (_formKey.currentState?.validate() ?? false) {
      final options = _optionControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      if (options.length < 2) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least 2 snack options')),
        );
        return;
      }

      final poll = Poll(
        id: const Uuid().v4(),
        title: _titleController.text.trim(),
        options: options,
        shareToken: _generateShareToken(),
        createdAt: DateTime.now(),
      );

      // Store poll in app state
      final state = AppScope.of(context);
      state.savePoll(poll);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Poll created! Share token: ${poll.shareToken}'),
          duration: const Duration(seconds: 4),
        ),
      );

      Navigator.of(context).pop(poll);
    }
  }

  String _generateShareToken() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = DateTime.now().millisecondsSinceEpoch;
    var token = '';
    var seed = random;
    for (var i = 0; i < 6; i++) {
      token += chars[seed % chars.length];
      seed = seed ~/ chars.length + i * 13;
    }
    return token;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HlTokens.background,
      appBar: AppBar(
        backgroundColor: HlTokens.card,
        elevation: 0,
        title: const Text(
          'Create Poll',
          style: TextStyle(color: HlTokens.ink, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: HlTokens.ink),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Form(
        key: _formKey,
        child: CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(16),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const Eyebrow('Poll Details'),
                  const SizedBox(height: 12),
                  HlCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Poll Title',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: HlTokens.inkSoft,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            hintText: 'e.g., Friday Snack Vote',
                            filled: true,
                            fillColor: HlTokens.background,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: HlTokens.line),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: HlTokens.line),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: HlTokens.sea, width: 2),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 14,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please enter a poll title';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SectionLabel('Snack Options'),
                  HlCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Add snack options for teammates to vote on',
                          style: TextStyle(
                            fontSize: 13,
                            color: HlTokens.inkSoft,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ..._buildOptionFields(),
                        const SizedBox(height: 12),
                        OutlinedButton.icon(
                          onPressed: _addOption,
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Add Option'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: HlTokens.sea,
                            side: const BorderSide(color: HlTokens.sea),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _savePoll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HlTokens.sea,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Create Poll',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildOptionFields() {
    final widgets = <Widget>[];
    for (var i = 0; i < _optionControllers.length; i++) {
      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: TextFormField(
                  controller: _optionControllers[i],
                  decoration: InputDecoration(
                    labelText: 'Option ${i + 1}',
                    hintText: 'e.g., Chips, Cookies, Fruit',
                    filled: true,
                    fillColor: HlTokens.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: HlTokens.line),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: HlTokens.line),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: HlTokens.sea, width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  validator: (value) {
                    if (i < 2 && (value == null || value.trim().isEmpty)) {
                      return 'Required';
                    }
                    return null;
                  },
                ),
              ),
              if (_optionControllers.length > 2) ...[
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _removeOption(i),
                  icon: const Icon(Icons.remove_circle_outline),
                  color: HlTokens.coral,
                ),
              ],
            ],
          ),
        ),
      );
    }
    return widgets;
  }
}
