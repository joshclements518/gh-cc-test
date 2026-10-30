import 'package:flutter/material.dart';
import '../../data/models.dart';
import '../../state/app_state.dart';
import '../../theme/tokens.dart';
import '../../ui/widgets/hl_widgets.dart';

class PollCreateScreen extends StatefulWidget {
  const PollCreateScreen({super.key});

  @override
  State<PollCreateScreen> createState() => _PollCreateScreenState();
}

class _PollCreateScreenState extends State<PollCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  DateTime? _selectedDeadline;
  Poll? _createdPoll;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _questionController.dispose();
    super.dispose();
  }

  Future<void> _pickDeadline() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 7)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        _selectedDeadline = picked;
      });
    }
  }

  Future<void> _submitPoll() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDeadline == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a deadline')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final state = AppScope.of(context);
      final poll = state.services.polls.createPoll(
        question: _questionController.text,
        deadline: _selectedDeadline!,
      );

      setState(() {
        _createdPoll = poll;
        _isSubmitting = false;
      });
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating poll: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_createdPoll != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Poll Created'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HlCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('SUCCESS'),
                    const SizedBox(height: 8),
                    const DisplayTitle('Poll Created'),
                    const SizedBox(height: 16),
                    _InfoRow('Poll ID:', _createdPoll!.pollId),
                    const SizedBox(height: 8),
                    _InfoRow('Question:', _createdPoll!.question),
                    const SizedBox(height: 8),
                    _InfoRow('Deadline:', _formatDate(_createdPoll!.deadline)),
                    const SizedBox(height: 8),
                    _InfoRow('Status:', _createdPoll!.status),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _createdPoll = null;
                      _questionController.clear();
                      _selectedDeadline = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HlTokens.sea,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Create Another Poll'),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Poll'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HlCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Eyebrow('NEW POLL'),
                    const SizedBox(height: 8),
                    const DisplayTitle('Friday Snack Vote'),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _questionController,
                      decoration: InputDecoration(
                        labelText: 'Question',
                        hintText: 'What snack should we get this Friday?',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: HlTokens.foam.withOpacity(0.3),
                      ),
                      maxLines: 2,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a question';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _pickDeadline,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: HlTokens.foam.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: HlTokens.line),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.calendar_today, color: HlTokens.sea),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Deadline',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: HlTokens.inkSoft,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    _selectedDeadline != null
                                        ? _formatDate(_selectedDeadline!)
                                        : 'Select a date',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: _selectedDeadline != null
                                          ? FontWeight.w600
                                          : FontWeight.normal,
                                      color: _selectedDeadline != null
                                          ? HlTokens.ink
                                          : HlTokens.inkSoft,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: HlTokens.inkSoft),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitPoll,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HlTokens.sea,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Create Poll',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.month}/${date.day}/${date.year}';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: HlTokens.inkSoft,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: HlTokens.ink,
            ),
          ),
        ),
      ],
    );
  }
}
