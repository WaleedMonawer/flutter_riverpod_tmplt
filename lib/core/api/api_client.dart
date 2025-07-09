import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../features/posts/data/models/post_model.dart';

part 'api_client.g.dart';

@RestApi(baseUrl: "https://jsonplaceholder.typicode.com/")
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

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