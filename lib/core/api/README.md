# API Definition Methods

## 🔥 **الطريقة الأولى: ApiService (المفضلة)**

### المميزات:
- ✅ **سهولة الفهم** - كود واضح ومباشر
- ✅ **مرونة عالية** - تحكم كامل في التعامل مع الأخطاء
- ✅ **سهولة الاختبار** - يمكن mock بسهولة
- ✅ **Result Pattern** - تعامل آمن مع النتائج
- ✅ **Logging** - تسجيل شامل للعمليات

### الاستخدام:
```dart
// تعريف API
abstract class ApiService {
  Future<Result<List<PostModel>>> getPosts();
  Future<Result<PostModel>> getPost(int id);
}

// التنفيذ
class ApiServiceImpl implements ApiService {
  final Dio _dio;
  
  @override
  Future<Result<List<PostModel>>> getPosts() async {
    try {
      final response = await _dio.get('/posts');
      final posts = (response.data as List)
          .map((json) => PostModel.fromJson(json))
          .toList();
      return Result.success(posts);
    } catch (e) {
      return Result.failure('Error: $e');
    }
  }
}

// الاستخدام مع Riverpod
final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.watch(dioProvider);
  return ApiServiceImpl(dio: dio);
});
```

## 🚀 **الطريقة الثانية: Retrofit (مثل Android)**

### المميزات:
- ✅ **Code Generation** - توليد تلقائي للكود
- ✅ **Type Safety** - أمان الأنواع
- ✅ **Annotations** - تعريف بسيط بالـ annotations
- ✅ **Query Parameters** - دعم متقدم للـ parameters

### الاستخدام:
```dart
@RestApi(baseUrl: "https://api.example.com/")
abstract class RetrofitApiClient {
  factory RetrofitApiClient(Dio dio) = _RetrofitApiClient;

  @GET("posts")
  Future<List<PostModel>> getPosts();

  @GET("posts/{id}")
  Future<PostModel> getPost(@Path("id") int id);

  @POST("posts")
  Future<PostModel> createPost(@Body() PostModel post);
}

// الاستخدام
final retrofitProvider = Provider<RetrofitApiClient>((ref) {
  final dio = ref.watch(dioProvider);
  return RetrofitApiClient(dio);
});
```

## 🔧 **الطريقة الثالثة: Dio مباشرة (الأبسط)**

### المميزات:
- ✅ **بساطة** - لا حاجة لـ code generation
- ✅ **سرعة** - تطوير سريع
- ❌ **تكرار** - كود متكرر
- ❌ **أخطاء** - احتمال أكبر للأخطاء

### الاستخدام:
```dart
class PostsApi {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://api.example.com',
  ));

  Future<List<PostModel>> getPosts() async {
    final response = await _dio.get('/posts');
    return (response.data as List)
        .map((json) => PostModel.fromJson(json))
        .toList();
  }
}
```

## 🎯 **التوصية**

**نستخدم ApiService** للأسباب التالية:

1. **وضوح الكود** - سهل القراءة والفهم
2. **مرونة عالية** - تحكم كامل في التعامل مع الأخطاء
3. **سهولة الاختبار** - يمكن mock بسهولة
4. **Result Pattern** - تعامل آمن مع النتائج
5. **Logging** - تسجيل شامل للعمليات
6. **Clean Architecture** - يتناسب مع بنية المشروع

## 📋 **مقارنة سريعة**

| الميزة | ApiService | Retrofit | Dio مباشرة |
|--------|------------|----------|-------------|
| سهولة الفهم | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |
| مرونة التعامل مع الأخطاء | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐⭐ |
| سهولة الاختبار | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐ |
| Code Generation | ❌ | ⭐⭐⭐⭐⭐ | ❌ |
| Type Safety | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| Clean Architecture | ⭐⭐⭐⭐⭐ | ⭐⭐⭐⭐ | ⭐⭐ | 