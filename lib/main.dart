import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/theme/theme_controller.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/theme/adaptive_theme.dart';
import 'package:flutter_riverpod_tmplt/core/data/datasources/local/storage/local_storage.dart';
import 'package:flutter_riverpod_tmplt/core/providers/local_providers.dart';
import 'package:flutter_riverpod_tmplt/core/presentation/navigation/app_router.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  
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
    
    final router = ref.watch(routerProvider);
    
    if (AdaptiveTheme.isIOS) {
      return CupertinoApp.router(
        title: 'Clean Architecture Riverpod',
        theme: AdaptiveTheme.getCupertinoTheme(themeType),
        routerConfig: router,
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
      return MaterialApp.router(
        title: 'Clean Architecture Riverpod',
        theme: AdaptiveTheme.getMaterialTheme(themeType),
        routerConfig: router,
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
