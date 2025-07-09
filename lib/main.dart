import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/posts/presentation/pages/posts_page.dart';
import 'core/theme/theme_controller.dart';
import 'core/theme/adaptive_theme.dart';
import 'core/storage/local_storage.dart';
import 'core/providers.dart';
import 'core/http_client.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize HttpClient with logging interceptor
  HttpClient.initialize();
  
  // Initialize LocalStorage
  final localStorage = await SharedPreferencesStorage.getInstance();
  
  runApp(
    ProviderScope(
      overrides: [
        localStorageProvider.overrideWithValue(localStorage),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeType = ref.watch(themeControllerProvider);
    final locale = ref.watch(localeProvider);
    
    if (AdaptiveTheme.isIOS) {
      return CupertinoApp(
        title: 'Clean Architecture Riverpod',
        theme: AdaptiveTheme.getCupertinoTheme(themeType),
        home: const PostsPage(),
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      );
    } else {
      return MaterialApp(
        title: 'Clean Architecture Riverpod',
        theme: AdaptiveTheme.getMaterialTheme(themeType),
        home: const PostsPage(),
        debugShowCheckedModeBanner: false,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }
  }
}
