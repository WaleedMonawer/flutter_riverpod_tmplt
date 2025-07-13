# 🚀 قالب Flutter مع Clean Architecture و Riverpod

## 📋 وصف المشروع

هذا المشروع عبارة عن قالب شامل لتطبيق Flutter مبني على مبادئ Clean Architecture مع استخدام Riverpod لإدارة الحالة. تم تصميمه ليكون أساساً قوياً لتطبيقات الإنتاج الجاهزة مع ميزات متقدمة وممارسات برمجية مثالية.

### 🎯 الأهداف الرئيسية
- توفير بنية قابلة للتوسع والصيانة
- تطبيق مبادئ Clean Architecture بشكل صحيح
- استخدام Riverpod لإدارة الحالة بشكل فعال
- دعم التطوير السريع مع جودة عالية
- توفير ميزات جاهزة للاستخدام في التطبيقات الحقيقية
- دعم كامل للترجمة العربية والإنجليزية

## 🏗️ معمارية المشروع

### 📁 هيكل المجلدات

```
lib/
├── core/                    # المكونات الأساسية المشتركة
│   ├── analytics/          # خدمات التحليلات
│   ├── api/               # عملاء وخدمات API
│   ├── deep_linking/      # معالجة الروابط العميقة
│   ├── exceptions/        # الاستثناءات المخصصة
│   ├── http_client.dart   # إعدادات عميل HTTP
│   ├── interceptors/      # معالجات Dio
│   ├── i18n/             # التدويل (دعم اللغات)
│   ├── logger.dart        # أداة التسجيل
│   ├── network/           # فحص الاتصال بالشبكة
│   ├── persistence/       # حفظ الحالة
│   ├── providers.dart     # مزودي الخدمات العامة
│   ├── result.dart        # نمط النتيجة
│   ├── storage/           # التخزين المحلي
│   ├── theme/             # إدارة المظهر
│   └── widgets/           # العناصر القابلة لإعادة الاستخدام
├── features/              # ميزات التطبيق
│   ├── posts/            # ميزة المنشورات
│   │   ├── data/         # طبقة البيانات
│   │   │   ├── datasources/  # مصادر البيانات
│   │   │   ├── models/       # نماذج البيانات
│   │   │   └── repositories/ # تنفيذ المستودعات
│   │   ├── domain/       # طبقة المجال
│   │   │   ├── entities/     # الكيانات
│   │   │   ├── repositories/ # واجهات المستودعات
│   │   │   └── usecases/     # حالات الاستخدام
│   │   └── presentation/ # طبقة العرض
│   │       ├── controllers/  # المتحكمات
│   │       └── pages/        # الصفحات
│   ├── profile/          # ميزة الملف الشخصي
│   │   └── presentation/
│   │       ├── controllers/
│   │       └── pages/
│   ├── counter/          # ميزة العداد
│   │   └── presentation/
│   │       ├── controllers/
│   │       └── pages/
│   ├── todos/            # ميزة المهام
│   │   ├── data/
│   │   │   ├── models/
│   │   │   └── repositories/
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/
│   │       ├── controllers/
│   │       └── pages/
│   └── settings/         # ميزة الإعدادات
│       └── presentation/
│           ├── controllers/
│           └── pages/
├── l10n/                 # ملفات الترجمة
└── main.dart             # نقطة البداية
```

### 🏛️ Clean Architecture

المشروع يتبع مبادئ Clean Architecture مع فصل واضح للمسؤوليات:

#### 1. **طبقة العرض (Presentation Layer)**
- **المتحكمات (Controllers)**: إدارة حالة واجهة المستخدم
- **الصفحات (Pages)**: واجهات المستخدم
- **العناصر (Widgets)**: مكونات قابلة لإعادة الاستخدام

#### 2. **طبقة المجال (Domain Layer)**
- **الكيانات (Entities)**: نماذج البيانات الأساسية
- **واجهات المستودعات (Repository Interfaces)**: عقود الوصول للبيانات
- **حالات الاستخدام (Use Cases)**: منطق الأعمال

#### 3. **طبقة البيانات (Data Layer)**
- **مصادر البيانات (Data Sources)**: الوصول المباشر للبيانات
- **النماذج (Models)**: تمثيل البيانات الخارجية
- **تنفيذ المستودعات (Repository Implementations)**: تنفيذ واجهات المستودعات

### 🔄 إدارة الحالة مع Riverpod

#### مزودي الخدمات العامة
```dart
// مزود التخزين المحلي
final localStorageProvider = Provider<LocalStorage>((ref) => ...);

// مزود اللغة
final localeProvider = StateNotifierProvider<LocaleController, Locale>((ref) => ...);

// مزود التحليلات
final analyticsServiceProvider = Provider<AnalyticsService>((ref) => ...);

// مزود الإشعارات
final notificationServiceProvider = Provider<NotificationService>((ref) => ...);
```

#### مزودي الميزات
```dart
// مزود المنشورات
final postsControllerProvider = StateNotifierProvider<PostsController, AsyncValue<Result<List<Post>>>>((ref) => ...);

// مزود المستودع
final postRepositoryProvider = Provider((ref) => ...);

// مزود حالات الاستخدام
final getPostsUseCaseProvider = Provider<GetPosts>((ref) => ...);
```

## ✨ الميزات الرئيسية

### 🏗️ **المعمارية وإدارة الحالة**
- **Clean Architecture** مع فصل واضح للمسؤوليات
- **Riverpod** لإدارة الحالة وحقن التبعيات
- **Freezed** للفئات الثابتة
- **Result Pattern** لمعالجة الأخطاء
- **Repository Pattern** للوصول للبيانات

### 🏠 **الميزات الأساسية**
- **لوحة التحكم الرئيسية** مع بطاقات تنقل لجميع الميزات
- **إدارة الملف الشخصي** مع بيانات المستخدم والإحصائيات
- **ميزة العداد** مع عرض إدارة الحالة
- **إدارة المهام** مع عمليات CRUD
- **إدارة الإعدادات** مع التحكم في المظهر واللغة

### 🌐 **API والشبكة**
- **Dio** لطلبات HTTP مع المعالجات
- **Retrofit** لعملاء API آمنة النوع
- **التخزين المؤقت** مع التخزين المحلي
- **فحص الاتصال** بالشبكة
- **تسجيل الطلبات والاستجابات** في وضع التطوير

### 🎨 **واجهة المستخدم وتجربة المستخدم**
- **واجهة متكيفة** تدعم Material (Android/Web) و Cupertino (iOS)
- **إدارة المظهر** مع دعم الوضع الفاتح والداكن
- **تصميم متجاوب** لجميع أحجام الشاشات
- **حالات التحميل** ومعالجة الأخطاء
- **سحب للتحديث** الوظائف
- **التنقل الشبكي** في الشاشة الرئيسية

### 📊 **التحليلات والتتبع**
- **تكامل Firebase Analytics** (جاهز للتنفيذ)
- **تتبع الأحداث المخصصة**
- **تتبع عرض الشاشات**
- **تتبع الأخطاء**
- **تتبع المشتريات**

### 🔔 **الإشعارات الفورية**
- **دعم Firebase Cloud Messaging**
- **الإشعارات المحلية**
- **الاشتراك في المواضيع**
- **معالجة الرسائل في الخلفية**
- **معالجة النقر على الإشعارات**

### 🔗 **الروابط العميقة**
- **تكامل GoRouter**
- **معالجة الروابط الديناميكية**
- **التنقل القائم على المسارات**
- **تمرير المعاملات**
- **دعم الروابط العالمية**

### 🌍 **التدويل (i18n)**
- **دعم متعدد اللغات** (الإنجليزية والعربية)
- **دعم التخطيط RTL**
- **تنسيق التاريخ والوقت**
- **تنسيق الأرقام**
- **دعم الجمع**
- **ترجمة كاملة** لجميع الشاشات والميزات

### 💾 **حفظ الحالة**
- **التخزين المحلي** لحالة التطبيق
- **التسلسل JSON**
- **استعادة الحالة**
- **الحفظ التلقائي** للمظهر واللغة والمنشورات
- **إدارة الإعدادات** مع مسح البيانات

### 🧪 **الاختبار**
- **اختبارات الوحدة** مع Mockito
- **اختبارات العناصر**
- **اختبارات التكامل** جاهزة
- **تقارير تغطية الاختبار**

## 🆕 الميزات الجديدة المضافة

### 🏠 **لوحة التحكم الرئيسية**
- **التنقل الشبكي** مع بطاقات جميلة
- **الوصول السريع** لجميع ميزات التطبيق
- **التحكم في المظهر واللغة** في مكان واحد
- **تصميم متجاوب** لجميع أحجام الشاشات

### 👤 **إدارة الملف الشخصي**
- **عرض الملف الشخصي** مع الصورة والإحصائيات
- **معلومات قابلة للتعديل** (الاسم، البريد الإلكتروني)
- **إحصائيات اجتماعية** (المنشورات، المتابعون، المتابَعون)
- **حالات التحميل** ومعالجة الأخطاء

### 🔢 **ميزة العداد**
- **عرض إدارة الحالة** مع Riverpod
- **وظائف الزيادة والنقصان**
- **حالة مستمرة** عبر جلسات التطبيق
- **واجهة نظيفة** مع تصميم متكيف

### ✅ **إدارة المهام**
- **عمليات CRUD** لعناصر المهام
- **نماذج Freezed** مع تسلسل JSON
- **التخزين المحلي** لاستمرارية المهام
- **تنفيذ كامل لـ Clean Architecture**

### 🌍 **الترجمة الكاملة**
- **ترجمة عربية كاملة** لجميع الشاشات
- **دعم التخطيط RTL** للعربية
- **تبديل اللغة الديناميكي** دون إعادة تشغيل التطبيق
- **تواريخ وأرقام ونصوص مترجمة**

## 🚀 البدء السريع

### المتطلبات الأساسية
- Flutter SDK (3.7.2 أو أحدث)
- Dart SDK (3.0.0 أو أحدث)
- Android Studio / VS Code

### التثبيت

1. **استنساخ المستودع**
```bash
git clone <رابط-المستودع>
cd flutter_riverpod_tmplt
```

2. **تثبيت التبعيات**
```bash
flutter pub get
```

3. **توليد الكود**
```bash
dart run build_runner build --delete-conflicting-outputs
```

4. **تشغيل التطبيق**
```bash
flutter run
```

## 🔧 التكوين

### إعداد البيئة

1. **إنشاء ملفات البيئة**
```bash
# .env.development
API_BASE_URL=https://jsonplaceholder.typicode.com
ENABLE_ANALYTICS=false
ENABLE_NOTIFICATIONS=false

# .env.production
API_BASE_URL=https://your-api.com
ENABLE_ANALYTICS=true
ENABLE_NOTIFICATIONS=true
```

2. **تكوين Firebase** (اختياري)
```bash
# إضافة google-services.json (Android)
# إضافة GoogleService-Info.plist (iOS)
# تكوين firebase_options.dart
```

## 📱 أمثلة الاستخدام

### التنقل من لوحة التحكم الرئيسية
```dart
// التنقل إلى الميزات المختلفة من الشاشة الرئيسية
Navigator.pushNamed(context, '/posts');
Navigator.pushNamed(context, '/profile');
Navigator.pushNamed(context, '/counter');
Navigator.pushNamed(context, '/todos');
```

### إدارة الملف الشخصي
```dart
// تحميل بيانات الملف الشخصي
final profileController = ref.read(profileControllerProvider.notifier);
await profileController.loadProfile();

// تحديث الملف الشخصي
await profileController.updateProfile(
  name: 'اسم جديد',
  email: 'new@email.com',
);
```

### إدارة حالة العداد
```dart
// الوصول لحالة العداد
final counter = ref.watch(counterControllerProvider);

// الزيادة والنقصان
final controller = ref.read(counterControllerProvider.notifier);
controller.increment();
controller.decrement();
```

### إدارة المهام
```dart
// إضافة مهمة جديدة
final todoController = ref.read(todoControllerProvider.notifier);
await todoController.addTodo('مهمة جديدة');

// تبديل حالة إكمال المهمة
await todoController.toggleTodo(todoId);

// حذف المهمة
await todoController.deleteTodo(todoId);
```

### الترجمة
```dart
// الوصول للنصوص المترجمة
final l10n = AppLocalizations.of(context);
Text(l10n.homeTitle);
Text(l10n.profileTitle);
Text(l10n.counterTitle);
Text(l10n.todosTitle);

// تغيير اللغة
final localeController = ref.read(localeProvider.notifier);
localeController.toggleLocale();
```

### تتبع التحليلات
```dart
final analytics = ref.read(analyticsServiceProvider);
await analytics.logEvent('button_clicked', parameters: {'button': 'create_post'});
await analytics.logScreenView('posts_page');
```

### الإشعارات الفورية
```dart
final notifications = ref.read(notificationServiceProvider);
await notifications.requestPermission();
```

### إدارة المظهر
```dart
final themeController = ref.read(themeControllerProvider.notifier);
themeController.toggleTheme();
```

### تغيير اللغة
```dart
final localeController = ref.read(localeProvider.notifier);
localeController.toggleLocale();
```

## 🛠️ الأدوات والتقنيات المستخدمة

### إدارة الحالة
- **Riverpod**: إدارة الحالة وحقن التبعيات
- **Freezed**: إنشاء فئات ثابتة
- **JSON Serializable**: تسلسل JSON

### الشبكة والاتصال
- **Dio**: عميل HTTP متقدم
- **Retrofit**: إنشاء عملاء API آمنة النوع
- **Connectivity Plus**: فحص الاتصال بالشبكة

### التخزين
- **Shared Preferences**: التخزين المحلي البسيط
- **State Persistence**: حفظ حالة التطبيق

### التنقل
- **GoRouter**: إدارة المسارات والتنقل

### التدويل
- **Flutter Localizations**: دعم اللغات المتعددة
- **Intl**: تنسيق التواريخ والأرقام

### الاختبار
- **Mockito**: إنشاء المحاكيات للاختبار
- **Flutter Test**: إطار اختبار Flutter

## 📈 أفضل الممارسات المطبقة

### 🏗️ المعمارية
- فصل واضح للمسؤوليات
- اعتماد على الواجهات وليس التنفيذ
- قابلية الاختبار العالية
- قابلية التوسع والصيانة

### 💻 البرمجة
- استخدام Type Safety
- معالجة الأخطاء الشاملة
- تسجيل الأحداث المناسب
- كود نظيف وقابل للقراءة

### 🔒 الأمان
- عدم تخزين البيانات الحساسة في النص العادي
- التحقق من صحة المدخلات
- معالجة آمنة للشبكة

### 🎨 تجربة المستخدم
- واجهة متجاوبة ومتجاوبة
- حالات تحميل وأخطاء واضحة
- دعم الوضع المظلم
- دعم اللغات المتعددة

## 🤝 المساهمة

نرحب بالمساهمات! يرجى اتباع هذه الخطوات:

1. Fork المشروع
2. إنشاء فرع للميزة الجديدة
3. إجراء التغييرات
4. إضافة الاختبارات
5. إرسال Pull Request

## 📄 الترخيص

هذا المشروع مرخص تحت رخصة MIT. راجع ملف LICENSE للتفاصيل.

## 📞 الدعم

إذا كان لديك أي أسئلة أو تحتاج إلى مساعدة، يرجى فتح issue في المستودع أو التواصل معنا.

## 📝 التحديثات الأخيرة

### الإصدار 2.0.0 (الأحدث)
- ✨ **إضافة لوحة التحكم الرئيسية** مع التنقل الشبكي
- 👤 **إضافة إدارة الملف الشخصي** مع بيانات المستخدم والإحصائيات
- 🔢 **إضافة ميزة العداد** مع عرض إدارة الحالة
- ✅ **إضافة إدارة المهام** مع عمليات CRUD
- 🌍 **دعم الترجمة الكامل** (الإنجليزية والعربية)
- 🎨 **تحسين واجهة المستخدم** مع التصميم المتكيف
- 🏗️ **تحسين المعمارية** مع الميزات الجديدة
- 📱 **تنقل أفضل** مع التحكم المركزي

### الإصدار 1.0.0
- 🏗️ **إعداد Clean Architecture** الأولي
- 🔄 **تنفيذ إدارة الحالة** مع Riverpod
- 📊 **ميزة المنشورات** مع تكامل API
- 🌐 **عميل API** مع Retrofit و Dio
- 💾 **حفظ الحالة** مع التخزين المحلي
- 🎨 **إدارة المظهر** مع الوضع الفاتح والداكن
- 🌍 **إعداد الترجمة الأساسي**

---

**ملاحظة**: هذا القالب مصمم ليكون أساساً قوياً لتطبيقات Flutter الإنتاجية. يمكن تخصيصه وتوسيعه حسب احتياجات مشروعك المحددة. 