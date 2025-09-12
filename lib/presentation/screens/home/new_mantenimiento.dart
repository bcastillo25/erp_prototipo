import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewMantenimiento extends StatefulWidget {
  final Mantenimientodb? mantenimiento;
  const NewMantenimiento({super.key, this.mantenimiento});

  @override
  State<NewMantenimiento> createState() => _NewMantenimientoState();
}

class _NewMantenimientoState extends State<NewMantenimiento> {
  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final isEditing = widget.mantenimiento != null;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 51, 128, 124),
          title: Center(
            child: Text('Mantenimiento',
              style: textStyle.titleMedium)),
        ),
        body: BlocProvider(
          create: (context) => ValidateCubit(),
          child: SingleChildScrollView(
            physics: ClampingScrollPhysics(),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  width: double.infinity,
                  height: 60,
                  child: Center(
                    child: Text( isEditing ? 
                      'Editar el equipo' :
                      'Ingrese el nuevo equipo', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold),))
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: _FormView(widget.mantenimiento),
                )
              ]
            ),
          ),
        ),        
      ),
    );
  }
}

class _FormView extends StatefulWidget {
  final Mantenimientodb? mantenimiento;
  const _FormView(this.mantenimiento);

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {

  final equipo = TextEditingController();
  final fecha = TextEditingController();
  final estado = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.mantenimiento != null) {
      equipo.text = widget.mantenimiento!.equipo;
      fecha.text = widget.mantenimiento!.fechaSal;
      estado.text = widget.mantenimiento!.estado;
      selectedItem = widget.mantenimiento!.estado;
    }
  }

  final db = DatabaseHelper();

  createOrUpdateMantenimiento() async {
    if (widget.mantenimiento == null) {
      await db.createMantenimiento(
        Mantenimientodb(
          equipo: equipo.text, 
          fechaSal: fecha.text, 
          estado: estado.text
        )
      );
    } else {
      await db.updateMantenimiento(
        equipo.text, 
        fecha.text, 
        estado.text, 
        widget.mantenimiento!.manId
      );
    }
    if (!mounted) return;
    context.push('/mantenimiento');
  }

  DateTime? selectedDate;

  String? selectedItem;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(1950), 
      lastDate: DateTime.now()
    );
    if (pickedDate != null && pickedDate != selectedDate){
      setState(() {
        selectedDate = pickedDate;
        fecha.text = "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      });
    }
  }

  @override
  void dispose() {
    estado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isEditing = widget.mantenimiento != null;

    final textStyle = Theme.of(context).textTheme;
    final validate = context.watch<ValidateCubit>();
    final equipom = validate.state.codigo;
    const borderRadius = Radius.circular(10);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CustomTextFormField(
              label: 'Equipo',
              keyboardType: TextInputType.text,
              controller: equipo,
              onChanged: validate.codigoChanged,
              errorMessage: equipom.errorMessage,
            ),
            SizedBox(
              height: 40
            ),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: CustomTextFormField(
                controller: fecha,
                label: 'Fecha de revisión',
                icon: IconButton(onPressed: (){
                  _selectDate();
                }, icon: Icon(Icons.calendar_today_outlined)),
                readOnly: isEditing,
              )
            ),
            SizedBox(
              height: 40
            ),
            Container(
              width: double.infinity,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(bottomLeft: borderRadius, bottomRight: borderRadius, topLeft: borderRadius, topRight: borderRadius),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 10,
                    offset: Offset(0, 5)
                  )
                ]
              ),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23),
                  labelText: 'Estado',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.only(bottomLeft: borderRadius, bottomRight: borderRadius, topLeft: borderRadius, topRight: borderRadius)
                  )
                ),
                value: selectedItem,
                items: [
                  'Reparado',
                  'En Reparación',
                  'Fuera de uso'
                ].map((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 18, color: Colors.black87)) 
                  );
                }).toList(), 
                onChanged: (String? newValue) {
                  setState(() {
                    selectedItem = newValue;
                    estado.text = newValue ?? '';
                  });
                },
                validator: (value) {
                  if ( value == null || value.isEmpty ) {
                    return 'Selecciona una opción';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 400),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                buttonColor: Color.fromARGB(225, 51, 128, 124),
                text: isEditing ? 'Actualizar' : 'Guardar',
                textStyle: textStyle.titleMedium,
                onPressed: (){
                  if ( widget.mantenimiento == null ) {
                    validate.onSubmit();
                    createOrUpdateMantenimiento();
                  } else {
                    createOrUpdateMantenimiento();
                  }
                },
              ),
            ),
            // Spacer(flex: 1),
          ],
      ),
    );
  }
}