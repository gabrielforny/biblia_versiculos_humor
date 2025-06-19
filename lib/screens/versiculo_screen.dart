import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:another_flushbar/flushbar.dart';
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
  bool isFavorito = false;

  @override
  void initState() {
    super.initState();
    versiculoAtual = widget.versiculos.first;
    _verificarSeEhFavorito();
  }

  Future<void> _verificarSeEhFavorito() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = prefs.getStringList('favoritos') ?? [];
    final jsonAtual = json.encode(versiculoAtual.toJson());
    setState(() {
      isFavorito = favoritos.contains(jsonAtual);
    });
  }

  void _novoVersiculo() {
    widget.versiculos.shuffle();
    setState(() {
      versiculoAtual = widget.versiculos.first;
    });
    _verificarSeEhFavorito();
  }

  void _compartilhar() {
    Share.share("${versiculoAtual.texto} — ${versiculoAtual.referencia}");
  }

  void _mostrarNotificacao(String mensagem, Color cor) {
    Flushbar(
      message: mensagem,
      duration: Duration(seconds: 2),
      backgroundColor: cor,
      flushbarPosition: FlushbarPosition.TOP,
    ).show(context);
  }

  void _alternarFavorito() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = prefs.getStringList('favoritos') ?? [];
    final jsonAtual = json.encode(versiculoAtual.toJson());

    if (favoritos.contains(jsonAtual)) {
      favoritos.remove(jsonAtual);
      _mostrarNotificacao('Versículo removido dos favoritos', Colors.red);
    } else {
      favoritos.add(jsonAtual);
      _mostrarNotificacao('Versículo adicionado aos favoritos', Colors.green);
    }

    await prefs.setStringList('favoritos', favoritos);
    _verificarSeEhFavorito();
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
                IconButton(
                  icon: Icon(
                    isFavorito ? Icons.favorite : Icons.favorite_border,
                    color: isFavorito ? Colors.red : null,
                  ),
                  onPressed: _alternarFavorito,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
