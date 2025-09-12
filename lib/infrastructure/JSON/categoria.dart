class Categoria {
  final int? id;
  final String categoria;

  Categoria({
    this.id, 
    required this.categoria
  });

  factory Categoria.fromJson(Map<String, dynamic> json) => Categoria(
        id: json["id"],
        categoria: json["categoria"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "categoria": categoria,
    };
}