# 🏗️ مخطط معمارية المشروع

## 📊 نظرة عامة على المعمارية

```
┌─────────────────────────────────────────────────────────────────┐
│                        PRESENTATION LAYER                      │
├─────────────────────────────────────────────────────────────────┤
│  Controllers (Riverpod)  │  Pages  │  Widgets  │  Navigation   │
│  - PostsController       │  - Posts│  - Loading│  - GoRouter   │
│  - SettingsController    │  - Create│  - Error  │  - Deep Links │
│  - ThemeController       │  - Settings│  - Adaptive│              │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                         DOMAIN LAYER                           │
├─────────────────────────────────────────────────────────────────┤
│  Entities  │  Repository Interfaces  │  Use Cases              │
│  - Post    │  - PostRepository       │  - GetPosts             │
│  - User    │  - UserRepository       │  - CreatePost           │
│  - Settings│  - SettingsRepository   │  - UpdateSettings       │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                         DATA LAYER                             │
├─────────────────────────────────────────────────────────────────┤
│  Models  │  Repository Impl  │  Data Sources                   │
│  - Post  │  - PostRepository │  - RemoteDataSource             │
│  - User  │  - UserRepository │  - LocalDataSource              │
│  - Settings│  - SettingsRepository │  - CacheDataSource        │
└─────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────┐
│                        INFRASTRUCTURE                          │
├─────────────────────────────────────────────────────────────────┤
│  API Client  │  Local Storage  │  Network  │  Analytics       │
│  - Dio       │  - SharedPrefs  │  - Connectivity│  - Firebase   │
│  - Retrofit  │  - Hive         │  - Interceptors│  - Custom     │
│  - Interceptors│  - SQLite      │  - Caching│  - Events        │
└─────────────────────────────────────────────────────────────────┘
```

## 🔄 تدفق البيانات

### 1. **طلب البيانات (Data Fetching)**

```
User Action → Controller → UseCase → Repository → DataSource → API/Local
     │           │           │           │           │           │
     ▼           ▼           ▼           ▼           ▼           ▼
PostsPage → PostsController → GetPosts → PostRepository → RemoteDataSource → Dio
     │           │           │           │           │           │
     ▼           ▼           ▼           ▼           ▼           ▼
   Display    Update UI    Business    Data Access  HTTP Request  JSON Response
```

### 2. **حفظ البيانات (Data Persistence)**

```
User Action → Controller → UseCase → Repository → LocalDataSource → Storage
     │           │           │           │           │           │
     ▼           ▼           ▼           ▼           ▼           ▼
CreatePost → PostsController → CreatePost → PostRepository → LocalDataSource → SharedPrefs
     │           │           │           │           │           │
     ▼           ▼           ▼           ▼           ▼           ▼
   Success    Update UI    Validation  Save Data    Serialize    Persist
```

## 🏛️ تفاصيل الطبقات

### 📱 **طبقة العرض (Presentation Layer)**

#### المتحكمات (Controllers)
```dart
// PostsController - إدارة حالة المنشورات
class PostsController extends StateNotifier<AsyncValue<Result<List<Post>>>> {
  final Ref ref;
  
  PostsController(this.ref) : super(const AsyncValue.loading()) {
    loadPosts();
  }
  
  Future<void> loadPosts() async {
    state = const AsyncValue.loading();
    final result = await ref.read(getPostsProvider).call();
    state = AsyncValue.data(result);
  }
}

// SettingsController - إدارة الإعدادات
class SettingsController extends StateNotifier<SettingsState> {
  final Ref ref;
  
  SettingsController(this.ref) : super(SettingsState.initial()) {
    loadSettings();
  }
  
  Future<void> toggleTheme() async {
    // منطق تبديل المظهر
  }
}
```

#### الصفحات (Pages)
```dart
// PostsPage - عرض المنشورات
class PostsPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsState = ref.watch(postsControllerProvider);
    
    return postsState.when(
      data: (result) => result.when(
        success: (posts) => PostsListView(posts: posts),
        failure: (error) => ErrorWidget(error: error),
      ),
      loading: () => LoadingWidget(),
      error: (error, stack) => ErrorWidget(error: error),
    );
  }
}
```

### 🧠 **طبقة المجال (Domain Layer)**

#### الكيانات (Entities)
```dart
// Post Entity - نموذج البيانات الأساسي
@freezed
class Post with _$Post {
  const factory Post({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) = _Post;
}
```

#### واجهات المستودعات (Repository Interfaces)
```dart
// PostRepository Interface - عقد الوصول للبيانات
abstract class PostRepository {
  Future<Result<List<Post>>> getPosts();
  Future<Result<Post>> createPost(Post post);
  Future<Result<Post>> updatePost(Post post);
  Future<Result<void>> deletePost(int id);
}
```

#### حالات الاستخدام (Use Cases)
```dart
// GetPosts UseCase - منطق الأعمال
class GetPosts {
  final PostRepository repository;
  
  GetPosts(this.repository);
  
  Future<Result<List<Post>>> call() async {
    try {
      final result = await repository.getPosts();
      return result;
    } catch (e) {
      return Result.failure(NetworkException('فشل في جلب المنشورات'));
    }
  }
}
```

### 💾 **طبقة البيانات (Data Layer)**

#### النماذج (Models)
```dart
// PostModel - تمثيل البيانات الخارجية
@freezed
class PostModel with _$PostModel {
  const factory PostModel({
    required int id,
    required String title,
    required String body,
    required int userId,
  }) = _PostModel;
  
  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
      
  // تحويل إلى Entity
  Post toEntity() => Post(
    id: id,
    title: title,
    body: body,
    userId: userId,
  );
}
```

#### تنفيذ المستودعات (Repository Implementations)
```dart
// PostRepositoryImpl - تنفيذ واجهة المستودع
class PostRepositoryImpl implements PostRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;
  
  PostRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });
  
  @override
  Future<Result<List<Post>>> getPosts() async {
    try {
      // محاولة جلب البيانات من الشبكة
      final remoteResult = await remoteDataSource.getPosts();
      if (remoteResult.isSuccess) {
        // حفظ البيانات محلياً
        await localDataSource.cachePosts(remoteResult.data!);
        return Result.success(remoteResult.data!.map((e) => e.toEntity()).toList());
      }
      
      // إذا فشل الاتصال، جلب البيانات المحلية
      final localResult = await localDataSource.getPosts();
      if (localResult.isSuccess) {
        return Result.success(localResult.data!.map((e) => e.toEntity()).toList());
      }
      
      return Result.failure(NetworkException('لا توجد بيانات متاحة'));
    } catch (e) {
      return Result.failure(NetworkException(e.toString()));
    }
  }
}
```

#### مصادر البيانات (Data Sources)
```dart
// PostsRemoteDataSource - الوصول للبيانات الخارجية
abstract class PostsRemoteDataSource {
  Future<Result<List<PostModel>>> getPosts();
  Future<Result<PostModel>> createPost(PostModel post);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final ApiService apiService;
  
  PostsRemoteDataSourceImpl({required this.apiService});
  
  @override
  Future<Result<List<PostModel>>> getPosts() async {
    try {
      final response = await apiService.getPosts();
      return Result.success(response);
    } catch (e) {
      return Result.failure(NetworkException(e.toString()));
    }
  }
}

// PostsLocalDataSource - الوصول للبيانات المحلية
abstract class PostsLocalDataSource {
  Future<Result<List<PostModel>>> getPosts();
  Future<Result<void>> cachePosts(List<PostModel> posts);
}

class PostsLocalDataSourceImpl implements PostsLocalDataSource {
  final LocalStorage localStorage;
  
  PostsLocalDataSourceImpl(this.localStorage);
  
  @override
  Future<Result<List<PostModel>>> getPosts() async {
    try {
      final jsonList = await localStorage.getList('posts');
      final posts = jsonList.map((json) => PostModel.fromJson(json)).toList();
      return Result.success(posts);
    } catch (e) {
      return Result.failure(CacheException(e.toString()));
    }
  }
}
```

## 🔧 البنية التحتية (Infrastructure)

### 🌐 **خدمات الشبكة**
```dart
// ApiService - خدمة API
@RestApi()
abstract class ApiService {
  factory ApiService(Dio dio, {String baseUrl}) = _ApiService;
  
  @GET('/posts')
  Future<List<PostModel>> getPosts();
  
  @POST('/posts')
  Future<PostModel> createPost(@Body() PostModel post);
}

// HttpClient - إعداد عميل HTTP
class HttpClient {
  static Dio? _dio;
  
  static void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://jsonplaceholder.typicode.com',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
    ));
    
    _dio!.interceptors.add(LoggingInterceptor());
    _dio!.interceptors.add(CacheInterceptor());
  }
}
```

### 💾 **خدمات التخزين**
```dart
// LocalStorage - واجهة التخزين المحلي
abstract class LocalStorage {
  Future<void> saveString(String key, String value);
  Future<String?> getString(String key);
  Future<void> saveList(String key, List<Map<String, dynamic>> value);
  Future<List<Map<String, dynamic>>> getList(String key);
  Future<void> remove(String key);
  Future<void> clear();
}

// SharedPreferencesStorage - تنفيذ التخزين المحلي
class SharedPreferencesStorage implements LocalStorage {
  final SharedPreferences _prefs;
  
  SharedPreferencesStorage._(this._prefs);
  
  static Future<SharedPreferencesStorage> getInstance() async {
    final prefs = await SharedPreferences.getInstance();
    return SharedPreferencesStorage._(prefs);
  }
  
  @override
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }
  
  @override
  Future<String?> getString(String key) async {
    return _prefs.getString(key);
  }
}
```

## 🔄 إدارة الحالة مع Riverpod

### 📊 **مخطط مزودي الخدمات**
```
ProviderScope
├── Global Providers
│   ├── localStorageProvider
│   ├── localeProvider
│   ├── analyticsServiceProvider
│   ├── notificationServiceProvider
│   └── statePersistenceServiceProvider
├── Feature Providers
│   ├── postsControllerProvider
│   ├── postRepositoryProvider
│   ├── getPostsUseCaseProvider
│   └── settingsControllerProvider
└── API Providers
    ├── apiServiceProvider
    ├── dioProvider
    └── httpClientProvider
```

### 🔗 **علاقات التبعيات**
```dart
// تسلسل التبعيات
final dioProvider = Provider<Dio>((ref) => HttpClient.dio!);

final apiServiceProvider = Provider<ApiService>((ref) {
  final dio = ref.read(dioProvider);
  return ApiService(dio);
});

final postRemoteDSProvider = Provider<PostsRemoteDataSource>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return PostsRemoteDataSourceImpl(apiService: apiService);
});

final postRepositoryProvider = Provider<PostRepository>((ref) {
  final remoteDataSource = ref.read(postRemoteDSProvider);
  final localDataSource = ref.read(postLocalDSProvider);
  return PostRepositoryImpl(
    remoteDataSource: remoteDataSource,
    localDataSource: localDataSource,
  );
});

final postsControllerProvider = StateNotifierProvider<PostsController, AsyncValue<Result<List<Post>>>>((ref) {
  return PostsController(ref);
});
```

## 🎨 أنماط التصميم المستخدمة

### 1. **Repository Pattern**
- فصل منطق الوصول للبيانات
- إمكانية تبديل مصادر البيانات
- اختبار أسهل

### 2. **Result Pattern**
- معالجة موحدة للأخطاء
- نوع آمن للنتائج
- سهولة التعامل مع الحالات المختلفة

### 3. **Dependency Injection**
- حقن التبعيات عبر Riverpod
- اختبار أسهل
- فصل المسؤوليات

### 4. **Observer Pattern**
- مراقبة التغييرات في الحالة
- تحديث تلقائي للواجهة
- إدارة فعالة للحالة

### 5. **Factory Pattern**
- إنشاء الكائنات
- إدارة دورة الحياة
- تكوين مرن

## 🧪 استراتيجية الاختبار

### 📊 **هرم الاختبار**
```
    ┌─────────────┐
    │   E2E Tests │ ← اختبارات التكامل الشاملة
    └─────────────┘
           │
    ┌─────────────┐
    │ Widget Tests│ ← اختبارات واجهة المستخدم
    └─────────────┘
           │
    ┌─────────────┐
    │  Unit Tests │ ← اختبارات الوحدة
    └─────────────┘
```

### 🎯 **أنواع الاختبارات**

#### اختبارات الوحدة
```dart
// اختبار UseCase
group('GetPosts', () {
  late MockPostRepository mockRepository;
  late GetPosts useCase;
  
  setUp(() {
    mockRepository = MockPostRepository();
    useCase = GetPosts(mockRepository);
  });
  
  test('should return list of posts when repository call is successful', () async {
    // arrange
    final posts = [Post(id: 1, title: 'Test', body: 'Test', userId: 1)];
    when(mockRepository.getPosts()).thenAnswer((_) async => Result.success(posts));
    
    // act
    final result = await useCase();
    
    // assert
    expect(result.isSuccess, true);
    expect(result.data, posts);
  });
});
```

#### اختبارات العناصر
```dart
// اختبار Widget
testWidgets('PostsPage shows loading state', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        postsControllerProvider.overrideWith((ref) => MockPostsController()),
      ],
      child: MaterialApp(home: PostsPage()),
    ),
  );
  
  expect(find.byType(CircularProgressIndicator), findsOneWidget);
});
```

## 📈 مقاييس الجودة

### 🔍 **تحليل الكود**
- **Coverage**: >80% تغطية الاختبارات
- **Complexity**: <10 تعقيد دوراني
- **Duplication**: <3% تكرار الكود
- **Maintainability**: A+ قابلية الصيانة

### 🚀 **الأداء**
- **Startup Time**: <3 ثواني وقت البدء
- **Memory Usage**: <100MB استخدام الذاكرة
- **Network Calls**: تحسين طلبات الشبكة
- **Caching**: تخزين مؤقت فعال

### 🔒 **الأمان**
- **Input Validation**: التحقق من المدخلات
- **Secure Storage**: تخزين آمن للبيانات
- **Network Security**: أمان الشبكة
- **Error Handling**: معالجة آمنة للأخطاء

---

**ملاحظة**: هذا المخطط المعماري يوفر أساساً قوياً لتطبيقات Flutter الإنتاجية مع مرونة عالية للتوسع والتخصيص. 