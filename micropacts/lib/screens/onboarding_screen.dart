import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/service_providers.dart';
import 'home_screen.dart';
import 'login_screen.dart';

/// Screen for onboarding new users
class OnboardingScreen extends HookConsumerWidget {
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Page controller
    final pageController = usePageController();
    
    // Current page
    final currentPage = useState(0);
    
    // Pages
    final pages = [
      _buildWelcomePage(context),
      _buildPactFrameworkPage(context),
      _buildExamplesPage(context),
      _buildGetStartedPage(context, ref),
    ];
    
    return Scaffold(
      body: Stack(
        children: [
          // Page view
          PageView(
            controller: pageController,
            onPageChanged: (page) {
              currentPage.value = page;
            },
            children: pages,
          ),
          
          // Skip button
          Positioned(
            top: 40,
            right: 16,
            child: TextButton(
              onPressed: () => _completeOnboarding(context, ref),
              child: const Text('Skip'),
            ),
          ),
          
          // Dots indicator
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                pages.length,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: currentPage.value == index
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
                  ),
                ),
              ),
            ),
          ),
          
          // Next/Get Started button
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  if (currentPage.value < pages.length - 1) {
                    pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _completeOnboarding(context, ref);
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                ),
                child: Text(
                  currentPage.value < pages.length - 1 ? 'Next' : 'Get Started',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Build the welcome page
  Widget _buildWelcomePage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // App icon
          Icon(
            Icons.psychology_outlined,
            size: 100,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 32),
          
          // App name
          Text(
            'Welcome to Becoming',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          
          // App description
          Text(
            'Your journey to intentional living through tiny experiments',
            style: Theme.of(context).textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // App intro
          Text(
            'Becoming helps you create, track, and reflect on small experiments to build better habits and live more intentionally.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  /// Build the PACT framework page
  Widget _buildPactFrameworkPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Page title
          Text(
            'The PACT Framework',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Purposeful
          _buildPactElement(
            context,
            'P - Purposeful',
            'Each experiment has a clear purpose or intention behind it.',
            Icons.lightbulb_outline,
            Colors.amber,
          ),
          const SizedBox(height: 24),
          
          // Actionable
          _buildPactElement(
            context,
            'A - Actionable',
            'Experiments involve specific, concrete actions you can take.',
            Icons.directions_run,
            Colors.green,
          ),
          const SizedBox(height: 24),
          
          // Continuous
          _buildPactElement(
            context,
            'C - Continuous',
            'Experiments run for a set period, usually 1-4 weeks.',
            Icons.calendar_today,
            Colors.blue,
          ),
          const SizedBox(height: 24),
          
          // Trackable
          _buildPactElement(
            context,
            'T - Trackable',
            'Progress is tracked daily to build consistency and awareness.',
            Icons.trending_up,
            Colors.purple,
          ),
        ],
      ),
    );
  }
  
  /// Build a PACT element
  Widget _buildPactElement(
    BuildContext context,
    String title,
    String description,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
            size: 24,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  /// Build the examples page
  Widget _buildExamplesPage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Page title
          Text(
            'Example Experiments',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Example 1
          _buildExampleCard(
            context,
            'Morning Meditation',
            'Purpose: Reduce stress and improve focus',
            'Action: Meditate for 5 minutes each morning',
            'Duration: 7 days',
            Icons.self_improvement,
            Colors.teal,
          ),
          const SizedBox(height: 16),
          
          // Example 2
          _buildExampleCard(
            context,
            'Digital Sunset',
            'Purpose: Improve sleep quality',
            'Action: No screens 1 hour before bed',
            'Duration: 14 days',
            Icons.nightlight_round,
            Colors.indigo,
          ),
          const SizedBox(height: 16),
          
          // Example 3
          _buildExampleCard(
            context,
            'Gratitude Practice',
            'Purpose: Cultivate positive mindset',
            'Action: Write 3 things I\'m grateful for daily',
            'Duration: 21 days',
            Icons.favorite_border,
            Colors.pink,
          ),
        ],
      ),
    );
  }
  
  /// Build an example card
  Widget _buildExampleCard(
    BuildContext context,
    String title,
    String purpose,
    String action,
    String duration,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: color,
                size: 32,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(purpose, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(action, style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: 4),
                  Text(duration, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Build the get started page
  Widget _buildGetStartedPage(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Page title
          Text(
            'Ready to Begin?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Get started description
          Text(
            'You can start using Becoming right away, or create an account to sync your experiments across devices.',
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          
          // Sign in button
          ElevatedButton.icon(
            onPressed: () {
              _completeOnboarding(context, ref);
              
              // Navigate to login screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const LoginScreen(),
                ),
              );
            },
            icon: const Icon(Icons.login),
            label: const Text('Sign In or Create Account'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Continue without account button
          OutlinedButton.icon(
            onPressed: () {
              _completeOnboarding(context, ref);
              
              // Navigate to home screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
              );
            },
            icon: const Icon(Icons.arrow_forward),
            label: const Text('Continue Without Account'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
                vertical: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  /// Complete onboarding
  void _completeOnboarding(BuildContext context, WidgetRef ref) async {
    // Save onboarding completion status
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setBool('onboarding_completed', true);
    
    if (context.mounted) {
      // Navigate to home screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(),
        ),
      );
    }
  }
}
