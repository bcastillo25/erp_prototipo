import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/activosdb.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Activo extends StatelessWidget {
  const Activo({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomBottomNavigation(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(225, 51, 128, 124),
        title: Center(
          child: Text('Activos',
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
              context.push('/new-activos');
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
    activo = handler.getActivo();

    handler.initDB().whenComplete((){
      activo = getAllActivo();
    });
    super.initState();
  }

  late DatabaseHelper handler;
  late Future<List<Activosdb>> activo;
  final db = DatabaseHelper();
  String _searchQuery = '';

  Future<List<Activosdb>> getAllActivo() {
    if (_searchQuery.isEmpty) {
      return handler.getActivo();
    } else {
      return handler.searchActivo(_searchQuery);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      activo = getAllActivo();
    });
  }

  void mostrarAcciones(Activosdb item) {
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
                context.push('/new-activos', extra: item);
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
                  builder:
                      (context) => AlertDialog(
                        title: Text('Eliminar'),
                        content: Text(
                          '¿Esta seguro de eliminar "${item.activo}" del registro?',
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
                              db.deleteActivo(item.codigo).whenComplete(
                                () {
                                  _refresh();
                                },
                              );
                              context.pop();
                            },
                          ),
                        ],
                      ),
                );
              },
            ),
          ],
        );
      },
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
                  hintText: 'Buscar activo...',
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                      activo = getAllActivo();
                    });
                  },
                ),
              ),

              const SizedBox( height: 5),

              FutureBuilder(
                future: activo, 
                builder: (context, snapshot) {
                if ( snapshot.connectionState == ConnectionState.waiting ){
                  return const CircularProgressIndicator();
                } else if ( snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text('Sin Datos', style: TextStyle(fontSize: 30),));
                }else if ( snapshot.hasError ) {
                  return Text( snapshot.error.toString() );
                } else {
                  final items = snapshot.data ?? <Activosdb>[];
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      dividerThickness: 1,
                      dataRowMinHeight: 46,
                      headingRowHeight: 46,
                      columnSpacing: 40,
                      showBottomBorder: true,
                      dataRowColor: WidgetStateColor.resolveWith(getColor),
                      columns: [
                        DataColumn(
                          label: Text('Código', style: textStyle.labelSmall,),
                        ),
                        DataColumn(
                          label: Text('Activo', style: textStyle.labelSmall,),
                        ),
                        DataColumn(
                          label: Text('Ubicación', style: textStyle.labelSmall,),
                        ),
                        DataColumn(
                          label: Text('Estado', style: textStyle.labelSmall,),
                        ),
                      ], 
                      rows: items.map((item) {
                        return DataRow(
                          onLongPress: () {
                            mostrarAcciones(item);
                          },
                          cells: [
                            DataCell(Text(item.codigo, textAlign: TextAlign.right)),
                            DataCell(Text(item.activo, textAlign: TextAlign.right)),
                            DataCell(Text(item.ubicacion, textAlign: TextAlign.right)),
                            DataCell(Text(item.estado, textAlign: TextAlign.right)),
                          ]
                        );
                      }).toList()
                    ),
                  );
                }
              }),
            ],
        ),
    );
  }
}