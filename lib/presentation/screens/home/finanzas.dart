import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Finanzas extends StatefulWidget {

  const Finanzas({super.key});

  @override
  State<Finanzas> createState() => _FinanzasState();
}

class _FinanzasState extends State<Finanzas> {

  String? selectedItem;
  final mes = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final scaffoldKey = GlobalKey<ScaffoldState>();
    final textStyle = Theme.of(context).textTheme;
    const radius = Radius.circular(30);

    Color getColor(Set<WidgetState> states) {
      const Set<WidgetState> interactiveStates = <WidgetState>{
        WidgetState.pressed,
        WidgetState.hovered,
        WidgetState.focused,
        WidgetState.selected
      };
      if (states.any(interactiveStates.contains)) {
        return Color.fromARGB(255, 51, 128, 124);
      }
      return Colors.black;
    }

    return Scaffold(
      drawer: SideMenu(scaffoldKey: scaffoldKey),
      bottomNavigationBar: CustomBottomNavigation(),
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        title: Center(
          child: Text('Finanzas',
            style: textStyle.titleMedium
          )
        )
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
                      // context.go('/finanzas');
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
                      // context.go('/ingresos');
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
  _TableView();

  final List<_PieData> pieData = [
      _PieData('Ingresos', 1852),
      _PieData('Egresos', 1542)
    ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Center(
          child: Column(
              children: [
                SizedBox(
                  width: 400,
                  height: 400,
                  child: SfCircularChart(
                    palette: [
                      Color.fromARGB(255, 51, 128, 124),
                      Colors.amber,
                    ],
                    title: ChartTitle(text: 'Ingresos y Egresos', textStyle: TextStyle(fontWeight: FontWeight.bold)),
                    legend: Legend(isVisible: true, overflowMode: LegendItemOverflowMode.wrap),
                    series: <CircularSeries>[
                      DoughnutSeries<_PieData, String>(
                        enableTooltip: true,
                        dataSource: pieData,
                        xValueMapper: (_PieData data, _) => data.xData,
                        yValueMapper: (_PieData data, _) => data.yData,
                        dataLabelSettings: DataLabelSettings(isVisible: true)),
                    ]
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text('Total ingreso:  ', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 10),
                    Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color.fromARGB(255, 51, 128, 124),
                          width: 3
                        )
                      ),
                      child: Text('1852', style: TextStyle(fontSize: 20),),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  children: [
                    SizedBox(width: 20),
                    Text('Total egreso :  ', style: TextStyle(fontSize: 20)),
                    SizedBox(width: 10),
                    Container(
                      width: 100,
                      height: 35,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Color.fromARGB(255, 51, 128, 124),
                          width: 3
                        )
                      ),
                      child: Text('1542', style: TextStyle(fontSize: 20),),
                    )
                  ],
                ),
              ],
          ),
        ),
    );
  }
}

class _PieData {
 _PieData(this.xData, this.yData);
 final String xData;
 final num yData;
}