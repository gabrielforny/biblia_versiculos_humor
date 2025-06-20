class Devotional {
  final String versiculo;
  final String comentario;
  final String reflexao;

  Devotional({
    required this.versiculo,
    required this.comentario,
    required this.reflexao,
  });

  factory Devotional.fromJson(Map<String, dynamic> json) {
    return Devotional(
      versiculo: json['versiculo'],
      comentario: json['comentario'],
      reflexao: json['reflexao'],
    );
  }

  Map<String, dynamic> toJson() => {
    'versiculo': versiculo,
    'comentario': comentario,
    'reflexao': reflexao,
  };
}
