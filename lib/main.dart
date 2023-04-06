import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:voice_assistant_app/provider/theme.dart';
import 'UI/splash_screen.dart';
import 'constants/themes.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeTheme = ref.watch(activeThemeProvider);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: activeTheme == Themes.dark ? ThemeMode.dark : ThemeMode.light,
      home: const SplashScreen()
    );
  }
}
      