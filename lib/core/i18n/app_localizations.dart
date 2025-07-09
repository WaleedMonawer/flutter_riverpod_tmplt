import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract class AppLocalizations {
  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  // Common
  String get appTitle;
  String get loading;
  String get error;
  String get retry;
  String get cancel;
  String get save;
  String get delete;
  String get edit;
  String get add;
  String get search;
  String get settings;
  String get profile;
  String get logout;
  String get login;
  String get register;

  // Posts
  String get posts;
  String get post;
  String get createPost;
  String get editPost;
  String get deletePost;
  String get postTitle;
  String get postBody;
  String get postAuthor;
  String get postDate;
  String get noPosts;
  String get noPostsMessage;
  String get postCreated;
  String get postUpdated;
  String get postDeleted;
  String get postCreationFailed;
  String get postUpdateFailed;
  String get postDeletionFailed;

  // Validation
  String get requiredField;
  String get invalidEmail;
  String get invalidPassword;
  String get passwordTooShort;
  String get passwordsDoNotMatch;
  String get invalidInput;

  // Network
  String get networkError;
  String get connectionError;
  String get serverError;
  String get timeoutError;
  String get noInternetConnection;

  // Theme
  String get lightTheme;
  String get darkTheme;
  String get systemTheme;
  String get themeSettings;

  // Language
  String get language;
  String get english;
  String get arabic;
  String get languageSettings;

  // Date formatting
  String formatDate(DateTime date);
  String formatDateTime(DateTime dateTime);
  String getRelativeTime(DateTime dateTime);
}

class EnglishLocalizations extends AppLocalizations {
  @override
  String get appTitle => 'Clean Architecture Riverpod';

  @override
  String get loading => 'Loading...';

  @override
  String get error => 'Error';

  @override
  String get retry => 'Retry';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get search => 'Search';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get logout => 'Logout';

  @override
  String get login => 'Login';

  @override
  String get register => 'Register';

  @override
  String get posts => 'Posts';

  @override
  String get post => 'Post';

  @override
  String get createPost => 'Create Post';

  @override
  String get editPost => 'Edit Post';

  @override
  String get deletePost => 'Delete Post';

  @override
  String get postTitle => 'Title';

  @override
  String get postBody => 'Content';

  @override
  String get postAuthor => 'Author';

  @override
  String get postDate => 'Date';

  @override
  String get noPosts => 'No Posts';

  @override
  String get noPostsMessage => 'No posts available';

  @override
  String get postCreated => 'Post created successfully';

  @override
  String get postUpdated => 'Post updated successfully';

  @override
  String get postDeleted => 'Post deleted successfully';

  @override
  String get postCreationFailed => 'Failed to create post';

  @override
  String get postUpdateFailed => 'Failed to update post';

  @override
  String get postDeletionFailed => 'Failed to delete post';

  @override
  String get requiredField => 'This field is required';

  @override
  String get invalidEmail => 'Invalid email address';

  @override
  String get invalidPassword => 'Invalid password';

  @override
  String get passwordTooShort => 'Password is too short';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get invalidInput => 'Invalid input';

  @override
  String get networkError => 'Network error';

  @override
  String get connectionError => 'Connection error';

  @override
  String get serverError => 'Server error';

  @override
  String get timeoutError => 'Request timeout';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get themeSettings => 'Theme Settings';

  @override
  String get language => 'Language';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get languageSettings => 'Language Settings';

  @override
  String formatDate(DateTime date) {
    return DateFormat('MMM dd, yyyy').format(date);
  }

  @override
  String formatDateTime(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm').format(dateTime);
  }

  @override
  String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else {
      return 'Just now';
    }
  }
}

class ArabicLocalizations extends AppLocalizations {
  @override
  String get appTitle => 'تطبيق معماري نظيف';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get error => 'خطأ';

  @override
  String get retry => 'إعادة المحاولة';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get add => 'إضافة';

  @override
  String get search => 'بحث';

  @override
  String get settings => 'الإعدادات';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get register => 'التسجيل';

  @override
  String get posts => 'المنشورات';

  @override
  String get post => 'منشور';

  @override
  String get createPost => 'إنشاء منشور';

  @override
  String get editPost => 'تعديل المنشور';

  @override
  String get deletePost => 'حذف المنشور';

  @override
  String get postTitle => 'العنوان';

  @override
  String get postBody => 'المحتوى';

  @override
  String get postAuthor => 'الكاتب';

  @override
  String get postDate => 'التاريخ';

  @override
  String get noPosts => 'لا توجد منشورات';

  @override
  String get noPostsMessage => 'لا توجد منشورات متاحة';

  @override
  String get postCreated => 'تم إنشاء المنشور بنجاح';

  @override
  String get postUpdated => 'تم تحديث المنشور بنجاح';

  @override
  String get postDeleted => 'تم حذف المنشور بنجاح';

  @override
  String get postCreationFailed => 'فشل في إنشاء المنشور';

  @override
  String get postUpdateFailed => 'فشل في تحديث المنشور';

  @override
  String get postDeletionFailed => 'فشل في حذف المنشور';

  @override
  String get requiredField => 'هذا الحقل مطلوب';

  @override
  String get invalidEmail => 'عنوان البريد الإلكتروني غير صحيح';

  @override
  String get invalidPassword => 'كلمة المرور غير صحيحة';

  @override
  String get passwordTooShort => 'كلمة المرور قصيرة جداً';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get invalidInput => 'إدخال غير صحيح';

  @override
  String get networkError => 'خطأ في الشبكة';

  @override
  String get connectionError => 'خطأ في الاتصال';

  @override
  String get serverError => 'خطأ في الخادم';

  @override
  String get timeoutError => 'انتهت مهلة الطلب';

  @override
  String get noInternetConnection => 'لا يوجد اتصال بالإنترنت';

  @override
  String get lightTheme => 'فاتح';

  @override
  String get darkTheme => 'داكن';

  @override
  String get systemTheme => 'النظام';

  @override
  String get themeSettings => 'إعدادات المظهر';

  @override
  String get language => 'اللغة';

  @override
  String get english => 'English';

  @override
  String get arabic => 'العربية';

  @override
  String get languageSettings => 'إعدادات اللغة';

  @override
  String formatDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'ar').format(date);
  }

  @override
  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy HH:mm', 'ar').format(dateTime);
  }

  @override
  String getRelativeTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم${difference.inDays == 1 ? '' : 'اً'}';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة${difference.inHours == 1 ? '' : 'اً'}';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة${difference.inMinutes == 1 ? '' : 'اً'}';
    } else {
      return 'الآن';
    }
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    switch (locale.languageCode) {
      case 'ar':
        return ArabicLocalizations();
      case 'en':
      default:
        return EnglishLocalizations();
    }
  }

  @override
  bool shouldReload(AppLocalizationsDelegate old) => false;
} 