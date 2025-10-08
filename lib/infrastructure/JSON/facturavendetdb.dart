class Facturavendetdb {
    final int? id;
    final int facid;
    final int proid;
    final int cantidad;
    final double preciouni;
    final double subtotal;

    Facturavendetdb({
        this.id,
        required this.facid,
        required this.proid,
        required this.cantidad,
        required this.preciouni,
        required this.subtotal,
    });

    factory Facturavendetdb.fromJson(Map<String, dynamic> json) => Facturavendetdb(
        id: json["id"],
        facid: json["facid"],
        proid: json["proid"],
        cantidad: json["cantidad"],
        preciouni: json["preciouni"]?.toDouble(),
        subtotal: json["subtotal"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "facid": facid,
        "proid": proid,
        "cantidad": cantidad,
        "preciouni": preciouni,
        "subtotal": subtotal,
    };
}
