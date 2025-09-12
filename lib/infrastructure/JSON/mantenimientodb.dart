class Mantenimientodb {
    final int? manId;
    final String equipo;
    final String fechaSal;
    final String estado;

    Mantenimientodb({
        this.manId,
        required this.equipo,
        required this.fechaSal,
        required this.estado,
    });

    factory Mantenimientodb.fromJson(Map<String, dynamic> json) => Mantenimientodb(
        manId: json["manId"],
        equipo: json["equipo"],
        fechaSal: json["fechaSal"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "manId": manId,
        "equipo": equipo,
        "fechaSal": fechaSal,
        "estado": estado,
    };
}
