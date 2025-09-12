import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/users.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_bottom_navigation.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/side_menu.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ViewUsers extends StatelessWidget {
  const ViewUsers({super.key});

  

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        title: Center(child: Text('Usuarios', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: Colors.white),)),
      ),
      body: _UsersView(),
      bottomNavigationBar: CustomBottomNavigation(),
      floatingActionButton: IconButton(
        onPressed: ()=> context.push('/categoria'), 
        icon: Icon(Icons.category_sharp)
      ),
    );
  } 
}

class _UsersView extends StatefulWidget {
  const _UsersView();

  @override
  _UsersViewState createState() => _UsersViewState();
}

class _UsersViewState extends State {

  late DatabaseHelper handler;
  late Future<List<Users>> user;
  final db = DatabaseHelper();
  
  @override
  void initState() {
    handler = DatabaseHelper();
    user = handler.getUsers();

    handler.initDB().whenComplete((){
      user = getAllUsers();
    });
    super.initState();
  }

  Future<List<Users>> getAllUsers() {
    return handler.getUsers();
  }

  Future<void> _refresh() async{
    setState(() {
      user = getAllUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Users>>(
              future: user, 
              builder: (BuildContext context, 
                AsyncSnapshot<List<Users>> snapshot) {
                  if ( snapshot.connectionState == ConnectionState.waiting){
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasData && snapshot.data!.isEmpty){
                    return const Center(child: Text('Sin Datos'));
                  } else if (snapshot.hasError){
                    return Text(snapshot.error.toString());
                  }else {
                    final items = snapshot.data ?? <Users>[];
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(items[index].fullName!),
                          subtitle: Text(items[index].email),
                          trailing: IconButton(
                            onPressed: (){
                              db.deleteUser(items[index].usrId!)
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