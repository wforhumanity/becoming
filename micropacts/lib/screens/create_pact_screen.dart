import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/pact_model.dart';
import '../providers/pact_providers.dart';

/// Screen for creating a new pact
class CreatePactScreen extends HookConsumerWidget {
  const CreatePactScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Form controllers
    final titleController = useTextEditingController();
    final purposeController = useTextEditingController();
    final actionController = useTextEditingController();
    
    // Duration state
    final duration = useState(7); // Default to 7 days
    
    // Form key for validation
    final formKey = useMemoized(() => GlobalKey<FormState>());
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create New Pact'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Title field
            TextFormField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                hintText: 'Give your experiment a name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            
            // Purpose field
            TextFormField(
              controller: purposeController,
              decoration: const InputDecoration(
                labelText: 'Purpose',
                hintText: 'Why are you doing this experiment?',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a purpose';
                }
                return null;
              },
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            
            // Action field
            TextFormField(
              controller: actionController,
              decoration: const InputDecoration(
                labelText: 'Action',
                hintText: 'What specific action will you take?',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an action';
                }
                return null;
              },
              maxLines: 2,
            ),
            const SizedBox(height: 24),
            
            // Duration selector
            Text(
              'Duration: ${duration.value} days',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Slider(
              value: duration.value.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              label: '${duration.value} days',
              onChanged: (value) {
                duration.value = value.toInt();
              },
            ),
            const SizedBox(height: 32),
            
            // Create button
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  _createPact(
                    context,
                    ref,
                    titleController.text,
                    purposeController.text,
                    actionController.text,
                    duration.value,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: const Text('Create Pact'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Create a new pact
  void _createPact(
    BuildContext context,
    WidgetRef ref,
    String title,
    String purpose,
    String action,
    int durationDays,
  ) async {
    // Create start and end dates
    final startDate = DateTime.now();
    final endDate = startDate.add(Duration(days: durationDays));
    
    // Create pact
    final pact = Pact(
      id: '', // Will be generated by the service
      title: title,
      purpose: purpose,
      action: action,
      startDate: startDate,
      endDate: endDate,
      trackingData: {},
      reflection: null,
    );
    
    try {
      // Add pact
      await ref.read(pactsProvider.notifier).addPact(pact);
      
      // Show success message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Pact created successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back
        Navigator.of(context).pop();
      }
    } catch (e) {
      // Show error message
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error creating pact: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
