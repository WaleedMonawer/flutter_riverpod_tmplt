import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod_tmplt/features/profile/presentation/controllers/profile_state.dart';
import '../controllers/profile_controller.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load profile data when page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileControllerProvider.notifier).loadProfile();
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileState = ref.watch(profileControllerProvider);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.profile),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(profileControllerProvider.notifier).loadProfile();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Header
              _buildProfileHeader(profileState),
              const SizedBox(height: 24),
              
              // Stats Section
              _buildStatsSection(profileState, l10n),
              const SizedBox(height: 24),
              
              // Edit Profile Section
              _buildEditProfileSection(profileState, l10n),
              const SizedBox(height: 24),
              
              // Error Display
              if (profileState.error != null)
                _buildErrorWidget(profileState.error!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileState state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            CircleAvatar(
              radius: 50,
              backgroundImage: state.avatar.isNotEmpty 
                ? NetworkImage(state.avatar) 
                : null,
              child: state.avatar.isEmpty 
                ? const Icon(Icons.person, size: 50)
                : null,
            ),
            const SizedBox(height: 16),
            
            // Name
            Text(
              state.u_name.isNotEmpty ? state.u_name : 'تحميل...',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Email
            Text(
              state.email.isNotEmpty ? state.email : 'تحميل...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsSection(ProfileState state, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem(l10n.postsCount, state.postsCount.toString()),
            _buildStatItem(l10n.followersCount, state.followersCount.toString()),
            _buildStatItem(l10n.followingCount, state.followingCount.toString()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildEditProfileSection(ProfileState state, AppLocalizations l10n) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.editProfile,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            
            // Name Field
            TextField(
              controller: _nameController..text = state.u_name,
              decoration: InputDecoration(
                labelText: l10n.name,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.person),
              ),
            ),
            const SizedBox(height: 16),
            
            // Email Field
            TextField(
              controller: _emailController..text = state.email,
              decoration: InputDecoration(
                labelText: l10n.email,
                border: const OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 16),
            
            // Update Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isLoading ? null : _updateProfile,
                child: state.isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(l10n.updateProfile),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorWidget(String error) {
    return Card(
      color: Colors.red[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(Icons.error, color: Colors.red[700]),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                error,
                style: TextStyle(color: Colors.red[700]),
              ),
            ),
            IconButton(
              onPressed: () {
                ref.read(profileControllerProvider.notifier).clearError();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }

  void _updateProfile() {
    if (_nameController.text.isNotEmpty && _emailController.text.isNotEmpty) {
      ref.read(profileControllerProvider.notifier).updateProfile(
        u_name: _nameController.text,
        email: _emailController.text,
      );
    }
  }
} 