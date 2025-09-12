import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Ventas extends StatelessWidget {

  const Ventas({super.key});

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();
    final textStyle = Theme.of(context).textTheme;
    Color getColor(Set<WidgetState> states) {
      return Colors.white;
    }

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        drawer: SideMenu(scaffoldKey: scaffoldKey),
        bottomNavigationBar: CustomBottomNavigation(),
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 51, 128, 124),
          title: Center(
            child: Text('Ventas',
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
              Container(
                alignment: Alignment(0, 0),
                padding: EdgeInsets.fromLTRB(15,5,15,5),
                width: double.infinity,
                height: 60,
                child: SearchBar(
                  backgroundColor: WidgetStateColor.resolveWith(getColor),
                  leading: Icon(Icons.search),
                )
              ),
              SizedBox(height: 0.1),
              Container(
                padding: EdgeInsets.zero,
                child: _TableView(),
              )
            ]
          ),
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              backgroundColor: Colors.white,
              onPressed: (){
                context.push('/new-ventas');
              },
              child: Icon(
                Icons.add,
                size: 40,
              ),
            )
          ],
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
                // Text('data', ),
                DataTable(
                  dividerThickness: 2,
                  dataRowMinHeight: 47,
                  headingRowHeight: 47,
                  columnSpacing: 90,
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
                      label: Text('Factura', style: textStyle.labelSmall, ),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Cliente', style: textStyle.labelSmall,),
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
                        DataCell(Text('fac01')),
                        DataCell(Text('Jon Casco')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac02')),
                        DataCell(Text('Elsa Colta')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac03')),
                        DataCell(Text('Luis Grefa')),
                        DataCell(Text('2500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac04')),
                        DataCell(Text('Marco Casco')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac05')),
                        DataCell(Text('Jony Reyes')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac06')),
                        DataCell(Text('Lucas Grefa')),
                        DataCell(Text('2500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac07')),
                        DataCell(Text('Joel Casco')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac08')),
                        DataCell(Text('Maria Colta')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac09')),
                        DataCell(Text('Doris Grefa')),
                        DataCell(Text('28900')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac10')),
                        DataCell(Text('Brayan Casco')),
                        DataCell(Text('14500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac11')),
                        DataCell(Text('Widy Colta')),
                        DataCell(Text('25050')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac12')),
                        DataCell(Text('Luis Grefa')),
                        DataCell(Text('2050')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac13')),
                        DataCell(Text('Pablo Casco')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac14')),
                        DataCell(Text('Liz Colta')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac15')),
                        DataCell(Text('Jenny Grefa')),
                        DataCell(Text('200')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac16')),
                        DataCell(Text('Irma Casco')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac17')),
                        DataCell(Text('Thiago Colta')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac18')),
                        DataCell(Text('Josue Grefa')),
                        DataCell(Text('200')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac19')),
                        DataCell(Text('Alex Casco')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac20')),
                        DataCell(Text('Alejo Colta')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac21')),
                        DataCell(Text('Kevin Grefa')),
                        DataCell(Text('200')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac22')),
                        DataCell(Text('Lennin Casco')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac23')),
                        DataCell(Text('Jofre Colta')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac24')),
                        DataCell(Text('Domingo Grefa')),
                        DataCell(Text('1200')),
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