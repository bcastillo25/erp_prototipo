import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/activosdb.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_filled_button.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewActivo extends StatefulWidget {
  final Activosdb? activo;
  const NewActivo({super.key, this.activo});

  @override
  State<NewActivo> createState() => _NewActivoState();
}

class _NewActivoState extends State<NewActivo> {
  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final isEditing = widget.activo != null;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(225, 41, 128, 124),
          title: Center(
            child: Text('Activo',
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
                      'Editar activo' :
                      'Ingrese el nuevo activo', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold),))
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: _FormView(widget.activo),
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
  final Activosdb? activo;
  const _FormView(this.activo);

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {

  final codigo = TextEditingController();
  final activo = TextEditingController();
  final ubicacion = TextEditingController();
  final fecha = TextEditingController();
  final estado = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.activo != null) {
      codigo.text = widget.activo!.codigo;
      activo.text = widget.activo!.activo;
      ubicacion.text = widget.activo!.ubicacion;
      selectedItemUbi = widget.activo!.ubicacion;
      fecha.text = widget.activo!.fechaIng;
      estado.text = widget.activo!.estado;
      selectedItem = widget.activo!.estado;
    }
  }

  final db = DatabaseHelper();

  createOrUpdateActivo() async {
    if (widget.activo == null) {
      await db.createActivo(
        Activosdb(
          codigo: codigo.text, 
          activo: activo.text, 
          ubicacion: ubicacion.text, 
          fechaIng: fecha.text, 
          estado: estado.text
        )
      );
    } else {
      await db.updateActivo(
        activo.text, 
        ubicacion.text, 
        fecha.text,
        estado.text,
        widget.activo!.codigo
      );
    }
    if (!mounted) return;
    context.push('/activos');
  }

  DateTime? selectedDate;
  String? selectedItem;
  String? selectedItemUbi;

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
    ubicacion.dispose();
    estado.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isEditing = widget.activo != null;

    final textStyle = Theme.of(context).textTheme;
    final validate = context.watch<ValidateCubit>();
    final codigoa = validate.state.codigo;
    final activoa = validate.state.userName;
    const borderRadius = Radius.circular(10);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CustomTextFormField(
              label: 'Código',
              keyboardType: TextInputType.text,
              controller: codigo,
              onChanged: validate.codigoChanged,
              errorMessage: codigoa.errorMessage,
              readOnly: isEditing,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Activo',
              keyboardType: TextInputType.text,
              controller: activo,
              onChanged: validate.userNameChanged,
              errorMessage: activoa.errorMessage
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
                  labelText: 'Ubicación',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.only(bottomLeft: borderRadius, bottomRight: borderRadius, topLeft: borderRadius, topRight: borderRadius)
                  )
                ),
                value: selectedItemUbi,
                items: [
                  'Gerencia',
                  'Planta baja',
                  'Sala'
                ].map((String valueUbi){
                  return DropdownMenuItem<String>(
                    value: valueUbi,
                    child: Text(valueUbi, style: TextStyle(fontSize: 18, color: Colors.black87))
                  );
                }).toList(), 
                onChanged: (String? newValueUbi){
                  setState(() {
                    selectedItemUbi = newValueUbi;
                    ubicacion.text = newValueUbi ?? '';
                  });
                },
                validator: (valueUbi) {
                  if( valueUbi == null || valueUbi.isEmpty ){
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
                label: 'Fecha de Ingreso',
                icon: IconButton(
                  onPressed: (){
                    _selectDate();
                  }, 
                  icon: Icon(Icons.calendar_today_outlined)
                ),
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
                    borderRadius: BorderRadius.only(bottomLeft: borderRadius, bottomRight: borderRadius, topLeft: borderRadius, topRight: borderRadius)
                  )
                ),
                value: selectedItem,
                items: [
                  'Activo',
                  'Inactivo'
                ].map((String value){
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value, style: TextStyle(fontSize: 18, color: Colors.black87))
                  );
                }).toList(), 
                onChanged: (String? newValue){
                  setState(() {
                    selectedItem = newValue;
                    estado.text = newValue ?? '';
                  });
                },
                validator: (value) {
                  if( value == null || value.isEmpty ){
                    return 'Selecciona una opción';
                  }
                  return null;
                },
              ),
            ),
            SizedBox(height: 250),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                buttonColor: Color.fromARGB(225, 51, 128, 124),
                text:isEditing ? 'Actualizar' : 'Guardar',
                textStyle: textStyle.titleMedium,
                onPressed: (){
                  if (widget.activo == null) {
                    validate.onSubmit();
                    createOrUpdateActivo();
                  } else {
                    createOrUpdateActivo();
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
