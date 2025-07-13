# 🏗️ Core Module Structure

## 📋 نظرة عامة

مجلد `core` يحتوي على جميع المكونات الأساسية المشتركة في التطبيق، منظمة حسب مبادئ Clean Architecture وأفضل الممارسات.

## 📁 الهيكل الجديد

```
lib/core/
├── 📁 common/                    # المكونات المشتركة العامة
│   ├── 📁 constants/            # الثوابت العامة
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   └── theme_constants.dart
│   ├── 📁 utils/                # الأدوات المساعدة
│   │   ├── logger.dart
│   │   ├── extensions.dart
│   │   └── helpers.dart
│   └── 📁 exceptions/           # الاستثناءات المخصصة
│       ├── app_exceptions.dart
│       ├── network_exceptions.dart
│       └── validation_exceptions.dart
│
├── 📁 domain/                    # طبقة المجال (Business Logic)
│   ├── 📁 entities/             # كيانات الأعمال
│   │   ├── user.dart
│   │   ├── app_settings.dart
│   │   └── app_config.dart
│   ├── 📁 value_objects/        # كائنات القيمة
│   │   ├── email.dart
│   │   ├── password.dart
│   │   └── url.dart
│   ├── 📁 repositories/         # واجهات المستودعات
│   │   ├── auth_repository.dart
│   │   ├── storage_repository.dart
│   │   └── analytics_repository.dart
│   └── 📁 usecases/             # حالات الاستخدام
│       ├── auth_usecases.dart
│       ├── settings_usecases.dart
│       └── analytics_usecases.dart
│
├── 📁 data/                      # طبقة البيانات
│   ├── 📁 datasources/          # مصادر البيانات
│   │   ├── 📁 remote/           # مصادر البيانات البعيدة
│   │   │   ├── api_client.dart
│   │   │   ├── firebase_client.dart
│   │   │   └── interceptors/
│   │   └── 📁 local/            # مصادر البيانات المحلية
│   │       ├── storage_service.dart
│   │       ├── cache_service.dart
│   │       └── preferences_service.dart
│   ├── 📁 models/               # نماذج البيانات
│   │   ├── user_model.dart
│   │   ├── settings_model.dart
│   │   └── api_response_model.dart
│   └── 📁 repositories/         # تنفيذ المستودعات
│       ├── auth_repository_impl.dart
│       ├── storage_repository_impl.dart
│       └── analytics_repository_impl.dart
│
├── 📁 presentation/              # طبقة العرض
│   ├── 📁 widgets/              # العناصر القابلة لإعادة الاستخدام
│   │   ├── 📁 common/           # عناصر مشتركة
│   │   │   ├── loading_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   └── empty_widget.dart
│   │   ├── 📁 adaptive/         # عناصر متكيفة
│   │   │   ├── adaptive_scaffold.dart
│   │   │   ├── adaptive_button.dart
│   │   │   └── adaptive_app_bar.dart
│   │   └── 📁 forms/            # عناصر النماذج
│   │       ├── custom_text_field.dart
│   │       └── custom_dropdown.dart
│   ├── 📁 theme/                # إدارة المظهر
│   │   ├── app_theme.dart
│   │   ├── theme_controller.dart
│   │   ├── adaptive_theme.dart
│   │   └── 📁 colors/
│   │       ├── app_colors.dart
│   │       └── semantic_colors.dart
│   └── 📁 navigation/           # إدارة التنقل
│       ├── app_router.dart
│       ├── navigation_service.dart
│       └── route_guards.dart
│
├── 📁 services/                  # الخدمات الأساسية
│   ├── 📁 network/              # خدمات الشبكة
│   │   ├── network_info.dart
│   │   ├── connectivity_service.dart
│   │   └── http_client.dart
│   ├── 📁 storage/              # خدمات التخزين
│   │   ├── local_storage.dart
│   │   ├── secure_storage.dart
│   │   └── cache_manager.dart
│   ├── 📁 analytics/            # خدمات التحليلات
│   │   ├── analytics_service.dart
│   │   ├── firebase_analytics.dart
│   │   └── event_tracker.dart
│   ├── 📁 notifications/        # خدمات الإشعارات
│   │   ├── notification_service.dart
│   │   ├── push_notifications.dart
│   │   └── local_notifications.dart
│   └── 📁 deep_linking/         # خدمات الروابط العميقة
│       ├── deep_link_service.dart
│       ├── link_handler.dart
│       └── link_parser.dart
│
├── 📁 i18n/                      # التدويل والترجمة
│   ├── app_localizations.dart
│   ├── locale_controller.dart
│   ├── 📁 formatters/           # منسقات التاريخ والأرقام
│   │   ├── date_formatter.dart
│   │   ├── number_formatter.dart
│   │   └── currency_formatter.dart
│   └── 📁 validators/           # مدققات النصوص
│       ├── text_validator.dart
│       └── input_validator.dart
│
└── 📁 providers/                 # مزودي Riverpod
    ├── 📁 core_providers.dart    # المزودين الأساسيين
    ├── 📁 service_providers.dart # مزودي الخدمات
    ├── 📁 repository_providers.dart # مزودي المستودعات
    └── 📁 feature_providers.dart # مزودي الميزات
```

## 🎯 مبادئ التصميم

### 1. **فصل المسؤوليات (Separation of Concerns)**
- كل مجلد له مسؤولية محددة وواضحة
- عدم تداخل الوظائف بين المجلدات
- واجهات واضحة بين الطبقات

### 2. **تبعية من الداخل للخارج (Dependency Rule)**
```
presentation → domain ← data
     ↓           ↑        ↓
   services ←───┴────── providers
```

### 3. **قابلية الاختبار (Testability)**
- كل مكون قابل للاختبار بشكل منفصل
- استخدام الواجهات بدلاً من التنفيذات المباشرة
- إمكانية استبدال المكونات بسهولة

### 4. **قابلية التوسع (Scalability)**
- هيكل مرن يسمح بإضافة ميزات جديدة
- عدم الحاجة لتغيير الكود الموجود
- دعم التطوير المتوازي

## 📋 مسؤوليات كل مجلد

### 🏠 **common/**
- **constants/**: الثوابت العامة للتطبيق
- **utils/**: الأدوات المساعدة والوظائف المشتركة
- **exceptions/**: الاستثناءات المخصصة

### 🧠 **domain/**
- **entities/**: كيانات الأعمال الأساسية
- **value_objects/**: كائنات القيمة غير القابلة للتغيير
- **repositories/**: واجهات المستودعات
- **usecases/**: منطق الأعمال وحالات الاستخدام

### 💾 **data/**
- **datasources/**: مصادر البيانات (محلية وبعيدة)
- **models/**: نماذج البيانات للتبادل
- **repositories/**: تنفيذ واجهات المستودعات

### 🎨 **presentation/**
- **widgets/**: العناصر القابلة لإعادة الاستخدام
- **theme/**: إدارة المظهر والتصميم
- **navigation/**: إدارة التنقل والمسارات

### ⚙️ **services/**
- **network/**: خدمات الشبكة والاتصال
- **storage/**: خدمات التخزين المحلي
- **analytics/**: خدمات التحليلات والتتبع
- **notifications/**: خدمات الإشعارات
- **deep_linking/**: خدمات الروابط العميقة

### 🌍 **i18n/**
- إدارة اللغات والترجمة
- منسقات التاريخ والأرقام
- مدققات النصوص المدخلة

### 🔌 **providers/**
- مزودي Riverpod لجميع الخدمات
- إدارة حالة التطبيق
- حقن التبعيات

## 🚀 أفضل الممارسات

### 1. **تسمية الملفات**
```dart
// ✅ صحيح
user_repository.dart
auth_service.dart
loading_widget.dart

// ❌ خاطئ
userRepo.dart
AuthService.dart
LoadingWidget.dart
```

### 2. **تنظيم الاستيرادات**
```dart
// 1. استيرادات Flutter
import 'package:flutter/material.dart';

// 2. استيرادات الطرف الثالث
import 'package:riverpod/riverpod.dart';

// 3. استيرادات المشروع
import '../../domain/entities/user.dart';
import '../services/auth_service.dart';
```

### 3. **استخدام الواجهات**
```dart
// ✅ صحيح - استخدام الواجهة
final authRepository = ref.read<AuthRepository>(authRepositoryProvider);

// ❌ خاطئ - استخدام التنفيذ مباشرة
final authRepository = ref.read<AuthRepositoryImpl>(authRepositoryProvider);
```

### 4. **إدارة الأخطاء**
```dart
// ✅ صحيح - معالجة شاملة للأخطاء
try {
  final result = await repository.getData();
  return result.when(
    success: (data) => data,
    failure: (error) => throw AppException(error.message),
  );
} catch (e) {
  logger.error('Error fetching data: $e');
  rethrow;
}
```

## 🔄 الهجرة من الهيكل القديم

### الخطوات المطلوبة:

1. **إنشاء المجلدات الجديدة**
2. **نقل الملفات إلى مواقعها الجديدة**
3. **تحديث الاستيرادات**
4. **إعادة تنظيم المزودين**
5. **اختبار جميع الوظائف**

### مثال على النقل:

```dart
// قبل
lib/core/logger.dart
lib/core/exceptions.dart

// بعد
lib/core/common/utils/logger.dart
lib/core/common/exceptions/app_exceptions.dart
```

## 📊 مميزات الهيكل الجديد

### ✅ **المميزات**

- **وضوح المسؤوليات**: كل مجلد له دور محدد
- **سهولة الصيانة**: تنظيم منطقي للملفات
- **قابلية الاختبار**: فصل واضح للمكونات
- **قابلية التوسع**: هيكل مرن للنمو
- **إعادة الاستخدام**: مكونات قابلة لإعادة الاستخدام
- **أداء أفضل**: تحميل محسن للمكونات

### 🎯 **الفوائد**

- **تطوير أسرع**: فهم أسهل للكود
- **أخطاء أقل**: تنظيم أفضل يقلل من الأخطاء
- **تعاون أفضل**: فريق العمل يفهم الهيكل بسهولة
- **جودة أعلى**: ممارسات برمجية أفضل

---

**ملاحظة**: هذا الهيكل مصمم ليكون أساساً قوياً وقابلاً للتوسع لتطبيقات Flutter الكبيرة والمتوسطة. 