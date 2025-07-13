# طبقة البيانات

يحتوي هذا المجلد على تنفيذ طبقة البيانات وفقاً لمبادئ الهندسة النظيفة (Clean Architecture). يتعامل مع جميع عمليات البيانات بما في ذلك استدعاءات API والتخزين المحلي وتحويلات البيانات.

## الهيكل

```
lib/core/data/
├── models/                    # نماذج البيانات
│   ├── base/                 # النماذج الأساسية
│   │   ├── api_response.dart # نماذج استجابة API
│   │   └── error_model.dart  # نماذج معالجة الأخطاء
│   ├── user/                 # نماذج المستخدم (سيتم إنشاؤها)
│   ├── settings/             # نماذج الإعدادات (سيتم إنشاؤها)
│   └── index.dart           # تصدير النماذج
├── datasources/              # مصادر البيانات
│   ├── remote/              # المصادر البعيدة
│   │   ├── api_client.dart  # واجهة عميل API
│   │   ├── http_client.dart # تنفيذ عميل HTTP
│   │   ├── interceptors/    # معالجات HTTP
│   │   └── index.dart       # تصدير المصادر البعيدة
│   ├── local/               # المصادر المحلية
│   │   ├── storage/         # التخزين المحلي
│   │   ├── database/        # قاعدة البيانات (سيتم إنشاؤها)
│   │   └── index.dart       # تصدير المصادر المحلية
│   └── index.dart           # تصدير مصادر البيانات
├── repositories/             # تنفيذ المستودعات
│   └── index.dart           # تصدير المستودعات
└── index.dart               # تصدير طبقة البيانات
```

## المكونات

### النماذج

#### النماذج الأساسية

- **`api_response.dart`**: يوفر هياكل استجابة API متسقة
  - `ApiResponse<T>`: غلاف استجابة API عام
  - `PaginatedApiResponse<T>`: غلاف الاستجابة المقسمة
  - `PaginationInfo`: بيانات وصفية للترقيم
  - `ApiErrorResponse`: هيكل استجابة الخطأ
  - `ApiSuccessResponse<T>`: هيكل استجابة النجاح
  - `ApiMetadata`: بيانات وصفية للاستجابة

- **`error_model.dart`**: معالجة شاملة للأخطاء
  - `ErrorModel`: نموذج الخطأ الأساسي
  - `ValidationErrorModel`: أخطاء التحقق المحددة
  - `NetworkErrorModel`: أخطاء الشبكة
  - طرق التمديد لمعالجة الأخطاء

#### أمثلة الاستخدام

```dart
// استجابة API
final response = ApiResponse.success(
  data: userData,
  message: 'تم استرجاع المستخدم بنجاح',
  statusCode: 200,
);

// معالجة الأخطاء
final error = ErrorModel.networkError(
  message: 'فشل الاتصال',
  details: 'لا يوجد اتصال بالإنترنت',
);

// أخطاء التحقق
final validationError = ValidationErrorModel.fromFieldErrors({
  'email': ['تنسيق البريد الإلكتروني غير صحيح'],
  'password': ['كلمة المرور قصيرة جداً'],
});
```

### مصادر البيانات

#### المصادر البعيدة

- **`api_client.dart`**: واجهة عميل API مجردة
  - يحدد العقد لعمليات API
  - يدعم جميع طرق HTTP
  - قدرات رفع/تحميل الملفات
  - إدارة المصادقة
  - دعم المعالجات

- **`http_client.dart`**: تنفيذ عميل HTTP مبني على Dio
  - ينفذ واجهة `ApiClient`
  - معالجة تلقائية للأخطاء
  - تسجيل الطلبات/الاستجابات
  - تكوين مهلة الانتظار

- **المعالجات**: معالجة طلبات/استجابات HTTP
  - `logging_interceptor.dart`: تسجيل الطلبات/الاستجابات
  - `auth_interceptor.dart`: المصادقة (سيتم إنشاؤه)
  - `error_interceptor.dart`: معالجة الأخطاء (سيتم إنشاؤه)
  - `cache_interceptor.dart`: التخزين المؤقت (سيتم إنشاؤه)

#### المصادر المحلية

- **التخزين**: حفظ البيانات المحلية
  - `local_storage.dart`: غلاف SharedPreferences
  - `secure_storage.dart`: تخزين مشفر (سيتم إنشاؤه)
  - `cache_storage.dart`: إدارة التخزين المؤقت (سيتم إنشاؤه)

- **قاعدة البيانات**: قاعدة البيانات المحلية (سيتم تنفيذها)
  - تكامل SQLite/Drift
  - كائنات الوصول للبيانات (DAOs)
  - كيانات قاعدة البيانات

#### أمثلة الاستخدام

```dart
// عميل HTTP
final client = HttpClient(
  baseUrl: 'https://api.example.com',
  defaultHeaders: {'Content-Type': 'application/json'},
);

// طلب API
final response = await client.get<User>(
  '/users/1',
  fromJson: (json) => User.fromJson(json),
);

// التخزين المحلي
final storage = LocalStorage();
await storage.setString('user_token', token);
final token = await storage.getString('user_token');
```

### المستودعات

تنفيذ المستودعات التي تنسق بين المصادر البعيدة والمحلية.

#### المستودعات المخططة

- `auth_repository_impl.dart`: عمليات المصادقة
- `user_repository_impl.dart`: إدارة بيانات المستخدم
- `settings_repository_impl.dart`: إعدادات التطبيق
- `post_repository_impl.dart`: عمليات بيانات المنشورات

#### نمط المستودع

```dart
class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  UserRepositoryImpl(this._apiClient, this._localStorage);

  @override
  Future<Result<User>> getUser(String id) async {
    try {
      // جرب البعيد أولاً
      final response = await _apiClient.get<User>(
        '/users/$id',
        fromJson: (json) => User.fromJson(json),
      );

      if (response.isSuccess) {
        // احفظ محلياً
        await _localStorage.setString('user_$id', jsonEncode(response.data));
        return Result.success(response.data!);
      }

      // العودة للتخزين المؤقت المحلي
      final cached = await _localStorage.getString('user_$id');
      if (cached != null) {
        return Result.success(User.fromJson(jsonDecode(cached)));
      }

      return Result.failure(ErrorModel.unknownError());
    } catch (e) {
      return Result.failure(ErrorModel.fromException(e));
    }
  }
}
```

## أفضل الممارسات

### 1. معالجة الأخطاء

- استخدم دائماً `ErrorModel` لتمثيل الأخطاء المتسق
- قدم رسائل خطأ سهلة الفهم للمستخدم
- سجل معلومات خطأ مفصلة للتصحيح
- تعامل مع أخطاء الشبكة بأدب

### 2. تحويل البيانات

- حافظ على النماذج غير قابلة للتغيير
- استخدم منشئات المصانع لإنشاء الكائنات المعقدة
- نفذ التسلسل/إلغاء التسلسل الصحيح لـ JSON
- تحقق من صحة البيانات على مستوى النموذج

### 3. استراتيجية التخزين المؤقت

- نفذ نهج التخزين المؤقت أولاً لتجربة مستخدم أفضل
- استخدم استراتيجيات إلغاء صلاحية التخزين المؤقت المناسبة
- تعامل مع فشل التخزين المؤقت بأدب
- فكر في حدود حجم التخزين المؤقت

### 4. تصميم API

- استخدم تنسيقات استجابة متسقة
- نفذ الترقيم المناسب
- تعامل مع حدود المعدل
- دعم الوظائف غير المتصلة

### 5. الاختبار

- احاكي التبعيات الخارجية
- اختبر سيناريوهات الأخطاء
- تحقق من صحة تحويلات البيانات
- اختبر سلوك التخزين المؤقت

## التبعيات

- `dio`: عميل HTTP
- `shared_preferences`: التخزين المحلي
- `freezed`: فئات البيانات غير القابلة للتغيير (اختياري)
- `json_annotation`: تسلسل JSON

## التحسينات المستقبلية

1. **تكامل قاعدة البيانات**: إضافة SQLite/Drift للبيانات المحلية المعقدة
2. **طبقة التخزين المؤقت**: تنفيذ استراتيجيات تخزين مؤقت متطورة
3. **دعم عدم الاتصال**: وظائف عدم اتصال محسنة
4. **مزامنة البيانات**: مزامنة البيانات المحلية والبعيدة
5. **التحليلات**: تتبع عمليات البيانات للرؤى
6. **التشفير**: تخزين البيانات الحساسة بشكل آمن

## المساهمة

عند إضافة نماذج أو مصادر بيانات جديدة:

1. اتبع اتفاقيات التسمية الموجودة
2. أضف توثيقاً مناسباً
3. ادرج أمثلة الاستخدام
4. حدث ملفات الفهرس ذات الصلة
5. أضف اختبارات للوظائف الجديدة
6. فكر في التوافق مع الإصدارات السابقة 