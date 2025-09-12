import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_filled_button.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewClientes extends StatefulWidget {
  final Clientesdb? clientes;
  const NewClientes({super.key, this.clientes});

  @override
  State<NewClientes> createState() => _NewClientesState();
}

class _NewClientesState extends State<NewClientes> {
  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final isEditing = widget.clientes != null;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 51, 128, 124),
          title: Center(
            child: Text('Clientes',
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
                      'Editar cliente' :
                      'Ingrese el nuevo cliente', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold),))
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: _FormView(widget.clientes),
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
  final Clientesdb? clientes;
  const _FormView(this.clientes);

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {

  final cedula = TextEditingController();
  final nombre = TextEditingController();
  final apellido = TextEditingController();
  final direccion = TextEditingController();
  final email = TextEditingController();
  final telefono = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.clientes != null) {
      cedula.text = widget.clientes!.cedula;
      nombre.text = widget.clientes!.nombre;
      apellido.text = widget.clientes!.apellido;
      direccion.text = widget.clientes!.direccion;
      email.text = widget.clientes!.email;
      telefono.text = widget.clientes!.telefono;
    }
  }

  final db = DatabaseHelper();

  createOrUpdateCliente() async {
    if (widget.clientes == null) {
      await db.createCliente(
        Clientesdb(
          cedula: cedula.text,
          nombre: nombre.text, 
          apellido: apellido.text, 
          direccion: direccion.text, 
          email: email.text, 
          telefono: telefono.text)
      );
    } else {
      await db.updateCliente(
        nombre.text, 
        apellido.text, 
        direccion.text, 
        email.text, 
        telefono.text, 
        widget.clientes!.cedula
      );
    }
    if (!mounted) return;
    context.push('/clientes');
  }

  @override
  Widget build(BuildContext context) {

    final isEditing = widget.clientes != null;

    final textStyle = Theme.of(context).textTheme;
    final validate = context.watch<ValidateCubit>();
    final cedulac = validate.state.codigo;
    final nombrec = validate.state.userName;
    final apellidoc = validate.state.cantidad;
    final direccionc = validate.state.direccion;
    final emailc = validate.state.email;
    final telefonoc = validate.state.telefono;

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
              errorMessage: cedulac.errorMessage,
              readOnly: isEditing,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Nombres',
              keyboardType: TextInputType.text,
              controller: nombre,
              onChanged: validate.userNameChanged,
              errorMessage: nombrec.errorMessage,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Apellidos',
              keyboardType: TextInputType.text,
              controller: apellido,
              onChanged: validate.cantidadChanged,
              errorMessage: apellidoc.errorMessage,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Dirección',
              keyboardType: TextInputType.text,
              controller: direccion,
              onChanged: validate.direccionChanged,
              errorMessage: direccionc.errorMessage,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Correo',
              keyboardType: TextInputType.text,
              controller: email,
              onChanged: validate.emailChanged,
              errorMessage: emailc.errorMessage,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Teléfono',
              keyboardType: TextInputType.number,
              controller: telefono,
              onChanged: validate.telefonoChanged,
              errorMessage: telefonoc.errorMessage,
            ),
            SizedBox(height: 150),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                buttonColor: Color.fromARGB(225, 51, 128, 124),
                text: isEditing ? 'Actualizar' : 'Guardar',
                textStyle: textStyle.titleMedium,
                onPressed: (){
                  if (widget.clientes == null) {
                    validate.onSubmit();
                    createOrUpdateCliente();
                  } else {
                    createOrUpdateCliente();
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
