import 'package:erp_prototipo/presentation/widgets/inputs/custom_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Egresos extends StatefulWidget {

  const Egresos({super.key});
  
  @override
  State<Egresos> createState() => _EgresosState();

}

class _EgresosState extends State<Egresos>{

  String? selectedItem;
  final mes = TextEditingController();

  @override
  Widget build(BuildContext context) {

     final textStyle = Theme.of(context).textTheme;
     const radius = Radius.circular(30);
    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Color.fromARGB(255, 51, 128, 124);
      }
      return Colors.black;
    }

    return Scaffold(
      bottomNavigationBar: CustomBottomNavigation(),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        title: Center(
          child: Text('Egresos',
            style: textStyle.titleMedium)),
        actions: [
          IconButton(
            onPressed: (){}, 
            icon: Icon(Icons.picture_as_pdf_sharp),
            iconSize: 30,)
        ],
      ),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          children: [
            SizedBox(height: 10),
             Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(bottomLeft: radius, bottomRight: radius, topLeft: radius, topRight: radius ),
                    color: Colors.white,
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23),
                      labelText: 'Seleccione el mes',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.only(bottomLeft: radius,bottomRight: radius,topLeft: radius,topRight: radius),
                      )
                    ),
                    value: selectedItem,
                    items:['  Enero', '  Febrero', '  Marzo',
                      '  Abril', '  Mayo', '  Junio', '  Julio',
                      '  Agosto', '  Septiembre', '  Octubre',
                      '  Noviembre', '  Diciembre']
                    .map((String value){
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value, style: TextStyle(fontSize: 20, color: Colors.black) )
                      );
                    }).toList(), 
                    onChanged: (String? valueIn) {
                      setState(() {
                        selectedItem = valueIn;
                        mes.text = valueIn ?? '';
                      });
                    },
                    validator: (value) {
                      if(value == null || value.isEmpty) {
                        return 'Seleccione una opción';
                      }
                      return null;
                    },
                    ),
                  ),
                  SizedBox(height: 10),
            Row(
              children: [
                Container(
                  width: 140,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextButton(
                    style: ButtonStyle(foregroundColor: WidgetStateColor.resolveWith(getColor)),
                    child: Text('Estadistica', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    onPressed: (){
                      context.go('/finanzas');
                    },
                  ),
                ),
                Spacer(),
                Container(
                  width: 140,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextButton(
                    style: ButtonStyle(foregroundColor: WidgetStateColor.resolveWith(getColor)),
                    child: Text('Ingresos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    onPressed: (){
                      context.go('/ingresos');
                    },
                  ),
                ),
                Spacer(),
                Container(
                  width: 140,
                  height: 60,
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: TextButton(
                    style: ButtonStyle(foregroundColor: WidgetStateColor.resolveWith(getColor)),
                    child: Text('Egresos', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    onPressed: (){
                      context.go('/egresos');
                    },
                  ),
                )
              ],
            ),
            Divider(
              height: 0,
              thickness: 2,
              color: Color.fromARGB(255, 51, 128, 124),
            ),
            Container(
              padding: EdgeInsets.zero,
              child: _TableView(),
            )
          ]
        ),
      ),
    );
  }
}

class _TableView extends StatelessWidget {
  const _TableView();

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    Color getColor(Set<WidgetState> states) {
      return Colors.white;
    }

    return SafeArea(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                DataTable(
                  dividerThickness: 2,
                  dataRowMinHeight: 45,
                  headingRowHeight: 45,
                  columnSpacing: 80,
                  showBottomBorder: true,
                  dataRowColor: WidgetStateColor.resolveWith(getColor),
                  // headingRowColor: WidgetStateColor.resolveWith(getColor),
                  // border: TableBorder(
                  //   top: BorderSide(width: 2),
                  //   left: BorderSide(width: 2),
                  //   right: BorderSide(width: 2),
                  //   bottom: BorderSide(width: 2),
                  //   verticalInside: BorderSide(width: 2),
                  //   horizontalInside: BorderSide(width: 2)
                  // ),
                  columns: [
                    DataColumn(
                      label: Text('Fecha', style: textStyle.labelSmall,),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Descripción', style: textStyle.labelSmall,),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Total', style: textStyle.labelSmall,),
                      numeric: true,
                    ),
                  ], 
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('12/04/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('25/02/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('23654')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('21/02/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('2548')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('19/04/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('01/02/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('23654')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('02/05/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('2548')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('12/03/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('15/02/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('23654')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('02/05/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('2548')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('12/04/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('08/01/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('23654')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('02/01/202')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('2548')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('15/04/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('08/03/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('23654')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('03/02/2025')),
                        DataCell(Center(child: Text('Compra'))),
                        DataCell(Text('2548')),
                      ]
                    ),
                  ]
                ),
              ],
          ),
        ),
    );
  }
}