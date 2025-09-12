
class Facturacompradb {
    final int? id;
    final int provid;
    final String fecha;
    final double subtotal;
    final double iva;
    final double total;

    Facturacompradb({
        this.id,
        required this.provid,
        required this.fecha,
        required this.subtotal,
        required this.iva,
        required this.total,
    });

    factory Facturacompradb.fromJson(Map<String, dynamic> json) => Facturacompradb(
        id: json["id"],
        provid: json["provid"],
        fecha: json["fecha"],
        subtotal: json["subtotal"]?.toDouble(),
        iva: json["iva"]?.toDouble(),
        total: json["total"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "provid": provid,
        "fecha": fecha,
        "subtotal": subtotal,
        "iva": iva,
        "total": total,
    };
}
