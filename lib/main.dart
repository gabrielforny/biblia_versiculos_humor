// main.dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [Locale('pt'), Locale('en'), Locale('es')],
      home: HumorScreen(
        themeMode: _themeMode,
        fontSize: _fontSize,
        onSettingsChanged: updateSettings,
      ),
    );
  }
}

class Versiculo {
  final String texto;
  final String referencia;

  Versiculo({required this.texto, required this.referencia});

  factory Versiculo.fromJson(Map<String, dynamic> json) {
    return Versiculo(texto: json['texto'], referencia: json['referencia']);
  }
}

class HumorScreen extends StatelessWidget {
  final ThemeMode themeMode;
  final double fontSize;
  final Function(ThemeMode, double) onSettingsChanged;

  HumorScreen({
    required this.themeMode,
    required this.fontSize,
    required this.onSettingsChanged,
  });

  final Map<String, String> humores = {
    'triste': '😢 Triste',
    'preocupado': '😰 Preocupado',
    'grato': '🙏 Grato',
    'feliz': '😊 Feliz',
    'cansado': '😴 Cansado',
    'com medo': '😨 Com Medo',
  };

  void _abrirVersiculo(BuildContext context, String humor) async {
    final data = await rootBundle.loadString(
      'assets/data/versiculos_emocoes.json',
    );
    final Map<String, dynamic> jsonMap = json.decode(data);
    final List versiculosJson = jsonMap[humor] ?? [];

    final versiculos =
        versiculosJson.map((v) => Versiculo.fromJson(v)).toList();
    versiculos.shuffle();

    if (versiculos.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => VersiculoScreen(
                versiculos: versiculos,
                themeMode: themeMode,
                fontSize: fontSize,
              ),
        ),
      );
    }
  }

  void _abrirConfiguracoes(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => ConfiguracoesScreen(
              currentTheme: themeMode,
              fontSize: fontSize,
              onSettingsChanged: onSettingsChanged,
            ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Como você está se sentindo?'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _abrirConfiguracoes(context),
          ),
        ],
      ),
      body: ListView(
        children:
            humores.entries.map((entry) {
              return Card(
                margin: EdgeInsets.all(12),
                child: ListTile(
                  leading: Text(
                    entry.value.split(' ')[0],
                    style: TextStyle(fontSize: 28),
                  ),
                  title: Text(entry.value.split(' ')[1]),
                  onTap: () => _abrirVersiculo(context, entry.key),
                ),
              );
            }).toList(),
      ),
    );
  }
}

class VersiculoScreen extends StatefulWidget {
  final List<Versiculo> versiculos;
  final ThemeMode themeMode;
  final double fontSize;

  VersiculoScreen({
    required this.versiculos,
    required this.themeMode,
    required this.fontSize,
  });

  @override
  State<VersiculoScreen> createState() => _VersiculoScreenState();
}

class _VersiculoScreenState extends State<VersiculoScreen> {
  late Versiculo versiculoAtual;

  @override
  void initState() {
    super.initState();
    versiculoAtual = widget.versiculos.first;
  }

  void _novoVersiculo() {
    widget.versiculos.shuffle();
    setState(() {
      versiculoAtual = widget.versiculos.first;
    });
  }

  void _compartilhar() {
    Share.share("${versiculoAtual.texto} — ${versiculoAtual.referencia}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Versículo para você')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              versiculoAtual.texto,
              style: TextStyle(fontSize: widget.fontSize + 2),
            ),
            SizedBox(height: 16),
            Text(
              versiculoAtual.referencia,
              style: TextStyle(
                fontSize: widget.fontSize,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 24),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.refresh),
                  onPressed: _novoVersiculo,
                ),
                IconButton(icon: Icon(Icons.share), onPressed: _compartilhar),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ConfiguracoesScreen extends StatefulWidget {
  final ThemeMode currentTheme;
  final double fontSize;
  final Function(ThemeMode, double) onSettingsChanged;

  ConfiguracoesScreen({
    required this.currentTheme,
    required this.fontSize,
    required this.onSettingsChanged,
  });

  @override
  State<ConfiguracoesScreen> createState() => _ConfiguracoesScreenState();
}

class _ConfiguracoesScreenState extends State<ConfiguracoesScreen> {
  late ThemeMode _themeMode;
  late double _fontSize;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.currentTheme;
    _fontSize = widget.fontSize;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurações')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tema'),
            ListTile(
              title: Text('Claro'),
              leading: Radio(
                value: ThemeMode.light,
                groupValue: _themeMode,
                onChanged: (ThemeMode? value) {
                  setState(() => _themeMode = value!);
                },
              ),
            ),
            ListTile(
              title: Text('Escuro'),
              leading: Radio(
                value: ThemeMode.dark,
                groupValue: _themeMode,
                onChanged: (ThemeMode? value) {
                  setState(() => _themeMode = value!);
                },
              ),
            ),
            SizedBox(height: 16),
            Text('Tamanho da Fonte'),
            Slider(
              value: _fontSize,
              min: 14,
              max: 28,
              divisions: 7,
              label: _fontSize.round().toString(),
              onChanged: (value) {
                setState(() => _fontSize = value);
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                widget.onSettingsChanged(_themeMode, _fontSize);
                Navigator.pop(context);
              },
              child: Text('Salvar Configurações'),
            ),
          ],
        ),
      ),
    );
  }
}
