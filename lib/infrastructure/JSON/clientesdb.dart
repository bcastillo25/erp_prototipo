class Clientesdb {
    final String cedula;
    final String nombre;
    final String apellido;
    final String direccion;
    final String email;
    final String telefono;

    Clientesdb({
        required this.cedula,
        required this.nombre,
        required this.apellido,
        required this.direccion,
        required this.email,
        required this.telefono,
    });

    factory Clientesdb.fromJson(Map<String, dynamic> json) => Clientesdb(
        cedula: json["cedula"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        direccion: json["direccion"],
        email: json["email"],
        telefono: json["telefono"],
    );

    Map<String, dynamic> toJson() => {
        "cedula": cedula,
        "nombre": nombre,
        "apellido": apellido,
        "direccion": direccion,
        "email": email,
        "telefono": telefono,
    };
}
