import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/pact_model.dart';
import '../providers/ai_providers.dart';
import '../providers/pact_providers.dart';

/// Screen for reflecting on a completed pact
class ReflectionScreen extends HookConsumerWidget {
  final Pact pact;
  
  const ReflectionScreen({
    Key? key,
    required this.pact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Reflection text controller
    final reflectionController = useTextEditingController(text: pact.reflection);
    
    // Get AI-generated reflection prompts
    final promptsAsync = ref.watch(reflectionPromptsProvider(pact));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reflect'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Pact details card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pact.title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Purpose: ${pact.purpose}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Action: ${pact.action}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Duration: ${DateFormat('MMM d').format(pact.startDate)} - ${DateFormat('MMM d, yyyy').format(pact.endDate)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: pact.completionPercentage / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${pact.completionPercentage.toStringAsFixed(0)}% complete',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Reflection prompts
            Text(
              'Reflection Prompts',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            promptsAsync.when(
              data: (prompts) => Column(
                children: prompts.map((prompt) => _buildPromptCard(context, prompt)).toList(),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Text('Error loading prompts: $error'),
            ),
            
            const SizedBox(height: 24),
            
            // Reflection text field
            Text(
              'Your Reflection',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            TextField(
              controller: reflectionController,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: 'What did you learn from this experiment?',
                border: OutlineInputBorder(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Save button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _saveReflection(context, ref, reflectionController.text),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Reflection'),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build a prompt card
  Widget _buildPromptCard(BuildContext context, String prompt) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.lightbulb_outline,
              color: Theme.of(context).colorScheme.secondary,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(prompt),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Save reflection
  void _saveReflection(BuildContext context, WidgetRef ref, String reflection) async {
    if (reflection.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a reflection'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }
    
    try {
      await ref.read(pactsProvider.notifier).addReflection(pact.id, reflection);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Reflection saved successfully'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving reflection: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
