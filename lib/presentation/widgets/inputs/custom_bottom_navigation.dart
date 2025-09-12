import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavigation extends StatefulWidget {
  const CustomBottomNavigation({
      super.key, 
    });

  @override
  CustomBottomNavigationState createState() => CustomBottomNavigationState();
}

class CustomBottomNavigationState extends State<CustomBottomNavigation> {

  @override
  Widget build(BuildContext context) {
    return GNav(
      backgroundColor: Colors.white,
      tabBorderRadius: 20,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      tabs: [
        GButton(
          hoverColor: Color.fromARGB(255, 51, 128, 124),
          rippleColor: Color.fromARGB(255, 51, 128, 124),
          icon: Icons.inventory_outlined,
          // leading: Text('Inventario'),
          iconSize: 30,
          onPressed: (){
            context.push('/inventario');
          },
        ),
        GButton(
          hoverColor: Color.fromARGB(255, 51, 128, 124),
          rippleColor: Color.fromARGB(255, 51, 128, 124),
          icon: Icons.bar_chart_rounded,
          // leading: Text('Finanzas'),
          iconSize: 30,
          onPressed: (){
            context.push('/finanzas');
          },
        ),
        GButton(
          hoverColor: Color.fromARGB(255, 51, 128, 124),
          rippleColor: Color.fromARGB(255, 51, 128, 124),
          iconColor: Color.fromARGB(255, 51, 128, 124),
          icon: Icons.home_rounded,
          // leading: Text('Inicio'),
          iconSize: 40,
          onPressed: (){
            context.push('/home');
          },
        ),
        GButton(
          hoverColor: Color.fromARGB(255, 51, 128, 124),
          rippleColor: Color.fromARGB(255, 51, 128, 124),
          icon: Icons.store_mall_directory_sharp,
          // leading: Text('Ventas'),
          iconSize: 30,
          onPressed: (){
            context.push('/ventas');
          },
        ),
        GButton(
          hoverColor: Color.fromARGB(255, 51, 128, 124),
          rippleColor: Color.fromARGB(255, 51, 128, 124),
          icon: Icons.shopify,
          // leading: Text('Proveedor'),
          iconSize: 30,
          onPressed: (){
            context.push('/proveedores');
          },
        ),
      ]);
  }
}