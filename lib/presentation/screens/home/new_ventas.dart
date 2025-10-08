import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewVentas extends StatefulWidget {

  const NewVentas({super.key});

  @override
  State<NewVentas> createState() => _NewVentasState();
}

class _NewVentasState extends State<NewVentas> {
  final DatabaseHelper db = DatabaseHelper();

  Clientesdb? clienteSeleccionado;
  Inventariodb? productoSeleccionado;
  final cantidadController = TextEditingController(text: '1');

  List<Map<String, dynamic>> detalleFactura = [];

  double subtotal = 0;
  double iva = 0;
  double total = 0;

  Future<void> calcularTotales() async {
    subtotal = detalleFactura.fold(0, (s, item) => s + item['subtotal']);
    iva = subtotal * 0.15 ;
    total = subtotal + iva;
    setState(() {});
  }

  Future<void> agregarProducto() async {
    if ( productoSeleccionado == null || cantidadController.text.isEmpty) return;
    int cantidad = int.parse(cantidadController.text);
    if (cantidad > productoSeleccionado!.cantidad) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cantidad excede el stock disponible.')));
      return;
    }

    double subtotalitem = cantidad * productoSeleccionado!.precio;

    setState(() {
      detalleFactura.add({
        'codigo': productoSeleccionado!.codigo,
        'producto': productoSeleccionado!.producto,
        'cantidad': cantidad,
        'precio': productoSeleccionado!.precio,
        'subtotal': subtotalitem
      });
    });

    await calcularTotales();
    cantidadController.clear();
    productoSeleccionado = null;
  }

  Future<void> guardarFactura() async {
    if (clienteSeleccionado == null || detalleFactura.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Seleccione cliente y agregue productos'))
      );
      return;
    }

    final facturaId = await db.createFactura(
      Facturaventadb(
        clienteid: int.parse(clienteSeleccionado!.cedula), 
        fecha: DateTime.now().toString(), 
        subtotal: subtotal, 
        iva: iva, 
        total: total
      )
    );

    for (var item in detalleFactura) {
      await db.createFacturaDetalleVenta(
        Facturavendetdb(
          facid: facturaId, 
          proid: item['codigo'], 
          cantidad: item['cantidad'], 
          preciouni: item['precio'], 
          subtotal: item['subtotal']
        )
      );

      int nuevostock = productoSeleccionado!.cantidad ;
      await db.updateStock(item['codigo'], nuevostock);
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Factura guardada exitosamente'))
    );

    setState(() {
      detalleFactura.clear();
      subtotal = iva = total = 0;
      clienteSeleccionado =  null;
    });
  }

  @override
  Widget build(BuildContext context) {

    int stockDisponible = productoSeleccionado?.cantidad ?? 1;

    final textStyle = Theme.of(context).textTheme;
    Color getColor(Set<WidgetState> states) {
      return Colors.white;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 51, 128, 124),
          title: Center(
            child: Text('Ventas',
              style: textStyle.titleMedium)),
        ),
        body: Column(
          children: [
            Container(
              alignment: Alignment(0, 0),
              padding: EdgeInsets.fromLTRB(5,2,50,5),
              width: double.infinity,
              height: 60,
              child: Text('Generar nueva factura',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),)
            ),
            Container(
              width: 440,
              height: 265,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Spacer(),
                      IconButton(
                        onPressed: (){
                          context.push('/new-clientes');
                        }, 
                        icon: Icon(Icons.add),
                        iconSize: 30,)
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 418,
                        height: 60,
                        padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
                        child: FutureBuilder<List<Clientesdb>>(
                          future: db.getCliente(), 
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) return const CircularProgressIndicator();
                            return DropdownButtonFormField<Clientesdb>(
                              decoration: InputDecoration(labelText: 'Seleccione Cliente'),
                              items: snapshot.data!.map((c) => DropdownMenuItem(
                                value: c,
                                child: Text('${c.nombre} ${c.apellido}'),
                              )).toList(), 
                              onChanged: (value) {
                                setState(() {
                                  clienteSeleccionado = value;
                                });
                              },
                              value: clienteSeleccionado,
                            );
                          },
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
                    child: FutureBuilder<List<Inventariodb>>(
                      future: db.getProducts(), 
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return const CircularProgressIndicator();
                        return DropdownButtonFormField<Inventariodb>(
                          decoration: InputDecoration(labelText: 'Seleccione Producto'),
                          items: snapshot.data!.map((p) => DropdownMenuItem(
                            value: p,
                            child: Text('${p.producto} - Stock: ${p.cantidad}'))
                        ).toList(), 
                        onChanged: (value) {
                          setState(() {
                            productoSeleccionado = value;
                          });
                        }, 
                        value: productoSeleccionado,
                        );
                      },
                    )
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
                    child: CustomTextFormField(
                      controller: cantidadController,
                      label: 'Cantidad',
                      keyboardType: TextInputType.number,
                      enable: productoSeleccionado != null,
                    ),
                  ),
                ]
              ),
            ),
            ElevatedButton.icon(
              onPressed: agregarProducto, 
              icon: Icon(Icons.add),
              label: Text('Agregar Producto')
            ),
            SizedBox(height: 10),
            // Container(
            //   padding: EdgeInsets.zero,
            //   child: SingleChildScrollView(
            //     child: DataTable(
            //       dividerThickness: 2,
            //       dataRowMinHeight: 47,
            //       headingRowHeight: 47,
            //       columnSpacing: 40,
            //       showBottomBorder: true,
            //       dataRowColor: WidgetStateColor.resolveWith(getColor),
            //       headingRowColor: WidgetStateColor.resolveWith(getColor),
            //       border: TableBorder(
            //         top: BorderSide(width: 2),
            //         left: BorderSide(width: 2),
            //         right: BorderSide(width: 2),
            //         bottom: BorderSide(width: 2),
            //         verticalInside: BorderSide(width: 2),
            //         horizontalInside: BorderSide(width: 2)
            //       ),
            //       columns: [
            //         DataColumn(
            //           label: Text('Código', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
            //           numeric: true,
            //         ),
            //         DataColumn(
            //           label: Text('Producto', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
            //           numeric: true,
            //         ),
            //         DataColumn(
            //           label: Text('Cantidad', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
            //           numeric: true,
            //         ),
            //         DataColumn(
            //           label: Text('Precio', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
            //           numeric: true
            //         ),
            //         DataColumn(
            //           label: Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
            //           numeric: true
            //         ),
            //       ], 
            //       rows: detalles.map((item){
            //         return DataRow(
            //           cells: [
            //             DataCell(Text(item['codigo'])),
            //             DataCell(Text(item['producto'])),
            //             DataCell(Text(item['cantidad'].toString())),
            //             DataCell(Text(item['precio'].toStringAsFixed(2))),
            //             DataCell(Text((item['precio'] * item['cantidad']).toStringAsFixed(2))),
            //         ]);
            //       }).toList(),
            //     ),
            //   ),
            // ),
              Row(
                children: [
                  SizedBox(width: 310,),
                  DataTable(
                    dividerThickness: 1,
                    dataRowMinHeight: 47,
                    headingRowHeight: 47,
                    columnSpacing: 6,
                    dataRowColor: WidgetStateColor.resolveWith(getColor),
                    headingRowColor: WidgetStateColor.resolveWith(getColor),
                    border: TableBorder(
                      left: BorderSide(width: 2),
                      right: BorderSide(width: 2),
                      bottom: BorderSide(width: 2),
                      verticalInside: BorderSide(width: 2),
                      horizontalInside: BorderSide(width: 2)
                    ),
                    columns: [
                      DataColumn(
                        label: Text('Subtotal', textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      ),
                      DataColumn(
                        label: Text('\$${subtotal.toStringAsFixed(2)}'),
                      ),
                    ], 
                    rows: [
                      DataRow(cells: [
                        DataCell(Text('IVA 15%', textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black))),
                        DataCell(Text('\$${iva.toStringAsFixed(2)}')),
                      ]),
                      DataRow(cells: [
                        DataCell(Text('Total', textAlign: TextAlign.left,
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black))),
                        DataCell(Text('\$${total.toStringAsFixed(2)}')),
                      ])
                    ]
                  ),
                ],
              ),
              SizedBox(height: 180),
              Container(
                width: double.infinity,
                height: 60,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CustomFilledButton(
                  buttonColor: Color.fromARGB(228, 51, 128, 124),
                  text: 'Generar Factura',
                  textStyle: textStyle.titleMedium,
                  onPressed: (){},
                ),
              ),
          ]
        ),
      ),
    );
  }
}