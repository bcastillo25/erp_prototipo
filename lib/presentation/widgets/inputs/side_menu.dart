import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SideMenu extends ConsumerStatefulWidget {

  final GlobalKey<ScaffoldState> scaffoldKey;

  const SideMenu( {
    super.key, 
    required this.scaffoldKey,
  });

  @override
  SideMenuState createState() => SideMenuState();
}

 class SideMenuState extends ConsumerState<SideMenu> {

  int navDrawerIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    final hasNotch = MediaQuery.of(context).viewPadding.top > 40;

    return NavigationDrawer(
      backgroundColor: Colors.white,
      elevation: 1,
      selectedIndex: navDrawerIndex,
      onDestinationSelected: (value) {
        setState(() {
          navDrawerIndex = value;
        });

        widget.scaffoldKey.currentState?.closeDrawer();

      },
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(0, hasNotch ? 0 : 5,  0, 0),
          child: Image.asset(
                'assets/images/logo1.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),
        ),
        ListTile(
          leading: Icon(Icons.person),
          title: Text('Usuarios'),
          onTap: () => context.go('/user'),
          enabled: true,
        ),
        ListTile(
          leading: Icon(Icons.inventory_rounded),
          title: Text('Inventario',),
          onTap: () => context.go('/inventario'),
          enabled: true,
        ),
        ListTile(
          leading: Icon(Icons.bar_chart_outlined), 
          title: Text('Finanzas'),
          onTap: () => context.push('/finanzas'),
          enabled: true,
        ),
        ListTile(
          leading: Icon(Icons.shopping_cart_outlined),
          title: Text('Compras',),
          onTap: () => context.push('/compras'),
          enabled: true,
        ),
        ListTile(
          leading: Icon(Icons.store_mall_directory_sharp), 
          title: Text('Ventas'),
          onTap: () => context.push('/ventas'),
          enabled: true,
        ),
        ListTile(
          leading: Icon(Icons.groups_rounded),
          title: Text('RR.HH',),
          onTap: () => context.push('/rrhh'),
          enabled: true,
        ),
        ListTile(
          leading: Icon(Icons.euro_rounded), 
          title: Text('Activos'),
          onTap: () => context.push('/activos'),
          enabled: true,
        ),
        ListTile(
          leading: Icon(Icons.people_outline),
          title: Text('Clientes',),
          onTap: () => context.push('/clientes'),
          enabled: true,
        ),
        ListTile(
          leading: Icon(Icons.shopify), 
          title: Text('Proveedores'),
          onTap: () => context.push('/proveedores'),
          enabled: true,
        ),
        ListTile(
          leading: Icon(Icons.engineering),
          title: Text('Mantenimiento',),
          onTap: () => context.push('/mantenimiento'),
          enabled: true,
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 100, 0, 10),
          child: SizedBox(
            width: double.infinity,
            height: 60,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.transparent,
                alignment: Alignment.center,
              ),
              onPressed: (){
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    content: Text('¿Cerrar la sesiòn de tu cuenta?'),
                    actions: <Widget>[
                       CustomFilledButton(
                        buttonColor: Colors.transparent,
                        text: 'Cancelar',
                        textStyle: TextStyle(color: Colors.black),
                        onPressed: () => context.pop(),
                      ),
                      CustomFilledButton(
                        buttonColor: Colors.transparent,
                        text: 'Salir',
                        textStyle: TextStyle(color: Colors.red),
                        onPressed: () => context.go('/'),
                      ),
                    ],
                  ),
                );
              },
              child: Text('Cerrar Sesión', style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.red),)),
            ),
          )
      ]
    );
  }


 }
  
  
