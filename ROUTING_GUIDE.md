# 🧭 دليل نظام التنقل - Navigation System Guide

## 📋 نظرة عامة

تم تحديث نظام التنقل في المشروع لاستخدام **GoRouter** بدلاً من `Navigator.push` التقليدي، مما يوفر:

- ✅ **إدارة مركزية للمسارات** مع تعريف واضح
- ✅ **دعم Deep Linking** والروابط العميقة
- ✅ **إدارة حالة التنقل** مع حفظ التاريخ
- ✅ **Navigation Guards** لحماية المسارات
- ✅ **انتقالات مخصصة** بين الشاشات
- ✅ **معالجة الأخطاء** وصفحة 404
- ✅ **سهولة الاستخدام** مع NavigationService

## 🏗️ البنية الجديدة

### 📁 ملفات التنقل

```
lib/core/routing/
├── app_router.dart          # تعريف المسارات الرئيسي
└── navigation_service.dart  # خدمة التنقل المساعدة
```

### 🔗 تعريف المسارات

```dart
class AppRoutes {
  static const String home = '/';
  static const String posts = '/posts';
  static const String createPost = '/posts/create';
  static const String postDetails = '/posts/:id';
  static const String profile = '/profile';
  static const String counter = '/counter';
  static const String todos = '/todos';
  static const String settings = '/settings';
  static const String notFound = '/404';
}
```

### 📱 المسارات المتاحة

| المسار | الوصف | المثال |
|--------|-------|--------|
| `/` | الشاشة الرئيسية | `context.go('/')` |
| `/posts` | قائمة المنشورات | `context.go('/posts')` |
| `/posts/create` | إنشاء منشور جديد | `context.go('/posts/create')` |
| `/posts/:id` | تفاصيل المنشور | `context.go('/posts/123')` |
| `/profile` | الملف الشخصي | `context.go('/profile')` |
| `/counter` | العداد | `context.go('/counter')` |
| `/todos` | المهام | `context.go('/todos')` |
| `/settings` | الإعدادات | `context.go('/settings')` |

## 🚀 كيفية الاستخدام

### 1. التنقل الأساسي

```dart
// الانتقال إلى صفحة
context.go('/posts');

// الانتقال مع معاملات
context.go('/posts/123');

// الانتقال مع استبدال التاريخ
context.goNamed('posts');
```

### 2. استخدام NavigationService

```dart
// الانتقال إلى الشاشة الرئيسية
NavigationService.goToHome(context);

// الانتقال إلى المنشورات
NavigationService.goToPosts(context);

// الانتقال إلى تفاصيل منشور
NavigationService.goToPostDetails(context, 123);

// الانتقال إلى الإعدادات
NavigationService.goToSettings(context);

// العودة للخلف
NavigationService.goBack(context);
```

### 3. التنقل مع Push (للنوافذ المنبثقة)

```dart
// فتح صفحة كـ modal
context.push('/posts/create');

// أو باستخدام NavigationService
NavigationService.pushToCreatePost(context);
```

## 🔧 التكوين في main.dart

```dart
class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    
    return MaterialApp.router(
      routerConfig: router,
      // ... باقي الإعدادات
    );
  }
}
```

## 🛡️ Navigation Guards

### التحقق من المصادقة

```dart
static String? _handleRedirect(BuildContext context, GoRouterState state, Ref ref) {
  // التحقق من تسجيل الدخول
  final isAuthenticated = ref.read(authProvider).isAuthenticated;
  if (!isAuthenticated && state.matchedLocation != '/login') {
    return '/login';
  }
  
  // التحقق من الصلاحيات
  if (state.matchedLocation.startsWith('/admin') && !ref.read(userProvider).isAdmin) {
    return '/unauthorized';
  }
  
  return null; // لا يوجد إعادة توجيه
}
```

## 🔗 Deep Linking

### دعم الروابط العميقة

```dart
// رابط لمنشور محدد
myapp://post?id=123

// رابط للمستخدم
myapp://user?id=456

// رابط للإعدادات
myapp://settings
```

### معالجة الروابط

```dart
final deepLink = ref.read(deepLinkServiceProvider);
deepLink.navigateToPost(123);
deepLink.navigateToUser(456);
deepLink.navigateToSettings();
```

## 🎨 الانتقالات المخصصة

### إضافة انتقالات مخصصة

```dart
GoRoute(
  path: '/profile',
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: const ProfilePage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  ),
),
```

## 🚨 معالجة الأخطاء

### صفحة 404 مخصصة

```dart
GoRoute(
  path: '/404',
  builder: (context, state) => _buildNotFoundPage(context, state),
),
```

### معالج الأخطاء العام

```dart
GoRouter(
  errorBuilder: (context, state) => _buildErrorPage(context, state),
  // ...
)
```

## 📱 أمثلة عملية

### 1. التنقل من الشاشة الرئيسية

```dart
// في HomePage
NavigationItem(
  title: l10n.posts,
  subtitle: l10n.postsManagement,
  icon: Icons.article,
  color: Colors.blue,
  onTap: () => NavigationService.goToPosts(context),
),
```

### 2. التنقل من قائمة المنشورات

```dart
// في PostsPage
FloatingActionButton(
  onPressed: () => NavigationService.pushToCreatePost(context),
  child: const Icon(Icons.add),
),
```

### 3. التنقل من الإعدادات

```dart
// في SettingsPage
ListTile(
  title: Text(l10n.profile),
  onTap: () => NavigationService.goToProfile(context),
),
```

## 🔄 التحديث من النظام القديم

### قبل التحديث (Navigator.push)

```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const PostsPage(),
  ),
);
```

### بعد التحديث (GoRouter)

```dart
// الطريقة الأولى
context.go('/posts');

// الطريقة الثانية
NavigationService.goToPosts(context);

// الطريقة الثالثة
context.goNamed('posts');
```

## 📊 مميزات النظام الجديد

### ✅ المميزات

- **إدارة مركزية**: جميع المسارات معرفة في مكان واحد
- **Type Safety**: أمان النوع في المسارات والمعاملات
- **Deep Linking**: دعم الروابط العميقة
- **Navigation Guards**: حماية المسارات
- **Custom Transitions**: انتقالات مخصصة
- **Error Handling**: معالجة شاملة للأخطاء
- **History Management**: إدارة تاريخ التنقل
- **URL-based Navigation**: تنقل قائم على الروابط

### 🔧 قابلية التوسع

- إضافة مسارات جديدة بسهولة
- دعم المسارات المتداخلة
- إضافة معاملات ديناميكية
- دعم الانتقالات المتقدمة
- تكامل مع أنظمة المصادقة

## 🧪 الاختبار

### اختبار التنقل

```dart
testWidgets('Navigation test', (WidgetTester tester) async {
  await tester.pumpWidget(MyApp());
  
  // اختبار الانتقال إلى المنشورات
  await tester.tap(find.text('Posts'));
  await tester.pumpAndSettle();
  
  expect(find.text('Posts'), findsOneWidget);
});
```

## 📝 أفضل الممارسات

1. **استخدم NavigationService**: للتنقل الموحد
2. **حدد المسارات كثوابت**: لتجنب الأخطاء
3. **أضف Navigation Guards**: لحماية المسارات
4. **عالج الأخطاء**: مع صفحات مخصصة
5. **اختبر التنقل**: للتأكد من صحة المسارات
6. **وثق المسارات**: لتسهيل الصيانة

---

**ملاحظة**: هذا النظام يوفر أساساً قوياً وقابلاً للتوسع لإدارة التنقل في تطبيقات Flutter الكبيرة. 