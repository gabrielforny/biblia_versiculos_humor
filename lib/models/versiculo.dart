class Versiculo {
  final String texto;
  final String referencia;

  Versiculo({required this.texto, required this.referencia});

  factory Versiculo.fromJson(Map<String, dynamic> json) {
    return Versiculo(texto: json['texto'], referencia: json['referencia']);
  }

  Map<String, dynamic> toJson() {
    return {'texto': texto, 'referencia': referencia};
  }
}
