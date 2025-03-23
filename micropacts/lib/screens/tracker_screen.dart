import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import '../models/pact_model.dart';
import '../providers/pact_providers.dart';

/// Screen for tracking daily progress on a pact
class TrackerScreen extends HookConsumerWidget {
  final Pact pact;
  
  const TrackerScreen({
    Key? key,
    required this.pact,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Selected date
    final selectedDate = useState(DateTime.now());
    
    // Format dates
    final dateFormat = DateFormat('MMM d, yyyy');
    final weekdayFormat = DateFormat('EEEE');
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Track Progress'),
      ),
      body: Column(
        children: [
          // Pact details card
          Card(
            margin: const EdgeInsets.all(16),
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
                    pact.action,
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
          
          // Date selector
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    selectedDate.value = selectedDate.value.subtract(
                      const Duration(days: 1),
                    );
                  },
                ),
                Column(
                  children: [
                    Text(
                      dateFormat.format(selectedDate.value),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(
                      weekdayFormat.format(selectedDate.value),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    selectedDate.value = selectedDate.value.add(
                      const Duration(days: 1),
                    );
                  },
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
          
          // Tracking buttons
          Text(
            'Did you complete your pact today?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // No button
              ElevatedButton.icon(
                onPressed: () => _updateTracking(context, ref, selectedDate.value, false),
                icon: const Icon(Icons.close),
                label: const Text('No'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Yes button
              ElevatedButton.icon(
                onPressed: () => _updateTracking(context, ref, selectedDate.value, true),
                icon: const Icon(Icons.check),
                label: const Text('Yes'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // Current status
          _buildCurrentStatus(context, selectedDate.value),
        ],
      ),
    );
  }
  
  /// Build the current status widget
  Widget _buildCurrentStatus(BuildContext context, DateTime date) {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final isTracked = pact.trackingData.containsKey(normalizedDate);
    final isCompleted = pact.trackingData[normalizedDate] ?? false;
    
    if (!isTracked) {
      return const Text('Not tracked yet');
    }
    
    return Column(
      children: [
        Text(
          'Current Status:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Icon(
          isCompleted ? Icons.check_circle : Icons.cancel,
          color: isCompleted ? Colors.green : Colors.red,
          size: 48,
        ),
        const SizedBox(height: 8),
        Text(
          isCompleted ? 'Completed' : 'Not Completed',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: isCompleted ? Colors.green : Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
  
  /// Update tracking data
  void _updateTracking(BuildContext context, WidgetRef ref, DateTime date, bool completed) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    
    try {
      await ref.read(pactsProvider.notifier).updatePactTracking(
        pact.id,
        normalizedDate,
        completed,
      );
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Progress updated for ${DateFormat('MMM d').format(date)}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating progress: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
