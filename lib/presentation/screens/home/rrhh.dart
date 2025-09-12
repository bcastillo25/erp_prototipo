import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class RecursosHumanos extends StatefulWidget {

  const RecursosHumanos({super.key});

  @override
  State<RecursosHumanos> createState() => _RecursosHumanosState();
}

class _RecursosHumanosState extends State<RecursosHumanos> {
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
          child: Text('Recursos Humanos',
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
              context.push('/new-rrhh');
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
    recursos = handler.getRecursosH();

    handler.initDB().whenComplete((){
      recursos = getAllRecursosH();
    });
    super.initState();
  }

  late DatabaseHelper handler;
  late Future<List<Rrhhdb>> recursos;
  final db = DatabaseHelper();
  String _search = '';

  Future<List<Rrhhdb>> getAllRecursosH() {
    if (_search.isEmpty) {
      return handler.getRecursosH();
    } else {
      return handler.searchRecursosH(_search);
    }
  }

  Future<void> _refresh() async {
    setState(() {
      recursos = getAllRecursosH();
    });
  }
  
  void mostrarAcciones(Rrhhdb item) {
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
                context.push('/new-rrhh', extra: item);
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
                    content: Text('¿Esta seguro de eliminar "${item.nombre}" del regristro?'
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
                          db.deleteRecursosH(item.cedula).whenComplete(
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
                padding: EdgeInsets.fromLTRB(15, 5, 15, 5),
                height: 60,
                child: SearchBar(
                  backgroundColor: WidgetStateColor.resolveWith(getColor),
                  leading: const Icon(Icons.search),
                  hintText: 'Buscar empleado...',
                  onChanged: (value) {
                    setState(() {
                      _search = value;
                      recursos = getAllRecursosH();
                    });
                  },
                ),
              ),

              const SizedBox(height: 5),

              FutureBuilder(
                future: recursos, 
                builder: (context, snapshot) {
                if ( snapshot.connectionState == ConnectionState.waiting ){
                  return const CircularProgressIndicator();
                } else if ( snapshot.hasData && snapshot.data!.isEmpty) {
                  return const Center(child: Text('Sin Datos', style: TextStyle(fontSize: 30),));
                }else if ( snapshot.hasError ) {
                  return Text( snapshot.error.toString() );
                } else {
                  final items = snapshot.data ?? <Rrhhdb>[];
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
                          label: Text('Cargo', style: textStyle.labelSmall,),
                        ),
                        DataColumn(
                          label: Text('Estado', style: textStyle.labelSmall,),
                        ),
                      ], 
                      rows: items.map((item){
                        return DataRow(
                          onLongPress: () => mostrarAcciones(item),
                          cells: [
                            DataCell(Text(item.cedula, textAlign: TextAlign.right)),
                            DataCell(Text(item.nombre, textAlign: TextAlign.right)),
                            DataCell(Text(item.cargo, textAlign: TextAlign.right)),
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