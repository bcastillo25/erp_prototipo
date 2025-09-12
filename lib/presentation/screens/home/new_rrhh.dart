import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_filled_button.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewRecursosHumanos extends StatefulWidget {
  final Rrhhdb? recursos;
  const NewRecursosHumanos({super.key, this.recursos});

  @override
  State<NewRecursosHumanos> createState() => _NewRecursosHumanosState();
}

class _NewRecursosHumanosState extends State<NewRecursosHumanos> {
  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final isEditing = widget.recursos != null;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(225, 51, 128, 124),
          title: Center(
            child: Text('Recursos Humanos',
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
                      'Editar trabajador' :
                      'Ingrese el nuevo trabajador', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold),))
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: _FormView(widget.recursos),
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
  final Rrhhdb? recursos;
  const _FormView(this.recursos);

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {

  final cedula = TextEditingController();
  final nombre = TextEditingController();
  final cargo = TextEditingController();
  final fecha = TextEditingController();
  final salario = TextEditingController();
  final estado = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.recursos != null) {
      cedula.text = widget.recursos!.cedula;
      nombre.text = widget.recursos!.nombre;
      cargo.text = widget.recursos!.cargo;
      selectedItem = widget.recursos!.cargo;
      fecha.text = widget.recursos!.fechaIng;
      salario.text = widget.recursos!.salario.toString();
      estado.text = widget.recursos!.estado;
      selectedItems = widget.recursos!.estado;
    }
  }

  final db = DatabaseHelper();

  createOrUpdateRecursosH() async {
    if (widget.recursos == null) {
      await db.createRecursosH(
        Rrhhdb(
          cedula: cedula.text, 
          nombre: nombre.text, 
          cargo: cargo.text, 
          fechaIng: fecha.text, 
          salario: double.parse(salario.text), 
          estado: estado.text
        )
      );
    } else {
      await db.updateRecursosH(
        nombre.text, 
        cargo.text, 
        salario.text, 
        estado.text, 
        widget.recursos!.cedula
      );
    }
    if(!mounted) return;
      context.push('/rrhh');
  }

  DateTime? selectedDate;
  String? selectedItem;
  String? selectedItems;

  Future<void> _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context, 
      initialDate: DateTime.now(),
      firstDate: DateTime(2000), 
      lastDate: DateTime.now()
    );
    if( pickedDate != null && pickedDate != selectedDate){
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

    final isEditing = widget.recursos != null;

    final textStyle = Theme.of(context).textTheme;
    final validate = context.watch<ValidateCubit>();
    final cedular = validate.state.codigo;
    final nombrer = validate.state.userName;
    final salarior = validate.state.precio;
    const borderRadius = Radius.circular(10);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CustomTextFormField(
              label: 'Cedula',
              keyboardType: TextInputType.text,
              controller: cedula,
              onChanged: validate.codigoChanged,
              errorMessage: cedular.errorMessage,
              readOnly: isEditing,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Nombre y Apellido',
              keyboardType: TextInputType.text,
              controller: nombre,
              onChanged: validate.userNameChanged,
              errorMessage: nombrer.errorMessage,
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
                  labelText: 'Cargo',
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.only(bottomLeft: borderRadius, bottomRight: borderRadius, topLeft: borderRadius, topRight: borderRadius)
                  )
                ),
                value: selectedItems,
                items: [
                  'Gerente',
                  'Presidente',
                  'Trabajador'
                ].map((String valueC){
                  return DropdownMenuItem<String>(
                    value: valueC,
                    child: Text(valueC, style: TextStyle(fontSize: 18, color: Colors.black87),)
                  );
                }).toList(), 
                onChanged: (String? newValueC){
                  setState(() {
                    selectedItems = newValueC;
                    cargo.text = newValueC ?? '';
                  });
                },
                validator: (valueC) {
                  if ( valueC == null || valueC.isEmpty ){
                    return 'Selecciona una opción';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(
              height: 40
            ),
            SizedBox(
              height: 55,
              width: double.infinity,
              child: CustomTextFormField(
                controller: fecha,
                label: 'Fecha de ingreso',
                icon: IconButton(
                  onPressed: (){
                    _selectDate();
                  }, icon: Icon(Icons.calendar_today_outlined)),
                  readOnly: isEditing,
              )
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Salario',
              keyboardType: TextInputType.number,
              controller: salario,
              onChanged: validate.precioChanged,
              errorMessage: salarior.errorMessage,
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
                    borderRadius: BorderRadius.only(bottomLeft: borderRadius, bottomRight: borderRadius, topLeft: borderRadius, topRight: borderRadius)
                  )
                ),
                value: selectedItem,
                items: [
                  'Activo',
                  'Inactivo',
                  'Vacaciones'
                ].map((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 18, color: Colors.black87),)
                  );
                }).toList(), 
                onChanged: (String? newValue){
                  setState(() {
                    selectedItem = newValue;
                    estado.text = newValue ?? '';
                  });
                },
                validator: (value) {
                  if ( value == null || value.isEmpty ){
                    return 'Selecciona una opción';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 150),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                buttonColor: Color.fromARGB(225, 51, 128, 124),
                text:isEditing ? 'Actualizar' : 'Guardar',
                textStyle: textStyle.titleMedium,
                onPressed: (){
                  if (!mounted) {
                    validate.onSubmit();
                    createOrUpdateRecursosH();
                  } else {
                    createOrUpdateRecursosH();
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
