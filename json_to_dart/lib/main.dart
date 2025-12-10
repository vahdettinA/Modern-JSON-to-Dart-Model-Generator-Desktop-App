import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/converter/presentation/pages/home_page.dart';

import 'package:window_manager/window_manager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  WindowOptions windowOptions = const WindowOptions(
    size: Size(1280, 720),
    minimumSize: Size(800, 600), // Tablet-ish size
    center: true,
    backgroundColor: Colors.transparent,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.normal,
  );

  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  runApp(const JsonToDartApp());
}

class JsonToDartApp extends StatelessWidget {
  const JsonToDartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JsonConverter',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // We only use dark theme as per the palette
      themeMode: ThemeMode.dark,
      home: const HomePage(),
    );
  }
}
