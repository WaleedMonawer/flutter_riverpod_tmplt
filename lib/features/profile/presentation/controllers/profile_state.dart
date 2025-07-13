import 'package:freezed_annotation/freezed_annotation.dart';
part 'profile_state.freezed.dart';
part 'profile_state.g.dart';

@freezed
abstract class ProfileState with _$ProfileState {
  const factory ProfileState({
    @Default(false) bool isLoading,
    @Default('') String u_name,
    @Default('') String email,
    @Default('') String avatar,
    @Default(0) int postsCount,
    @Default(0) int followersCount,
    @Default(0) int followingCount,
    String? error,
  }) = _ProfileState;

  factory ProfileState.fromJson(Map<String, dynamic> json) => _$ProfileStateFromJson(json);

 
}
