import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:flutter_riverpod_tmplt/core/common/constants/app_constants.dart';
import 'package:flutter_riverpod_tmplt/core/data/models/post_model.dart';

part 'retrofit_api_client.g.dart';

@RestApi(baseUrl: AppConstants.baseUrl)
abstract class RetrofitApiClient {
  factory RetrofitApiClient(Dio dio, {String baseUrl}) = _RetrofitApiClient;

  @GET("posts")
  Future<List<PostModel>> getPosts();

  @GET("posts/{id}")
  Future<PostModel> getPost(@Path("id") int id);

  @POST("posts")
  Future<PostModel> createPost(@Body() PostModel post);

  @PUT("posts/{id}")
  Future<PostModel> updatePost(@Path("id") int id, @Body() PostModel post);

  @DELETE("posts/{id}")
  Future<void> deletePost(@Path("id") int id);

  @GET("posts")
  Future<List<PostModel>> getPostsWithQuery(@Query("userId") int userId);
} 