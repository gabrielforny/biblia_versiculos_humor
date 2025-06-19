import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'screens/humor_screen.dart';

void main() {
  runApp(BibliaVivaApp());
}

class BibliaVivaApp extends StatefulWidget {
  @override
  State<BibliaVivaApp> createState() => _BibliaVivaAppState();
}

class _BibliaVivaAppState extends State<BibliaVivaApp> {
  ThemeMode _themeMode = ThemeMode.system;
  double _fontSize = 18;

  void updateSettings(ThemeMode theme, double fontSize) {
    setState(() {
      _themeMode = theme;
      _fontSize = fontSize;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bíblia Viva',
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.indigo,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.indigo,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt'), Locale('en'), Locale('es')],
      home: HumorScreen(
        themeMode: _themeMode,
        fontSize: _fontSize,
        onSettingsChanged: updateSettings,
      ),
    );
  }
}
