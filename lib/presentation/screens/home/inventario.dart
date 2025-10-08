import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/inventariodb.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:go_router/go_router.dart';

class Inventario extends StatefulWidget {

  const Inventario({super.key});

  @override
  State<Inventario> createState() => _InventarioState();
}

class _InventarioState extends State<Inventario> {

  @override
  void initState() {
    handler = DatabaseHelper();
    producto = handler.getProducts();

    handler.initDB().whenComplete(() {
      producto = getAllProducto();
    });
    super.initState();
  }

  late DatabaseHelper handler;
  late Future<List<Inventariodb>> producto;
  final db = DatabaseHelper();
  String _searchQuery = '';

  Future<List<Inventariodb>> getAllProducto() {
    if (_searchQuery.isEmpty) {
      return handler.getProducts();
    } else {
      return handler.searchProduct(_searchQuery);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      producto = getAllProducto();
    });
  }

  void mostrarAcciones(Inventariodb item) {
    showModalBottomSheet(
      context: context, 
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Editar'),
              onTap: () {
                context.push('/new-inventario', extra: item);
                context.pop();
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Eliminar'),
              onTap: () {
                context.pop();
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    title: Text('Eliminar'),
                    content: Text('¿Esta seguro de eliminar "${item.producto}" del registro'),
                    actions: [
                      CustomFilledButton(
                        buttonColor: Colors.transparent,
                        text: 'Cancelar',
                        textStyle: TextStyle(color: Colors.black),
                        onPressed: () => context.pop(),
                      ),
                      CustomFilledButton(
                        buttonColor: Colors.transparent,
                        text: 'Eliminar',
                        textStyle: TextStyle(color: Colors.red),
                        onPressed: () {
                          db.deleteProduct(item.codigo).whenComplete(
                            () => _refresh()
                          );
                          context.pop();
                        },
                      )
                    ],
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }

  void mostrarDetalles(Inventariodb item) {
    showDialog(
      context: context, 
      builder: (context) => AlertDialog(
        title: Text(item.producto, style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              'assets/images/imagen.jpg',
              width: 150,
              height: 150,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 10),
            Text('Código: ${item.codigo}'),
            Text('Producto: ${item.producto}'),
            Text('Precio: \$${item.precio}'),
            Text('Stock: ${item.cantidad} unidades'),
            Text('Categoria: ${item.proid}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(), 
            child: Text('Cerrar')
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();
    final textStyle = Theme.of(context).textTheme;
    Color getColor(Set<WidgetState> states) {
      return Colors.white;
    }

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomBottomNavigation(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        title: Center(
          child: Text('Inventario',
            style: textStyle.titleMedium)), 
        actions: [
          IconButton(
            onPressed: (){
              // final data = await handler.getMantenimientos();
              // PdfReportMantenimiento.generate(data);
            }, 
            icon: Icon(Icons.picture_as_pdf_sharp),
            iconSize: 30,)
        ],
      ),
      body: BlocProvider(
        create: (context) => ValidateCubit(),
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(15,5,15,5),
              height: 60,
              child: SearchBar(
                leading: Icon(Icons.search),
                backgroundColor: WidgetStateColor.resolveWith(getColor),
                hintText: 'Buscar producto...',
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                    producto = getAllProducto();
                  });
                },
              )
            ),

            // const SizedBox(height:5),

            FutureBuilder(
              future: producto, 
              builder: (context, snapshot) {
              if ( snapshot.connectionState == ConnectionState.waiting ){
                return const CircularProgressIndicator();
              } else if ( snapshot.hasData && snapshot.data!.isEmpty) {
                return const Center(child: Text('No hay productos', style: TextStyle(fontSize: 30),));
              }else if ( snapshot.hasError ) {
                return Text( snapshot.error.toString() );
              } else {
                final items = snapshot.data ?? <Inventariodb>[];
                return Flexible(
                  child: MasonryGridView.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return GestureDetector(
                        onLongPress: () => mostrarAcciones(item),
                        onTap: () => mostrarDetalles(item),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.asset(
                                  'assets/images/imagen.jpg',
                                  width: 100,
                                  height: 100,
                                  fit: BoxFit.cover,
                                ),
                                SizedBox(height: 5),
                                Text('\$${item.precio}', style: TextStyle(fontSize: 20),),
                                SizedBox(height: 2),
                                Text(item.producto, style: TextStyle(fontSize: 20)),
                                SizedBox(height: 2),
                                Text(item.cantidad.toInt().toString(), style: TextStyle(fontSize: 20))
                                ],
                              ),
                            ),
                        ),
                      );
                    },
                  ),
                );
              }
            }),
          ]
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            tooltip: 'Nuevo producto',
            onPressed: (){
              context.push('/new-inventario');
            },
            child: Icon(
              Icons.add,
              size: 40,
            ),
          )
        ],
      ),
    );
  }
}
