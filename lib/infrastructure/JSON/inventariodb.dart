// import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';

class Inventariodb {
    final String codigo;
    final String producto;
    final int proid;
    final int cantidad;
    final double precio;

    Inventariodb({
        required this.codigo,
        required this.producto,
        required this.proid,
        required this.cantidad,
        required this.precio,
    });

    factory Inventariodb.fromJson(Map<String, dynamic> json) => Inventariodb(
        codigo: json["codigo"],
        producto: json["producto"],
        proid: json["proid"],
        cantidad: json["cantidad"],
        precio: json["precio"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "codigo": codigo,
        "producto": producto,
        "proid": proid,
        "cantidad": cantidad,
        "precio": precio,
    };
}
