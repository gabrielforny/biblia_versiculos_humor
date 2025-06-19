import 'package:flutter/material.dart';

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
