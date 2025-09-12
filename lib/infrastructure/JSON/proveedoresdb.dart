class Proveedoresdb {
    final String ruc;
    final String empresa;
    final String direccion;
    final String email;
    final String telefono;

    Proveedoresdb({
        required this.ruc,
        required this.empresa,
        required this.direccion,
        required this.email,
        required this.telefono,
    });

    factory Proveedoresdb.fromJson(Map<String, dynamic> json) => Proveedoresdb(
        ruc: json["ruc"],
        empresa: json["empresa"],
        direccion: json["direccion"],
        email: json["email"],
        telefono: json["telefono"],
    );

    Map<String, dynamic> toJson() => {
        "ruc": ruc,
        "empresa": empresa,
        "direccion": direccion,
        "email": email,
        "telefono": telefono,
    };
}
