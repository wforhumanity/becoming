import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/user_model.dart';
import '../providers/service_providers.dart';

/// Screen for viewing and editing user profile
class ProfileScreen extends HookConsumerWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the current user
    final userAsync = ref.watch(currentUserProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          // Sign out button
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sign Out',
            onPressed: () => _handleSignOut(context, ref),
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            // User is not signed in
            return const Center(
              child: Text('You are not signed in.'),
            );
          }
          
          return _buildProfileContent(context, ref, user);
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }
  
  /// Build the profile content
  Widget _buildProfileContent(BuildContext context, WidgetRef ref, User user) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Profile avatar
        Center(
          child: CircleAvatar(
            radius: 50,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            backgroundImage: user.photoUrl != null ? NetworkImage(user.photoUrl!) : null,
            child: user.photoUrl == null
                ? Text(
                    user.displayName.isNotEmpty
                        ? user.displayName[0].toUpperCase()
                        : '?',
                    style: const TextStyle(fontSize: 36),
                  )
                : null,
          ),
        ),
        const SizedBox(height: 16),
        
        // Display name
        Center(
          child: Text(
            user.displayName,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
        ),
        if (user.email != null) ...[
          const SizedBox(height: 8),
          Center(
            child: Text(
              user.email!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
          ),
        ],
        const SizedBox(height: 32),
        
        // Edit profile button
        ElevatedButton.icon(
          onPressed: () => _showEditProfileDialog(context, ref, user),
          icon: const Icon(Icons.edit),
          label: const Text('Edit Profile'),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        
        // Account info section
        const Text(
          'Account Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          child: Column(
            children: [
              // Email verification status
              ListTile(
                leading: Icon(
                  user.isEmailVerified
                      ? Icons.verified_user
                      : Icons.warning_amber_rounded,
                  color: user.isEmailVerified ? Colors.green : Colors.orange,
                ),
                title: const Text('Email Verification'),
                subtitle: Text(
                  user.isEmailVerified
                      ? 'Your email is verified'
                      : 'Your email is not verified',
                ),
                trailing: user.isEmailVerified
                    ? null
                    : TextButton(
                        onPressed: () => _sendVerificationEmail(context, ref),
                        child: const Text('Verify'),
                      ),
              ),
              
              // Account ID
              ListTile(
                leading: const Icon(Icons.fingerprint),
                title: const Text('Account ID'),
                subtitle: Text(user.id),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),
        
        // Danger zone
        const Text(
          'Danger Zone',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: () => _showDeleteAccountDialog(context, ref),
          icon: const Icon(Icons.delete_forever, color: Colors.red),
          label: const Text('Delete Account', style: TextStyle(color: Colors.red)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            side: const BorderSide(color: Colors.red),
          ),
        ),
      ],
    );
  }
  
  /// Show edit profile dialog
  void _showEditProfileDialog(BuildContext context, WidgetRef ref, User user) {
    final displayNameController = TextEditingController(text: user.displayName);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: displayNameController,
              decoration: const InputDecoration(
                labelText: 'Display Name',
                border: OutlineInputBorder(),
              ),
            ),
            // TODO: Add photo URL input or image picker
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
              if (displayNameController.text.isEmpty) {
                return;
              }
              
              try {
                final authService = ref.read(authServiceProvider);
                await authService.updateProfile(
                  displayName: displayNameController.text,
                );
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error updating profile: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
  
  /// Send verification email
  void _sendVerificationEmail(BuildContext context, WidgetRef ref) {
    // TODO: Implement email verification
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Verification email sent!'),
        backgroundColor: Colors.green,
      ),
    );
  }
  
  /// Show delete account dialog
  void _showDeleteAccountDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
          'Are you sure you want to delete your account? This action cannot be undone.',
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
              try {
                final authService = ref.read(authServiceProvider);
                await authService.deleteAccount();
                
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Account deleted successfully!'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting account: $e'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  
                  Navigator.of(context).pop();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
  
  /// Handle sign out
  void _handleSignOut(BuildContext context, WidgetRef ref) async {
    try {
      final authService = ref.read(authServiceProvider);
      await authService.signOut();
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Signed out successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing out: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
