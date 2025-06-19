import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/versiculo.dart';
import 'versiculo_screen.dart';
import 'configuracoes_screen.dart';
import 'favoritos_screen.dart';

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

  void _abrirFavoritos(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => FavoritosScreen(fontSize: fontSize)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Como você está se sentindo?'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () => _abrirFavoritos(context),
          ),
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
