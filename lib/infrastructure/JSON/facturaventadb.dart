// ignore_for_file: file_names
class Facturaventadb {
    final int? id;
    final int clienteid;
    final String fecha;
    final double subtotal;
    final double iva;
    final double total;

    Facturaventadb({
        this.id,
        required this.clienteid,
        required this.fecha,
        required this.subtotal,
        required this.iva,
        required this.total,
    });

    factory Facturaventadb.fromJson(Map<String, dynamic> json) => Facturaventadb(
        id: json["id"],
        clienteid: json["clienteid"],
        fecha: json["fecha"],
        subtotal: json["subtotal"]?.toDouble(),
        iva: json["iva"]?.toDouble(),
        total: json["total"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "clienteid": clienteid,
        "fecha": fecha,
        "subtotal": subtotal,
        "iva": iva,
        "total": total,
    };
}
