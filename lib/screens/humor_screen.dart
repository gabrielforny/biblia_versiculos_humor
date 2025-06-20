import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/versiculo.dart';
import 'versiculo_screen.dart';
import 'configuracoes_screen.dart';
import 'favoritos_screen.dart';
import 'devotional_screen.dart'; // novo modo devocional

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

  void _abrirTela(BuildContext context, Widget tela) {
    Navigator.pop(context); // Fecha o Drawer
    Navigator.push(context, MaterialPageRoute(builder: (_) => tela));
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.indigo),
            child: Center(
              child: Text(
                'Bíblia Viva',
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
          ),
          ListTile(
            leading: Icon(Icons.emoji_emotions),
            title: Text('Versículos por Humor'),
            onTap: () => Navigator.pop(context),
          ),
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text('Modo Devocional'),
            onTap:
                () => _abrirTela(context, DevotionalScreen(fontSize: fontSize)),
          ),
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text('Favoritos'),
            onTap:
                () => _abrirTela(context, FavoritosScreen(fontSize: fontSize)),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap:
                () => _abrirTela(
                  context,
                  ConfiguracoesScreen(
                    currentTheme: themeMode,
                    fontSize: fontSize,
                    onSettingsChanged: onSettingsChanged,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(title: Text('Como você está se sentindo?')),
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
                  title: Text(entry.value.substring(3).trim()),
                  onTap: () => _abrirVersiculo(context, entry.key),
                ),
              );
            }).toList(),
      ),
    );
  }
}
