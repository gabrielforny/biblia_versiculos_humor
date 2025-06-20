import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import '../models/devotional.dart';

class DevotionalScreen extends StatefulWidget {
  final double fontSize;

  const DevotionalScreen({super.key, required this.fontSize});

  @override
  State<DevotionalScreen> createState() => _DevotionalScreenState();
}

class _DevotionalScreenState extends State<DevotionalScreen> {
  late Devotional _devocional;

  @override
  void initState() {
    super.initState();
    _carregarDevocional();
  }

  Future<void> _carregarDevocional() async {
    final String jsonString = await rootBundle.loadString(
      'data/devocionais.json',
    );
    final List<dynamic> jsonList = json.decode(jsonString);
    final List<Devotional> devocionais =
        jsonList.map((e) => Devotional.fromJson(e)).toList();
    devocionais.shuffle();
    setState(() {
      _devocional = devocionais.first;
    });
  }

  void _mostrarReflexao() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Reflexão'),
            content: Text(_devocional.reflexao),
            actions: [
              TextButton(
                child: const Text('Fechar'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
    );
  }

  void _compartilhar() {
    Share.share('${_devocional.versiculo}\n\n${_devocional.comentario}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Devocional do Dia')),
      body:
          _devocional == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _devocional.versiculo,
                      style: TextStyle(fontSize: widget.fontSize + 2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _devocional.comentario,
                      style: TextStyle(fontSize: widget.fontSize),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: _mostrarReflexao,
                      child: const Text('Refletir sobre esse versículo'),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.share),
                          onPressed: _compartilhar,
                        ),
                        IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: _carregarDevocional,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
    );
  }
}
