import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Provider for the home screen title
final homeScreenTitleProvider = Provider<String>((ref) => 'Micropacts');

// Provider for a counter (as a simple state example)
final counterProvider = StateProvider<int>((ref) => 0);

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the providers to get their values
    final title = ref.watch(homeScreenTitleProvider);
    final counter = ref.watch(counterProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        elevation: 2,
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to Micropacts!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'You have pressed the button $counter times',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () => ref.read(counterProvider.notifier).state++,
              child: const Text('Increment Counter'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => ref.read(counterProvider.notifier).state++,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}

