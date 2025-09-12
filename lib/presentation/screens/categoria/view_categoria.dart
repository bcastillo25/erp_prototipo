import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Categorias extends StatelessWidget {
  const Categorias({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        title: Center(child: Text('Categorías', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),)),
      ),
      body: _CategoriaView(),
      bottomNavigationBar: CustomBottomNavigation(),
      floatingActionButton: IconButton(
        onPressed: (){
          context.push('/newcategoria');
        }, 
        icon: Icon(Icons.add)
      ),
    );
  } 
}

class _CategoriaView extends StatefulWidget {
  const _CategoriaView();

  @override
  _CategoriaViewState createState() => _CategoriaViewState();
}

class _CategoriaViewState extends State {

  late DatabaseHelper handler;
  late Future<List<Categoria>> categoria;
  final db = DatabaseHelper();
  
  @override
  void initState() {
    handler = DatabaseHelper();
    categoria = handler.getCategorias();

    handler.initDB().whenComplete((){
      categoria = getAllCategoria();
    });
    super.initState();
  }

  Future<List<Categoria>> getAllCategoria() {
    return handler.getCategorias();
  }

  Future<void> _refresh() async{
    setState(() {
      categoria = getAllCategoria();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Categoria>>(
              future: categoria, 
              builder: (BuildContext context, 
                AsyncSnapshot<List<Categoria>> snapshot) {
                  if ( snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty){
                    return const Center(child: Text('Sin Datos'));
                  } else if (snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }else {
                    final items = snapshot.data ?? <Categoria>[];
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          // title: Text(items[index].id!.toString()),
                          title: Text(items[index].categoria),
                          trailing: IconButton(
                            onPressed: (){
                              db.deleteCategoria(items[index].id!.toString())
                                .whenComplete((){
                                  _refresh();
                                });
                            }, 
                            icon: Icon(Icons.delete)
                          ),
                        );
                      },
                    );
                  }
                }
            )
          ),
          // CustomNavigationBar()
        ],
      )
    );
  }
}