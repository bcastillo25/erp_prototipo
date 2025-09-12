import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Compras extends StatelessWidget {

  const Compras({super.key});

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
            child: Text('Compras',
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
                  leading: Icon(Icons.search),
                  backgroundColor: WidgetStateColor.resolveWith(getColor),
                )
              ),
              SizedBox(height: 5),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2),
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
                context.push('/new-compras');
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
                      label: Text('Factura', style: textStyle.labelSmall),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Empresa', style: textStyle.labelSmall,),
                      numeric: true,
                    ),
                    DataColumn(
                      label: Text('Total', style: textStyle.labelSmall,),
                      numeric: true
                    ),
                  ], 
                  rows: [
                    DataRow(
                      cells: [
                        DataCell(Text('fac01')),
                        DataCell(Text('AgroQuimicos')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac02')),
                        DataCell(Text('Pascal')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac03')),
                        DataCell(Text('BancSpace')),
                        DataCell(Text('2500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac04')),
                        DataCell(Text('Nexus Consultores')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac05')),
                        DataCell(Text('BioNutra')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac06')),
                        DataCell(Text('RedCom Networks')),
                        DataCell(Text('2500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac07')),
                        DataCell(Text('ConstruRed')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac08')),
                        DataCell(Text('EnerGreen')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac09')),
                        DataCell(Text('MundoDigital')),
                        DataCell(Text('28900')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac10')),
                        DataCell(Text('AeroTransporte')),
                        DataCell(Text('14500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac11')),
                        DataCell(Text('AquaPura')),
                        DataCell(Text('25050')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac12')),
                        DataCell(Text('MetroSoluciones')),
                        DataCell(Text('2050')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac13')),
                        DataCell(Text('Alfa y Omega Group')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac14')),
                        DataCell(Text('ServiTotal')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac15')),
                        DataCell(Text('TecnoFusion')),
                        DataCell(Text('200')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac16')),
                        DataCell(Text('FarmaVida')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac17')),
                        DataCell(Text('Inversiones Orbe')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac18')),
                        DataCell(Text('Visionarios Globales')),
                        DataCell(Text('200')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac19')),
                        DataCell(Text('AndesSoft')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac20')),
                        DataCell(Text('Logística Express')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac21')),
                        DataCell(Text('Dinamia Corp')),
                        DataCell(Text('200')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac22')),
                        DataCell(Text('Grupo Altavista')),
                        DataCell(Text('1500')),
                      ]
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac23')),
                        DataCell(Text('EcoIndustria S.A.')),
                        DataCell(Text('2500')),
                      ],
                    ),
                    DataRow(
                      cells: [
                        DataCell(Text('fac24')),
                        DataCell(Text('NovaTech Solutions')),
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
















