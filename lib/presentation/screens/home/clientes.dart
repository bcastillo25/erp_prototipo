import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/clientesdb.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Clientes extends StatelessWidget {

  const Clientes({super.key});

  @override
  Widget build(BuildContext context) {
 
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomBottomNavigation(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        title: Center(
          child: Text('Clientes',
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
      body: const _TableView(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: (){
              context.push('/new-clientes');
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

class _TableView extends StatefulWidget {
  const _TableView();

  @override
  State<_TableView> createState() => _TableViewState();
}

class _TableViewState extends State<_TableView> {

  @override
  void initState() {
    handler = DatabaseHelper();
    cliente = handler.getCliente();

    handler.initDB().whenComplete((){
      cliente = getAllClientes();
    });
    super.initState();
  }

  late DatabaseHelper handler;
  late Future<List<Clientesdb>> cliente;
  final db = DatabaseHelper();
  String _searchQuery = '';

  Future<List<Clientesdb>> getAllClientes() {
    if (_searchQuery.isEmpty) {
      return handler.getCliente();
    } else {
      return handler.searchCliente(_searchQuery);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      cliente = getAllClientes();
    });
  }

  void mostrarAcciones(Clientesdb item) {
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
                context.push('/new-clientes', extra: item);
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
                    content: Text('¿Esta seguro de eliminar "${item.nombre} ${item.apellido}" del regristro?'
                    ),
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
                          db.deleteCliente(item.cedula).whenComplete(
                            () => _refresh(),
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
      }
    );
  }

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    Color getColor(Set<WidgetState> states) {
      return Colors.white;
    }

    return SafeArea(
        child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),  
                height: 60,
                child: SearchBar(
                  backgroundColor: WidgetStateColor.resolveWith(getColor),
                  leading: const Icon(Icons.search),
                  hintText: 'Buscar cliente...',
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      cliente = getAllClientes();
                    });
                  },
                ), 
              ),
              const SizedBox(height: 5),
              FutureBuilder(
                future: cliente, 
                builder: (context, snapshot) {
                if ( snapshot.connectionState == ConnectionState.waiting ){
                  return const CircularProgressIndicator();
                } else if ( snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text('Sin Datos', style: TextStyle(fontSize: 30),));
                }else if ( snapshot.hasError ) {
                  return Text( snapshot.error.toString() );
                } else {
                  final items = snapshot.data ?? <Clientesdb>[];
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dividerThickness: 1,
                      dataRowMinHeight: 47,
                      headingRowHeight: 47,
                      columnSpacing: 40,
                      showBottomBorder: true,
                      dataRowColor: WidgetStateColor.resolveWith(getColor),
                      columns: [
                        DataColumn(
                          label: Text('Cedula', style: textStyle.labelSmall,),
                        ),
                        DataColumn(
                          label: Text('Nombres', style: textStyle.labelSmall,),
                        ),
                        DataColumn(
                          label: Text('Dirección', style: textStyle.labelSmall,),
                        ),
                        DataColumn(
                          label: Text('Teléfono', style: textStyle.labelSmall,),
                        ),
                      ], 
                      rows: items.map((item){
                        return  DataRow(
                          onLongPress: () => mostrarAcciones(item),
                          cells: [
                            DataCell(Text(item.cedula, textAlign: TextAlign.right)),
                            DataCell(Text("${item.nombre} ${item.apellido}", textAlign: TextAlign.right)),
                            DataCell(Text(item.direccion, textAlign: TextAlign.right)),
                            DataCell(Text(item.telefono, textAlign: TextAlign.right)),
                          ]
                        );
                      }).toList()
                    ),
                  );
                }
              })
            ],
        ),
    );
  }
}