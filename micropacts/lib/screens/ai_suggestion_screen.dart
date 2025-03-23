import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/pact_model.dart';
import '../providers/ai_providers.dart';
import '../providers/pact_providers.dart';

/// Screen for AI-generated pact suggestions
class AISuggestionScreen extends HookConsumerWidget {
  const AISuggestionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the suggestions provider
    final suggestionsAsync = ref.watch(pactSuggestionsProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Suggestions'),
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.refresh(pactSuggestionsProvider.future),
        child: suggestionsAsync.when(
          data: (suggestions) => _buildSuggestionsList(context, ref, suggestions),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading suggestions: $error',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.refresh(pactSuggestionsProvider.future),
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Build the suggestions list
  Widget _buildSuggestionsList(
    BuildContext context,
    WidgetRef ref,
    List<String> suggestions,
  ) {
    if (suggestions.isEmpty) {
      return const Center(
        child: Text('No suggestions available. Try creating some pacts first!'),
      );
    }
    
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final suggestion = suggestions[index];
        
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Suggestion ${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(suggestion),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () => _createPactFromSuggestion(context, ref, suggestion),
                      child: const Text('Use This'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  
  /// Create a pact from a suggestion
  void _createPactFromSuggestion(
    BuildContext context,
    WidgetRef ref,
    String suggestion,
  ) {
    // Extract a title from the suggestion (first sentence or first 50 chars)
    final title = suggestion.split('.').first.trim();
    final shortenedTitle = title.length > 50 ? '${title.substring(0, 47)}...' : title;
    
    // Pre-fill the form with the suggestion
    final titleController = TextEditingController(text: shortenedTitle);
    final purposeController = TextEditingController();
    final actionController = TextEditingController(text: suggestion);
    
    // Duration state
    final duration = useState(7); // Default to 7 days
    
    // Form key for validation
    final formKey = GlobalKey<FormState>();
    
    // Show dialog to create pact
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Pact from Suggestion'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Title field
                TextFormField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Title',
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
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter an action';
                    }
                    return null;
                  },
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                
                // Duration selector
                Text(
                  'Duration: ${duration.value} days',
                  style: Theme.of(context).textTheme.titleSmall,
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
              ],
            ),
          ),
        ),
        actions: [
          // Cancel button
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          
          // Create button
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                // Create pact
                final pact = Pact(
                  id: '', // Will be generated by the service
                  title: titleController.text,
                  purpose: purposeController.text,
                  action: actionController.text,
                  startDate: DateTime.now(),
                  endDate: DateTime.now().add(Duration(days: duration.value)),
                  trackingData: {},
                  reflection: null,
                );
                
                // Add pact
                ref.read(pactsProvider.notifier).addPact(pact);
                
                // Show success message
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pact created successfully!'),
                    backgroundColor: Colors.green,
                  ),
                );
                
                // Close dialog and screen
                Navigator.of(context).pop(); // Close dialog
                Navigator.of(context).pop(); // Close screen
              }
            },
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}
