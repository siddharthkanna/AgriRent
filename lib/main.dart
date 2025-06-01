import 'package:agrirent/providers/auth_provider.dart';
import 'package:agrirent/providers/language_provider.dart';
import 'package:agrirent/screens/onboarding.dart';
import 'package:agrirent/screens/pageview.dart';
import 'package:agrirent/theme/palette.dart';
import 'package:agrirent/config/supabase_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await SupabaseConfig.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedLocale = ref.watch(selectedLocaleProvider);

    return MaterialApp(
      locale: selectedLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('te'),
        Locale('ta'),
        Locale('ml'),
        Locale('kn'),

        // Add more supported locales as needed
      ],
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'poppins',
        scaffoldBackgroundColor: Palette.white,
      ),
      home: SafeArea(
        child: Consumer(
          builder: (context, ref, _) {
            final user = ref.read(authProvider);
            return user != null
                ? const PageViewScreen()
                : const OnboardingScreen();
          },
        ),
      ),
    );
  }
}
