import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NewVentas extends StatefulWidget {

  const NewVentas({super.key});

  @override
  State<NewVentas> createState() => _NewVentasState();
}

class _NewVentasState extends State<NewVentas> {

  List<Map<String, dynamic>> clientes = [];
  List<Map<String, dynamic>> productos = [];
  List<Map<String, dynamic>> detalles = [];

  Map<String, dynamic>? clienteSeleccionado;
  Map<String, dynamic>? productoSeleccionado;
  int cantidad = 1;

  double subtotal = 0;
  double iva = 0;
  double total = 0;

  TextEditingController clienteController = TextEditingController();
  TextEditingController productoController = TextEditingController();
  TextEditingController cantidadController = TextEditingController(text: '1');

  double calcularSubtotal(List<Map<String, dynamic>> items) {
    return items.fold(0, (sum, item) => sum + item['precio'] * item['cantidad']);
  }

  double calcularIVA(double subtotal) => subtotal * 0.12;

  double calcularTotal(double subtotal) => subtotal + calcularIVA(subtotal);

  @override
  void initState() {
    db = DatabaseHelper();
    super.initState();
    cargarDatos();
  }

  late DatabaseHelper db;

  Future<void> cargarDatos() async {
    
    final cli = await db.getClientesVentas();
    final prod = await db.getProductosVentas();
    setState(() {
      clientes = cli;
      productos = prod;
    });
  }

  void agregarProducto() async {
    if ( productoSeleccionado == null) return;
    int stock = productoSeleccionado!['cantidad'];
    if (cantidad > stock) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Cantidad excede el stock disponible.')));
      return;
    }

    detalles.add({
      'codigo': productoSeleccionado!['codigo'],
      'producto': productoSeleccionado!['producto'],
      'precio': productoSeleccionado!['precio'],
      'cantidad': cantidad,
    });

    int nuevostock = stock - cantidad;
    await db.updateStock(productoSeleccionado!['codigo'], nuevostock);

    final prod = await db.getProductosVentas();
    setState(() {
      productos = prod;
      productoSeleccionado = productos.firstWhere(
        (p) => p['codigo'] == productoSeleccionado!['codigo'],
        // orElse: () => null,
      );

      subtotal = calcularSubtotal(detalles);
      iva = calcularIVA(subtotal);
      total = calcularTotal(subtotal);

      cantidad = 1;
      cantidadController.text = '1';
    });

    detalles.add({
      'codigo': productoSeleccionado!['codigo'],
      'producto': productoSeleccionado!['producto'],
      'precio': productoSeleccionado!['precio'],
      'cantidad': cantidad,
    });

    subtotal = calcularSubtotal(detalles);
    iva = calcularIVA(subtotal);
    total = calcularTotal(subtotal);

    setState(() {
      cantidad = 1;
      cantidadController.text = '1';
    });
  }

  List<Map<String, dynamic>> filtrarClientes(String filtro) {
    return clientes.where((clientes) => clientes['apellido'].toLowerCase().contains(filtro.toLowerCase())).toList();
  }

  List<Map<String, dynamic>> filtrarProductos(String filtro) {
    return productos.where((products) => products['producto'].toLowerCase().contains(filtro.toLowerCase())).toList();
  }

  @override
  Widget build(BuildContext context) {

    int stockDisponible = productoSeleccionado?['cantidad'] ?? 1;

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
        body: SingleChildScrollView(
          physics: ClampingScrollPhysics(),
          child: Column(
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
                    // Text('Cliente', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        Container(
                          width: 418,
                          height: 60,
                          padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
                          child: Autocomplete<Map<String, dynamic>>(
                            displayStringForOption: (c) => c['apellido'],
                            optionsBuilder: (TextEditingValue textEditingValue) {
                              if (textEditingValue.text == '') {
                                return const Iterable<Map<String, dynamic>>.empty();
                              }
                              return filtrarClientes(textEditingValue.text);
                            },
                            onSelected: (Map<String, dynamic> selection) {
                              setState(() {
                                clienteSeleccionado = selection;
                                clienteController.text = selection['apellido'];
                              });
                            },
                            fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                              clienteController = controller;
                              return CustomTextFormField(
                                controller: controller,
                                label: 'Buscar o seleccionar cliente',
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    // Text('Seleccione el producto', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
                      child: Autocomplete<Map<String, dynamic>>(
                        displayStringForOption: (p) => p['producto'],
                        optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text == '') {
                          return const Iterable<Map<String, dynamic>>.empty();
                        }
                        return filtrarProductos(textEditingValue.text);
                        },
                        onSelected: (Map<String, dynamic> selection) {
                          setState(() {
                            productoSeleccionado = selection;
                            productoController.text = selection['producto'];
                            stockDisponible = selection['cantidad'];
                            cantidadController.text = '1';
                          });
                        },
                        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
                        productoController = controller;
                        return CustomTextFormField(
                          controller: controller,
                          label: 'Buscar o seleccionar producto',
                        );
                      },
                    ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 60,
                      padding: EdgeInsets.fromLTRB(0, 2, 0, 5),
                      child: CustomTextFormField(
                        controller: cantidadController,
                        label: 'Cantidad',
                        keyboardType: TextInputType.number,
                        onChanged: (val) {
                          final valor = int.tryParse(val) ?? 1;
                          setState(() {
                            cantidad = valor > stockDisponible ? stockDisponible : valor;
                            cantidadController.text = cantidad.toString();
                          });
                        },
                        enable: productoSeleccionado != null,
                      ),
                    ),
                  ]
                ),
              ),
              ElevatedButton(
                onPressed: agregarProducto, 
                child: Text('Agregar')
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.zero,
                child: DataTable(
                  dividerThickness: 2,
                  dataRowMinHeight: 47,
                  headingRowHeight: 47,
                  columnSpacing: 40,
                  showBottomBorder: true,
                  dataRowColor: WidgetStateColor.resolveWith(getColor),
                  headingRowColor: WidgetStateColor.resolveWith(getColor),
                  border: TableBorder(
                    top: BorderSide(width: 2),
                    left: BorderSide(width: 2),
                    right: BorderSide(width: 2),
                    bottom: BorderSide(width: 2),
                    verticalInside: BorderSide(width: 2),
                    horizontalInside: BorderSide(width: 2)
                  ),
                  columns: [
                    DataColumn(
                      label: Text('Código', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Producto', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Cantidad', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Precio', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      numeric: true
                    ),
                    DataColumn(
                      label: Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                      numeric: true
                    ),
                  ], 
                  rows: detalles.map((item){
                    return DataRow(
                      cells: [
                        DataCell(Text(item['codigo'])),
                        DataCell(Text(item['producto'])),
                        DataCell(Text(item['cantidad'].toString())),
                        DataCell(Text(item['precio'].toStringAsFixed(2))),
                        DataCell(Text((item['precio'] * item['cantidad']).toStringAsFixed(2))),
                    ]);
                  }).toList(),
                ),
              ),
                Row(
                  children: [
                    SizedBox(width: 310,),
                    DataTable(
                      dividerThickness: 1,
                      dataRowMinHeight: 47,
                      headingRowHeight: 47,
                      columnSpacing: 5,
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
                          label: Text('Subtotal', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black)),
                          numeric: true
                        ),
                        DataColumn(
                          label: Text('\$${subtotal.toStringAsFixed(2)}'),
                          numeric: true
                        ),
                      ], 
                      rows: [
                        DataRow(cells: [
                          DataCell(Text('IVA 15%', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black))),
                          DataCell(Text('\$${iva.toStringAsFixed(2)}')),
                        ]),
                        DataRow(cells: [
                          DataCell(Text('Total', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black))),
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
      ),
    );
  }
}