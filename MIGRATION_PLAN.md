# 🔄 خطة هجرة هيكل Core

## 📋 نظرة عامة

هذا المستند يوضح خطة مفصلة لإعادة هيكلة مجلد `core` من الهيكل الحالي إلى الهيكل الجديد المحسن.

## 🎯 الأهداف

- ✅ تحسين تنظيم الكود
- ✅ تطبيق مبادئ Clean Architecture
- ✅ زيادة قابلية الصيانة والتوسع
- ✅ تحسين قابلية الاختبار
- ✅ تقليل التداخل بين المكونات

## 📊 مقارنة الهياكل

### 🔴 الهيكل الحالي (المشاكل)

```
lib/core/
├── providers/           # ✅ جيد
├── data/               # ⚠️ يحتاج تحسين
├── domain/             # ❌ غير صحيح
├── firebase/           # ⚠️ يجب دمجه
├── routing/            # ✅ جيد
├── widgets/            # ✅ جيد
├── theme/              # ✅ جيد
├── network/            # ⚠️ يجب دمجه
├── i18n/               # ✅ جيد
├── exceptions.dart     # ❌ في الجذر
├── logger.dart         # ❌ في الجذر
└── constants.dart      # ❌ في الجذر
```

### 🟢 الهيكل الجديد (المحسن)

```
lib/core/
├── common/             # 🆕 المكونات المشتركة
├── domain/             # 🆕 منطق الأعمال
├── data/               # 🆕 طبقة البيانات
├── presentation/       # 🆕 طبقة العرض
├── services/           # 🆕 الخدمات الأساسية
├── i18n/               # ✅ محسن
└── providers/          # ✅ محسن
```

## 🚀 خطة الهجرة

### المرحلة الأولى: إنشاء المجلدات الجديدة

#### 1. إنشاء مجلد `common/`

```bash
mkdir -p lib/core/common/constants
mkdir -p lib/core/common/utils
mkdir -p lib/core/common/exceptions
```

#### 2. إنشاء مجلد `presentation/`

```bash
mkdir -p lib/core/presentation/widgets/common
mkdir -p lib/core/presentation/widgets/adaptive
mkdir -p lib/core/presentation/widgets/forms
mkdir -p lib/core/presentation/theme/colors
mkdir -p lib/core/presentation/navigation
```

#### 3. إنشاء مجلد `services/`

```bash
mkdir -p lib/core/services/network
mkdir -p lib/core/services/storage
mkdir -p lib/core/services/analytics
mkdir -p lib/core/services/notifications
mkdir -p lib/core/services/deep_linking
```

#### 4. تحسين مجلد `domain/`

```bash
mkdir -p lib/core/domain/entities
mkdir -p lib/core/domain/value_objects
mkdir -p lib/core/domain/repositories
mkdir -p lib/core/domain/usecases
```

#### 5. تحسين مجلد `data/`

```bash
mkdir -p lib/core/data/datasources/remote
mkdir -p lib/core/data/datasources/local
mkdir -p lib/core/data/models
mkdir -p lib/core/data/repositories
```

### المرحلة الثانية: نقل الملفات

#### 1. نقل الملفات من الجذر

```bash
# نقل الملفات المشتركة
mv lib/core/logger.dart lib/core/common/utils/
mv lib/core/exceptions.dart lib/core/common/exceptions/app_exceptions.dart
mv lib/core/constants.dart lib/core/common/constants/app_constants.dart
```

#### 2. نقل ملفات العرض

```bash
# نقل العناصر
mv lib/core/widgets/loading_widget.dart lib/core/presentation/widgets/common/
mv lib/core/widgets/error_widget.dart lib/core/presentation/widgets/common/
mv lib/core/widgets/adaptive_*.dart lib/core/presentation/widgets/adaptive/

# نقل المظهر
mv lib/core/theme/* lib/core/presentation/theme/
```

#### 3. نقل خدمات الشبكة

```bash
# دمج خدمات الشبكة
mv lib/core/network/* lib/core/services/network/
rmdir lib/core/network
```

#### 4. نقل خدمات Firebase

```bash
# دمج خدمات Firebase
mv lib/core/firebase/analytics/* lib/core/services/analytics/
mv lib/core/firebase/notifications/* lib/core/services/notifications/
rmdir lib/core/firebase
```

#### 5. نقل التنقل

```bash
# نقل التنقل
mv lib/core/routing/* lib/core/presentation/navigation/
rmdir lib/core/routing
```

### المرحلة الثالثة: إعادة تنظيم البيانات

#### 1. تحسين مجلد `data/`

```bash
# نقل مصادر البيانات
mv lib/core/data/api/* lib/core/data/datasources/remote/
mv lib/core/data/local/* lib/core/data/datasources/local/

# إنشاء نماذج جديدة
touch lib/core/data/models/api_response_model.dart
touch lib/core/data/models/user_model.dart
touch lib/core/data/models/settings_model.dart
```

#### 2. تحسين مجلد `domain/`

```bash
# نقل الكيانات
mv lib/core/domain/entities/result.dart lib/core/common/utils/
mv lib/core/domain/entities/errors.dart lib/core/common/exceptions/

# إنشاء كيانات جديدة
touch lib/core/domain/entities/user.dart
touch lib/core/domain/entities/app_settings.dart
touch lib/core/domain/entities/app_config.dart
```

### المرحلة الرابعة: تحديث الاستيرادات

#### 1. تحديث `main.dart`

```dart
// قبل
import 'core/storage/local_storage.dart';
import 'core/providers.dart';

// بعد
import 'core/data/datasources/local/storage/local_storage.dart';
import 'core/providers/core_providers.dart';
```

#### 2. تحديث `home_page.dart`

```dart
// قبل
import '../../../../core/providers.dart';
import '../../../../core/routing/app_router.dart';

// بعد
import '../../../../core/providers/core_providers.dart';
import '../../../../core/presentation/navigation/app_router.dart';
```

#### 3. تحديث `posts_page.dart`

```dart
// قبل
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';

// بعد
import '../../../../core/presentation/widgets/common/loading_widget.dart';
import '../../../../core/presentation/widgets/common/error_widget.dart';
```

### المرحلة الخامسة: إعادة تنظيم المزودين

#### 1. تقسيم المزودين

```bash
# إنشاء ملفات مزودين منفصلة
touch lib/core/providers/core_providers.dart
touch lib/core/providers/service_providers.dart
touch lib/core/providers/repository_providers.dart
touch lib/core/providers/feature_providers.dart
```

#### 2. تنظيم المزودين

```dart
// core_providers.dart - المزودين الأساسيين
export 'package:flutter_riverpod/flutter_riverpod.dart';
export 'package:flutter/material.dart';

// service_providers.dart - مزودي الخدمات
export '../services/network/network_info.dart';
export '../services/storage/local_storage.dart';
export '../services/analytics/analytics_service.dart';

// repository_providers.dart - مزودي المستودعات
export '../data/repositories/auth_repository_impl.dart';
export '../data/repositories/storage_repository_impl.dart';

// feature_providers.dart - مزودي الميزات
export '../presentation/theme/theme_controller.dart';
export '../i18n/locale_controller.dart';
```

## 📝 ملفات جديدة مطلوبة

### 1. ملفات الثوابت

```dart
// lib/core/common/constants/app_constants.dart
class AppConstants {
  static const String appName = 'Clean Architecture Riverpod';
  static const String appVersion = '2.0.0';
  static const int apiTimeout = 30000;
  static const int cacheTimeout = 3600000;
}

// lib/core/common/constants/api_constants.dart
class ApiConstants {
  static const String baseUrl = 'https://api.example.com';
  static const String postsEndpoint = '/posts';
  static const String usersEndpoint = '/users';
}

// lib/core/common/constants/theme_constants.dart
class ThemeConstants {
  static const double borderRadius = 12.0;
  static const double padding = 16.0;
  static const double margin = 8.0;
}
```

### 2. ملفات الأدوات المساعدة

```dart
// lib/core/common/utils/extensions.dart
extension StringExtensions on String {
  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  bool get isValidUrl => Uri.tryParse(this)?.hasAbsolutePath ?? false;
}

extension DateTimeExtensions on DateTime {
  String get formattedDate => DateFormat('yyyy-MM-dd').format(this);
  String get formattedTime => DateFormat('HH:mm').format(this);
}

// lib/core/common/utils/helpers.dart
class Helpers {
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  
  static String generateId() => DateTime.now().millisecondsSinceEpoch.toString();
}
```

### 3. ملفات الاستثناءات

```dart
// lib/core/common/exceptions/app_exceptions.dart
abstract class AppException implements Exception {
  final String message;
  final String? code;
  
  const AppException(this.message, [this.code]);
  
  @override
  String toString() => 'AppException: $message';
}

// lib/core/common/exceptions/network_exceptions.dart
class NetworkException extends AppException {
  const NetworkException(String message, [String? code]) : super(message, code);
}

class ConnectionException extends NetworkException {
  const ConnectionException([String message = 'No internet connection']) : super(message);
}

// lib/core/common/exceptions/validation_exceptions.dart
class ValidationException extends AppException {
  final Map<String, String> errors;
  
  const ValidationException(String message, this.errors) : super(message);
}
```

## 🧪 اختبار الهجرة

### 1. اختبار الاستيرادات

```bash
# تشغيل تحليل الكود
flutter analyze

# تشغيل الاختبارات
flutter test
```

### 2. اختبار التطبيق

```bash
# تشغيل التطبيق
flutter run

# التحقق من عدم وجود أخطاء
flutter doctor
```

### 3. اختبار البناء

```bash
# بناء التطبيق
flutter build apk --debug

# بناء للويب
flutter build web
```

## ⚠️ ملاحظات مهمة

### 1. **النسخ الاحتياطية**
- احتفظ بنسخة احتياطية قبل البدء
- استخدم Git للتحكم في الإصدارات
- اختبر كل خطوة قبل الانتقال للخطوة التالية

### 2. **التدرج في الهجرة**
- لا تقم بكل التغييرات مرة واحدة
- ابدأ بالملفات الأقل استخداماً
- اختبر بعد كل مرحلة

### 3. **التوثيق**
- وثق جميع التغييرات
- حدث README files
- وضح التغييرات للفريق

## 📊 جدول زمني مقترح

| المرحلة | المدة | المهام |
|---------|-------|--------|
| المرحلة 1 | 1 يوم | إنشاء المجلدات الجديدة |
| المرحلة 2 | 2 يوم | نقل الملفات |
| المرحلة 3 | 1 يوم | إعادة تنظيم البيانات |
| المرحلة 4 | 2 يوم | تحديث الاستيرادات |
| المرحلة 5 | 1 يوم | إعادة تنظيم المزودين |
| الاختبار | 1 يوم | اختبار شامل |

**المجموع: 8 أيام عمل**

## 🎯 النتائج المتوقعة

### ✅ **الفوائد المباشرة**

- **تنظيم أفضل**: هيكل واضح ومنطقي
- **صيانة أسهل**: ملفات في أماكنها الصحيحة
- **فهم أسرع**: فريق العمل يفهم الهيكل بسهولة
- **تطوير أسرع**: إضافة ميزات جديدة أسهل

### 🚀 **الفوائد طويلة المدى**

- **قابلية التوسع**: هيكل يدعم النمو
- **جودة أعلى**: ممارسات برمجية أفضل
- **تعاون أفضل**: فريق العمل أكثر إنتاجية
- **أخطاء أقل**: تنظيم أفضل يقلل من الأخطاء

---

**ملاحظة**: هذه الخطة قابلة للتعديل حسب احتياجات المشروع والوقت المتاح. 