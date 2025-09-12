class Activosdb {
    final String codigo;
    final String activo;
    final String ubicacion;
    final String fechaIng;
    final String estado;

    Activosdb({
        required this.codigo,
        required this.activo,
        required this.ubicacion,
        required this.fechaIng,
        required this.estado,
    });

    factory Activosdb.fromJson(Map<String, dynamic> json) => Activosdb(
        codigo: json["codigo"],
        activo: json["activo"],
        ubicacion: json["ubicacion"],
        fechaIng: json["fechaIng"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "activo": activo,
        "ubicacion": ubicacion,
        "fechaIng": fechaIng,
        "estado": estado,
    };
}
