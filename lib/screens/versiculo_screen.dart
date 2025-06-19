import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/versiculo.dart';

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

  void _favoritar() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = prefs.getStringList('favoritos') ?? [];
    final novo = json.encode(versiculoAtual.toJson());
    if (!favoritos.contains(novo)) {
      favoritos.add(novo);
      await prefs.setStringList('favoritos', favoritos);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Versículo adicionado aos favoritos!')),
      );
    }
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
                IconButton(icon: Icon(Icons.favorite), onPressed: _favoritar),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
