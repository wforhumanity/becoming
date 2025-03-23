import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../providers/service_providers.dart';

/// Screen for user authentication
class LoginScreen extends HookConsumerWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Form controllers
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    
    // Loading state
    final isLoading = useState(false);
    
    // Form key for validation
    final formKey = useMemoized(() => GlobalKey<FormState>());
    
    // Sign up mode
    final isSignUp = useState(false);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(isSignUp.value ? 'Create Account' : 'Sign In'),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // App logo or icon
            const SizedBox(height: 32),
            Icon(
              Icons.psychology_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            
            // App name
            Text(
              'Becoming',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            // Tagline
            Text(
              'Tiny Life Experiments',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            const SizedBox(height: 32),
            
            // Email field
            TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                hintText: 'Enter your email address',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email_outlined),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 16),
            
            // Password field
            TextFormField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'Password',
                hintText: 'Enter your password',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.lock_outlined),
              ),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                if (isSignUp.value && value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              enabled: !isLoading.value,
            ),
            const SizedBox(height: 24),
            
            // Sign in/up button
            ElevatedButton(
              onPressed: isLoading.value
                  ? null
                  : () => _handleEmailAuth(
                        context,
                        ref,
                        formKey,
                        emailController.text,
                        passwordController.text,
                        isSignUp.value,
                        isLoading,
                      ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              child: isLoading.value
                  ? const CircularProgressIndicator()
                  : Text(isSignUp.value ? 'Create Account' : 'Sign In'),
            ),
            const SizedBox(height: 16),
            
            // Toggle sign in/up mode
            TextButton(
              onPressed: isLoading.value
                  ? null
                  : () {
                      isSignUp.value = !isSignUp.value;
                    },
              child: Text(
                isSignUp.value
                    ? 'Already have an account? Sign In'
                    : 'Don\'t have an account? Sign Up',
              ),
            ),
            
            // Divider
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
            ),
            
            // Sign in with Apple button
            FutureBuilder<bool>(
              future: SignInWithApple.isAvailable(),
              builder: (context, snapshot) {
                final isAvailable = snapshot.data ?? false;
                
                if (!isAvailable) {
                  return const SizedBox.shrink();
                }
                
                return SignInWithAppleButton(
                  onPressed: isLoading.value
                      ? () {}
                      : () => _handleAppleSignIn(context, ref, isLoading),
                  style: SignInWithAppleButtonStyle.black,
                );
              },
            ),
            
            const SizedBox(height: 16),
            
            // Forgot password button
            TextButton(
              onPressed: isLoading.value
                  ? null
                  : () => _showForgotPasswordDialog(context, ref),
              child: const Text('Forgot Password?'),
            ),
          ],
        ),
      ),
    );
  }
  
  /// Handle email authentication (sign in or sign up)
  void _handleEmailAuth(
    BuildContext context,
    WidgetRef ref,
    GlobalKey<FormState> formKey,
    String email,
    String password,
    bool isSignUp,
    ValueNotifier<bool> isLoading,
  ) async {
    // Validate form
    if (!formKey.currentState!.validate()) {
      return;
    }
    
    // Set loading state
    isLoading.value = true;
    
    try {
      final authService = ref.read(authServiceProvider);
      
      if (isSignUp) {
        // Create new user
        await authService.createUserWithEmailAndPassword(email, password);
        
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created successfully!'),
              backgroundColor: Colors.green,
            ),
          );
          
          // Navigate back
          Navigator.of(context).pop();
        }
      } else {
        // Sign in existing user
        await authService.signInWithEmailAndPassword(email, password);
        
        if (context.mounted) {
          // Navigate back
          Navigator.of(context).pop();
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
  
  /// Handle Apple sign in
  void _handleAppleSignIn(
    BuildContext context,
    WidgetRef ref,
    ValueNotifier<bool> isLoading,
  ) async {
    // Set loading state
    isLoading.value = true;
    
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signInWithApple();
      
      if (context.mounted) {
        // Navigate back
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing in with Apple: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      // Reset loading state
      isLoading.value = false;
    }
  }
  
  /// Show forgot password dialog
  void _showForgotPasswordDialog(BuildContext context, WidgetRef ref) {
    final emailController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Enter your email address and we\'ll send you a link to reset your password.',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (emailController.text.isEmpty) {
                return;
              }
              
              try {
                final authService = ref.read(authServiceProvider);
                await authService.sendPasswordResetEmail(emailController.text);
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Password reset email sent!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Send Reset Link'),
          ),
        ],
      ),
    );
  }
}
