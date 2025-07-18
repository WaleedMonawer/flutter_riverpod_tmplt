# الوحدة الأساسية (Core Module)

يحتوي هذا المجلد على الوظائف الأساسية لتطبيق Flutter، منظمة وفقاً لمبادئ Clean Architecture مع فصل محسن للمسؤوليات.

## 📁 الهيكل

```
lib/core/
├── common/                    # الأدوات المشتركة والثوابت والاستثناءات
│   ├── constants/            # ثوابت التطبيق
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   ├── theme_constants.dart
│   │   └── index.dart
│   ├── utils/                # فئات الأدوات المساعدة
│   │   ├── logger.dart
│   │   ├── date_utils.dart
│   │   ├── validation_utils.dart
│   │   ├── string_utils.dart
│   │   └── index.dart
│   ├── exceptions/           # فئات الاستثناءات
│   │   ├── app_exceptions.dart
│   │   ├── network_exceptions.dart
│   │   └── index.dart
│   └── index.dart
├── domain/                   # طبقة المجال (الكيانات والمستودعات وحالات الاستخدام)
│   ├── entities/            # كيانات الأعمال
│   ├── repositories/        # واجهات المستودعات
│   ├── usecases/           # حالات الاستخدام لمنطق الأعمال
│   └── value_objects/      # كائنات القيمة
├── data/                    # طبقة البيانات (النماذج ومصادر البيانات والمستودعات)
│   ├── models/             # نماذج البيانات
│   ├── datasources/        # مصادر البيانات (بعيدة/محلية)
│   └── repositories/       # تنفيذ المستودعات
├── presentation/           # طبقة العرض
│   ├── widgets/           # العناصر القابلة لإعادة الاستخدام
│   │   ├── common/        # عناصر مشتركة
│   │   └── adaptive/      # عناصر متكيفة مع المنصة
│   ├── theme/             # إعدادات المظهر
│   │   ├── colors/        # تعريفات الألوان
│   │   └── ...
│   └── navigation/        # إعدادات التنقل
├── services/              # الخدمات الأساسية
│   ├── network/           # خدمات الشبكة
│   ├── storage/           # خدمات التخزين
│   ├── analytics/         # خدمات التحليلات
│   ├── notifications/     # خدمات الإشعارات
│   └── deep_linking/      # خدمات الروابط العميقة
├── providers/             # مزودي Riverpod
├── i18n/                  # التدويل
└── README.md
```

## 🎯 التحسينات الرئيسية

### 1. **الوحدة المشتركة** (`common/`)
- **الثوابت**: ثوابت التطبيق المركزية منظمة حسب المجال
  - `app_constants.dart`: الثوابت العامة للتطبيق
  - `api_constants.dart`: الثوابت المتعلقة بـ API (URLs، النقاط النهائية، مهلة الانتظار)
  - `theme_constants.dart`: ثوابت نظام التصميم (المسافات، الألوان، الطباعة)
- **الأدوات المساعدة**: فئات الأدوات المساعدة القابلة لإعادة الاستخدام
  - `logger.dart`: وظيفة التسجيل المركزية
  - `date_utils.dart`: تنسيق التاريخ ومعالجته
  - `validation_utils.dart`: أدوات التحقق من صحة المدخلات
  - `string_utils.dart`: أدوات معالجة النصوص
- **الاستثناءات**: فئات الاستثناءات المخصصة
  - `app_exceptions.dart`: الاستثناءات العامة للتطبيق
  - `network_exceptions.dart`: الاستثناءات المتعلقة بالشبكة

### 2. **طبقة العرض** (`presentation/`)
- **العناصر**: منظمة حسب الغرض والتكيف مع المنصة
  - `common/`: عناصر مستقلة عن المنصة
  - `adaptive/`: تنفيذات خاصة بالمنصة
- **المظهر**: نظام مظهر شامل
  - `colors/`: لوحة الألوان والتعريفات
  - وحدات تحكم المظهر والإعدادات
- **التنقل**: التوجيه والتنقل المركزي

### 3. **طبقة الخدمات** (`services/`)
- **الشبكة**: عميل HTTP، المعترضات، أدوات الشبكة
- **التخزين**: التخزين المحلي، التخزين المؤقت، الاستمرارية
- **التحليلات**: تتبع الأحداث والتحليلات
- **الإشعارات**: الإشعارات الدفعية والإشعارات المحلية
- **الروابط العميقة**: معالجة URL والروابط العميقة

## 🚀 الفوائد

### **قابلية الصيانة**
- فصل واضح للمسؤوليات
- هيكل معياري
- سهولة تحديد وتعديل الكود

### **قابلية التوسع**
- هيكل قابل للتوسع
- مكونات قابلة لإعادة الاستخدام
- أنماط متسقة

### **قابلية الاختبار**
- مكونات معزولة
- جاهز لحقن التبعيات
- واجهات واضحة

### **تجربة المطور**
- تنظيم بديهي للملفات
- اتفاقيات تسمية متسقة
- توثيق شامل

## 📦 الاستخدام

### استيراد الثوابت
```dart
import 'package:flutter_riverpod_tmplt/core/common/constants/api_constants.dart';
import 'package:flutter_riverpod_tmplt/core/common/constants/theme_constants.dart';
```

### استخدام الأدوات المساعدة
```dart
import 'package:flutter_riverpod_tmplt/core/common/utils/date_utils.dart';
import 'package:flutter_riverpod_tmplt/core/common/utils/validation_utils.dart';
```

### معالجة الاستثناءات
```dart
import 'package:flutter_riverpod_tmplt/core/common/exceptions/network_exceptions.dart';
```

### استيراد الوحدة المشتركة بالكامل
```dart
import 'package:flutter_riverpod_tmplt/core/common/index.dart';
```

## 🔧 إرشادات التطوير

### إضافة ثوابت جديدة
1. إنشاء ملف جديد في `common/constants/` للثوابت الخاصة بالمجال
2. إضافة التصدير إلى `common/constants/index.dart`
3. اتباع اتفاقية التسمية: `{domain}_constants.dart`

### إضافة أدوات مساعدة جديدة
1. إنشاء ملف جديد في `common/utils/` لفئة الأداة المساعدة
2. إضافة التصدير إلى `common/utils/index.dart`
3. اتباع اتفاقية التسمية: `{purpose}_utils.dart`

### إضافة استثناءات جديدة
1. إنشاء ملف جديد في `common/exceptions/` للاستثناءات الخاصة بالمجال
2. إضافة التصدير إلى `common/exceptions/index.dart`
3. تمديد فئة `AppException` الأساسية

### تنظيم العناصر
- **العناصر المشتركة**: عناصر مستقلة عن المنصة وقابلة لإعادة الاستخدام
- **العناصر المتكيفة**: تنفيذات خاصة بالمنصة
- **عناصر الميزات**: مكونات خاصة بالميزات (في وحدات الميزات)

## 🎨 نظام التصميم

توفر ثوابت المظهر نظام تصميم شامل:
- **المسافات**: قيم متسقة للتباعد والهوامش والمسافات
- **الطباعة**: أحجام الخطوط والأوزان وارتفاعات الأسطر
- **الألوان**: لوحة الألوان الأساسية والثانوية والدلالية
- **الارتفاع**: قيم الظلال والارتفاع
- **الرسوم المتحركة**: ثوابت المدة والمنحنى

## 🔗 التنقل

يوفر نظام التنقل:
- تعريفات المسارات المركزية
- تنقل آمن النوع
- دعم الروابط العميقة
- حراس التنقل
- معالجة الأخطاء

## 📊 التحليلات والمراقبة

تتضمن طبقة الخدمات:
- تتبع الأحداث
- مراقبة الأداء
- تقارير الأخطاء
- تحليلات سلوك المستخدم

## 🔐 الأمان

تشمل ميزات الأمان:
- التحقق من صحة المدخلات
- تنظيف البيانات
- التخزين الآمن
- أمان الشبكة

## 🌐 التدويل

يوفر وحدة i18n:
- دعم متعدد اللغات
- دعم التخطيط من اليمين إلى اليسار
- المحتوى المترجم
- التكيفات الثقافية

## 📱 دعم المنصات

يدعم الهيكل:
- **iOS**: أنماط واتفاقيات iOS الأصلية
- **Android**: Material Design وأنماط Android
- **Web**: تصميم ويب متجاوب
- **Desktop**: واجهات محسنة للكمبيوتر

## 🧪 الاختبار

يدعم الهيكل:
- **اختبارات الوحدة**: اختبار المكونات المعزولة
- **اختبارات العناصر**: اختبار مكونات واجهة المستخدم
- **اختبارات التكامل**: الاختبار الشامل
- **اختبارات Golden**: اختبار الانحدار البصري

## 📈 الأداء

تشمل تحسينات الأداء:
- التحميل الكسول
- إدارة حالة فعالة
- عرض محسن
- إدارة الذاكرة

## 🔄 دليل الهجرة

إذا كنت تهاجر من الهيكل القديم:

1. **تحديث الاستيرادات**: استبدال مسارات الاستيراد القديمة بالجديدة
2. **نقل الملفات**: نقل الملفات إلى مواقعها الجديدة
3. **تحديث التبعيات**: التأكد من استيراد جميع التبعيات بشكل صحيح
4. **اختبار شامل**: التحقق من عمل جميع الوظائف بشكل صحيح

## 🤝 المساهمة

عند المساهمة في الوحدة الأساسية:

1. **اتباع الهيكل**: الحفاظ على التنظيم المحدد
2. **إضافة التوثيق**: توثيق المكونات والأدوات المساعدة الجديدة
3. **تحديث ملفات الفهرس**: إضافة التصدير للملفات الجديدة
4. **كتابة الاختبارات**: تضمين اختبارات للوظائف الجديدة
5. **اتباع الاتفاقيات**: استخدام التسمية والأنماط المتسقة

## 📚 موارد إضافية

- [أنماط هندسة Flutter](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)
- [الهندسة النظيفة](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [توثيق Riverpod](https://riverpod.dev/)
- [توثيق Freezed](https://pub.dev/packages/freezed) 