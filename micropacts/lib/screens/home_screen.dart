import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../components/pact_card.dart';
import '../models/pact_model.dart';
import '../providers/pact_providers.dart';
import 'ai_suggestion_screen.dart';
import 'create_pact_screen.dart';

class HomeScreen extends HookConsumerWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the active pacts provider
    final activePactsAsync = ref.watch(activePactsProvider);
    
    // Selected tab index
    final selectedIndex = useState(0);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Becoming'),
        actions: [
          // AI suggestions button
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: 'AI Suggestions',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AISuggestionScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: selectedIndex.value,
        children: [
          // Active pacts tab
          _buildActivePactsTab(context, ref, activePactsAsync),
          
          // Completed pacts tab
          _buildCompletedPactsTab(context, ref),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex.value,
        onTap: (index) => selectedIndex.value = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.science_outlined),
            label: 'Active',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Completed',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePactScreen(),
            ),
          );
        },
        tooltip: 'Create Pact',
        child: const Icon(Icons.add),
      ),
    );
  }
  
  /// Build the active pacts tab
  Widget _buildActivePactsTab(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<Pact>> activePactsAsync,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(pactsProvider.notifier).loadPacts();
      },
      child: activePactsAsync.when(
        data: (pacts) {
          if (pacts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.science_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No active pacts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Create a new pact to get started',
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CreatePactScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Create Pact'),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80), // For FAB
            itemCount: pacts.length,
            itemBuilder: (context, index) {
              return PactCard(pact: pacts[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
  
  /// Build the completed pacts tab
  Widget _buildCompletedPactsTab(BuildContext context, WidgetRef ref) {
    final completedPactsAsync = ref.watch(completedPactsProvider);
    
    return RefreshIndicator(
      onRefresh: () async {
        ref.read(pactsProvider.notifier).loadPacts();
      },
      child: completedPactsAsync.when(
        data: (pacts) {
          if (pacts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No completed pacts',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Completed pacts will appear here',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.only(bottom: 80), // For FAB
            itemCount: pacts.length,
            itemBuilder: (context, index) {
              return PactCard(pact: pacts[index]);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
}
