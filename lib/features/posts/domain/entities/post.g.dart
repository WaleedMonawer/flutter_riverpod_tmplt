// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Post _$PostFromJson(Map<String, dynamic> json) => _Post(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  body: json['body'] as String,
  userId: (json['userId'] as num).toInt(),
  authorName: json['authorName'] as String?,
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  isPublished: json['isPublished'] as bool? ?? false,
  viewCount: (json['viewCount'] as num?)?.toInt() ?? 0,
  likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
  commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
  tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
  imageUrl: json['imageUrl'] as String?,
  status:
      $enumDecodeNullable(_$PostStatusEnumMap, json['status']) ??
      PostStatus.draft,
);

Map<String, dynamic> _$PostToJson(_Post instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'body': instance.body,
  'userId': instance.userId,
  if (instance.authorName case final value?) 'authorName': value,
  if (instance.createdAt?.toIso8601String() case final value?)
    'createdAt': value,
  if (instance.updatedAt?.toIso8601String() case final value?)
    'updatedAt': value,
  'isPublished': instance.isPublished,
  'viewCount': instance.viewCount,
  'likeCount': instance.likeCount,
  'commentCount': instance.commentCount,
  if (instance.tags case final value?) 'tags': value,
  if (instance.imageUrl case final value?) 'imageUrl': value,
  'status': _$PostStatusEnumMap[instance.status]!,
};

const _$PostStatusEnumMap = {
  PostStatus.draft: 'draft',
  PostStatus.published: 'published',
  PostStatus.archived: 'archived',
  PostStatus.deleted: 'deleted',
};
