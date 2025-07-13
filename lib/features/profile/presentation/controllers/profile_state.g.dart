// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ProfileState _$ProfileStateFromJson(Map<String, dynamic> json) =>
    _ProfileState(
      isLoading: json['isLoading'] as bool? ?? false,
      u_name: json['u_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      avatar: json['avatar'] as String? ?? '',
      postsCount: (json['postsCount'] as num?)?.toInt() ?? 0,
      followersCount: (json['followersCount'] as num?)?.toInt() ?? 0,
      followingCount: (json['followingCount'] as num?)?.toInt() ?? 0,
      error: json['error'] as String?,
    );

Map<String, dynamic> _$ProfileStateToJson(_ProfileState instance) =>
    <String, dynamic>{
      'isLoading': instance.isLoading,
      'u_name': instance.u_name,
      'email': instance.email,
      'avatar': instance.avatar,
      'postsCount': instance.postsCount,
      'followersCount': instance.followersCount,
      'followingCount': instance.followingCount,
      if (instance.error case final value?) 'error': value,
    };
