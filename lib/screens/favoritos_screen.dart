import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/versiculo.dart';

class FavoritosScreen extends StatelessWidget {
  final double fontSize;
  const FavoritosScreen({required this.fontSize});

  Future<List<Versiculo>> _carregarFavoritos() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritos = prefs.getStringList('favoritos') ?? [];
    return favoritos.map((f) => Versiculo.fromJson(json.decode(f))).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Favoritos')),
      body: FutureBuilder<List<Versiculo>>(
        future: _carregarFavoritos(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());
          final versiculos = snapshot.data!;
          if (versiculos.isEmpty)
            return Center(child: Text('Nenhum favorito ainda.'));
          return ListView.builder(
            itemCount: versiculos.length,
            itemBuilder: (context, index) {
              final v = versiculos[index];
              return ListTile(
                title: Text(v.texto, style: TextStyle(fontSize: fontSize)),
                subtitle: Text(v.referencia),
              );
            },
          );
        },
      ),
    );
  }
}
