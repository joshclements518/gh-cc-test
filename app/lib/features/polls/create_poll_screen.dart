import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  final _questionController = TextEditingController();
  DateTime? _selectedDeadline;
  bool _isSubmitting = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _selectDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  Future<void> _submitForm() async {
    // Reset messages
    setState(() {
      _errorMessage = null;
      _successMessage = null;
    });

    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedDeadline == null) {
      setState(() {
        _errorMessage = 'Please select a deadline';
      });
      return;
    }

    // Check deadline is not in the past
    if (_selectedDeadline!.isBefore(DateTime.now())) {
      setState(() {
        _errorMessage = 'Deadline cannot be in the past';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _errorMessage = null;
    });

    try {
      final state = AppScope.of(context);
      final poll = await state.services.polls.createPoll(
        question: _questionController.text.trim(),
        deadline: _selectedDeadline!,
      );

      setState(() {
        _isSubmitting = false;
        _successMessage = 'Poll created successfully! ID: ${poll.id}';
        _questionController.clear();
        _selectedDeadline = null;
      });

      // Reset form
      _formKey.currentState!.reset();
    } catch (e) {
      setState(() {
        _isSubmitting = false;
        _errorMessage = 'Failed to create poll: ${e.toString()}';
      });
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SectionLabel('Poll Question'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _questionController,
                decoration: InputDecoration(
                  hintText: 'What snack should we get for Friday?',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: HlTokens.card,
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Question cannot be empty';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              const SectionLabel('Deadline'),
              const SizedBox(height: 8),
              InkWell(
                onTap: _selectDeadline,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: HlTokens.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: HlTokens.line),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today, color: HlTokens.sea),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _selectedDeadline == null
                              ? 'Select deadline date'
                              : DateFormat('EEEE, MMMM d, y').format(_selectedDeadline!),
                          style: TextStyle(
                            color: _selectedDeadline == null
                                ? HlTokens.inkSoft
                                : HlTokens.ink,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              if (_errorMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (_successMessage != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.green.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_outline, color: Colors.green.shade700),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          _successMessage!,
                          style: TextStyle(color: Colors.green.shade700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 24),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitForm,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HlTokens.sea,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    disabledBackgroundColor: HlTokens.inkSoft,
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
                      : const Text(
                          'Create Poll',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
