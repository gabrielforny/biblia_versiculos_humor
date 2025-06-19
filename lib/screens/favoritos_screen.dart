import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:convert';
import '../models/versiculo.dart';

class FavoritosScreen extends StatefulWidget {
  final double fontSize;
  const FavoritosScreen({required this.fontSize});

  @override
  State<FavoritosScreen> createState() => _FavoritosScreenState();
}

class _FavoritosScreenState extends State<FavoritosScreen> {
  late List<Versiculo> _versiculos = [];

  @override
  void initState() {
    super.initState();
    _carregarFavoritos();
  }

  Future<void> _carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = prefs.getStringList('favoritos') ?? [];
    setState(() {
      _versiculos =
          favoritos.map((f) => Versiculo.fromJson(json.decode(f))).toList();
    });
  }

  Future<void> _removerFavorito(Versiculo versiculo) async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = prefs.getStringList('favoritos') ?? [];
    favoritos.remove(json.encode(versiculo.toJson()));
    await prefs.setStringList('favoritos', favoritos);
    _carregarFavoritos();
  }

  Widget _divisorDecorado() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Center(
        child: SizedBox(
          width: 250,
          child: Row(
            children: [
              Expanded(child: Divider(thickness: 1, color: Colors.grey)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  Icons.menu_book_outlined,
                  size: 20,
                  color: Colors.grey,
                ),
              ),
              Expanded(child: Divider(thickness: 1, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }

  void _compartilhar(Versiculo versiculo) {
    Share.share("${versiculo.texto} — ${versiculo.referencia}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favoritos')),
      body:
          _versiculos.isEmpty
              ? Center(child: Text('Nenhum favorito ainda.'))
              : ListView.separated(
                itemCount: _versiculos.length,
                separatorBuilder: (_, __) => _divisorDecorado(),
                itemBuilder: (context, index) {
                  final v = _versiculos[index];
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    title: Text(
                      v.texto,
                      style: TextStyle(fontSize: widget.fontSize),
                    ),
                    subtitle: Text(v.referencia),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.share),
                          onPressed: () => _compartilhar(v),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _removerFavorito(v),
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
