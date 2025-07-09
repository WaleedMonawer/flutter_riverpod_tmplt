# دليل المساهمة في المشروع

## 🏗️ هيكلية المشروع

### Clean Architecture Layers:
- **Presentation**: UI, Controllers, Pages
- **Domain**: Entities, Use Cases, Repository Interfaces
- **Data**: Models, Data Sources, Repository Implementations
- **Core**: Shared utilities, constants, widgets

## 📝 قواعد التطوير

### 1. **Naming Conventions**
```dart
// ✅ صحيح
class UserRepository
class GetUserUseCase
class user_controller.dart

// ❌ خطأ
class userRepository
class getUserUseCase
class UserController.dart
```

### 2. **File Structure**
```
features/
└── feature_name/
    ├── data/
    │   ├── models/
    │   ├── datasources/
    │   └── repositories/
    ├── domain/
    │   ├── entities/
    │   ├── repositories/
    │   └── usecases/
    └── presentation/
        ├── controllers/
        └── pages/
```

### 3. **Testing Requirements**
- ✅ Unit tests لكل use case
- ✅ Widget tests للصفحات الرئيسية
- ✅ Integration tests للتدفقات الأساسية

### 4. **Code Quality**
- استخدم `flutter analyze` قبل الـ commit
- اتبع قواعد `flutter_lints`
- اكتب تعليقات للكود المعقد

## 🚀 خطوات إضافة ميزة جديدة

1. **إنشاء Entity** في `domain/entities/`
2. **إنشاء Repository Interface** في `domain/repositories/`
3. **إنشاء Use Cases** في `domain/usecases/`
4. **إنشاء Model** في `data/models/`
5. **إنشاء Data Source** في `data/datasources/`
6. **إنشاء Repository Implementation** في `data/repositories/`
7. **إنشاء Controller** في `presentation/controllers/`
8. **إنشاء Pages** في `presentation/pages/`
9. **كتابة الاختبارات**

## 🔧 الأدوات المطلوبة

```bash
# تشغيل الاختبارات
flutter test

# تحليل الكود
flutter analyze

# توليد الملفات
flutter pub run build_runner build

# تشغيل التطبيق
flutter run
``` 