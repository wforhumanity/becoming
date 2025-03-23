import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/pact_model.dart';
import '../providers/pact_providers.dart';
import '../screens/reflection_screen.dart';
import '../screens/tracker_screen.dart';

/// A card widget to display a pact
class PactCard extends HookConsumerWidget {
  final Pact pact;
  
  const PactCard({
    Key? key,
    required this.pact,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
              pact.title,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            
            // Purpose
            Text(
              'Purpose: ${pact.purpose}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 4),
            
            // Action
            Text(
              'Action: ${pact.action}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 12),
            
            // Progress bar
            LinearProgressIndicator(
              value: pact.completionPercentage / 100,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(
                Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 4),
            
            // Completion percentage
            Text(
              '${pact.completionPercentage.toStringAsFixed(0)}% complete',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Track button
                OutlinedButton.icon(
                  onPressed: () {
                    _trackToday(context, ref);
                  },
                  icon: const Icon(Icons.check),
                  label: const Text('Track Today'),
                ),
                
                // Reflect button (only enabled if pact is complete)
                ElevatedButton.icon(
                  onPressed: !pact.isActive && pact.reflection == null
                      ? () {
                          _addReflection(context, ref);
                        }
                      : null,
                  icon: const Icon(Icons.lightbulb_outline),
                  label: const Text('Reflect'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  /// Navigate to tracker screen
  void _trackToday(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TrackerScreen(pact: pact),
      ),
    );
  }
  
  /// Navigate to reflection screen
  void _addReflection(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ReflectionScreen(pact: pact),
      ),
    );
  }
}
