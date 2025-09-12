class Rrhhdb {
    final String cedula;
    final String nombre;
    final String cargo;
    final String fechaIng;
    final double salario;
    final String estado;

    Rrhhdb({
        required this.cedula,
        required this.nombre,
        required this.cargo,
        required this.fechaIng,
        required this.salario,
        required this.estado,
    });

    factory Rrhhdb.fromJson(Map<String, dynamic> json) => Rrhhdb(
        cedula: json["cedula"],
        nombre: json["nombre"],
        cargo: json["cargo"],
        fechaIng: json["fechaIng"],
        salario: json["salario"]?.toDouble(),
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "cedula": cedula,
        "nombre": nombre,
        "cargo": cargo,
        "fechaIng": fechaIng,
        "salario": salario,
        "estado": estado,
    };
}
