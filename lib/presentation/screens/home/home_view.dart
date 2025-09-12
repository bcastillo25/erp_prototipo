import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        title: Center(child: Text('Inicio',
          style: textStyle.titleMedium)),
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 40,
            ),
            Container(
              width: double.infinity,
              height: 60,
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text('Bienvenido', 
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, fontFamily: GoogleFonts.inter().toString())),
            ),
            
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: _HomeView(),
            ),
          ],
        ),
      )
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20),
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/inventario'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color.fromARGB(255, 243, 175, 74),
                            width: 5,
                          )
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/inventario.png',
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                  child: Text('Inventario', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold
                                  ),),
                                )
                            ),
                          ]
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 40),

                  GestureDetector(
                    onTap: () => context.push('/ventas'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color.fromARGB(255, 243, 175, 74),
                           width: 5
                          )
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/venta.png',
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                  child: Text('Ventas', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold
                                  ),),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              SizedBox(height: 40),

              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/compras'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color.fromARGB(255, 243, 175, 74),
                           width: 5
                          )
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/compra.png',
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                  child: Text('Compras', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold
                                  ),),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 40),

                  GestureDetector(
                    onTap: () => context.push('/proveedores'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color.fromARGB(255, 243, 175, 74),
                           width: 5
                          )
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/proveedor.png',
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                  child: Text('Proveedores', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold
                                  ),),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              SizedBox( height: 40),

              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.push('/finanzas'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color.fromARGB(255, 243, 175, 74),
                           width: 5
                          )
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/finanza.png',
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                  child: Text('Finanzas', style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold
                                  ),),
                                )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(width: 40),

                  GestureDetector(
                    onTap: () => context.push('/clientes'),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                      ),
                      child: Container(
                        width: 190,
                        height: 190,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(
                            color: Color.fromARGB(255, 243, 175, 74),
                           width: 5
                          )
                        ),
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/cliente.png',
                              width: 130,
                              height: 130,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 50,
                              child: Center(
                                child: Text('Clientes', style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold
                                ),),
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}