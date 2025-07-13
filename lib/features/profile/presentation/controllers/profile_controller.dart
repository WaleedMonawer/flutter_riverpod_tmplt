import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod_tmplt/features/profile/presentation/controllers/profile_state.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';


part 'profile_controller.g.dart';

// Controller using @riverpod annotation
@riverpod
class ProfileController extends _$ProfileController {
  @override
  ProfileState build() {
    // Initial state
    return const ProfileState();
  }

  // Load profile data
  Future<void> loadProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));
      
      // Update state with mock data
      state = state.copyWith(
        isLoading: false,
        u_name: 'أحمد محمد',
        email: 'ahmed@example.com',
        avatar: 'https://via.placeholder.com/150',
        postsCount: 25,
        followersCount: 1200,
        followingCount: 350,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تحميل البيانات: $e',
      );
    }
  }

  // Update profile
  Future<void> updateProfile({
    required String u_name,
    required String email,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      state = state.copyWith(
        isLoading: false,
        u_name: u_name,
        email: email,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'فشل في تحديث البيانات: $e',
      );
    }
  }

  // Clear error
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers for easy access
@riverpod
Future<void> loadProfileAction(Ref ref) async {
  final controller = ref.read(profileControllerProvider.notifier);
  await controller.loadProfile();
}

@riverpod
Future<void> updateProfileAction(
  Ref ref, {
  required String u_name,
  required String email,
}) async {
  final controller = ref.read(profileControllerProvider.notifier);
  await controller.updateProfile(u_name: u_name, email: email);
} 