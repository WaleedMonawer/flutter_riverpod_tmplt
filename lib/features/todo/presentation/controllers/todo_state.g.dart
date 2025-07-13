// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TodoState _$TodoStateFromJson(Map<String, dynamic> json) => _TodoState(
  isLoading: json['isLoading'] as bool? ?? false,
  todos:
      (json['todos'] as List<dynamic>?)
          ?.map((e) => Todo.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
  error: json['error'] as String?,
);

Map<String, dynamic> _$TodoStateToJson(_TodoState instance) =>
    <String, dynamic>{
      'isLoading': instance.isLoading,
      'todos': instance.todos.map((e) => e.toJson()).toList(),
      if (instance.error case final value?) 'error': value,
    };
