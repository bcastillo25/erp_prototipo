import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_filled_button.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewProveedores extends StatefulWidget {
  final Proveedoresdb? proveedor;
  const NewProveedores({super.key, this.proveedor});

  @override
  State<NewProveedores> createState() => _NewProveedoresState();
}

class _NewProveedoresState extends State<NewProveedores> {
  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final isEditing = widget.proveedor != null;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 51, 128, 124),
          title: Center(
            child: Text('Proveedores',
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
                      'Editar proveedor' :
                      'Ingrese el nuevo proveedor', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold),))
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: _FormView(widget.proveedor),
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
  final Proveedoresdb? proveedor;
  const _FormView(this.proveedor);

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {

  final ruc = TextEditingController();
  final empresa = TextEditingController();
  final direccion = TextEditingController();
  final email = TextEditingController();
  final telefono = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.proveedor != null) {
      ruc.text = widget.proveedor!.ruc;
      empresa.text = widget.proveedor!.empresa;
      direccion.text = widget.proveedor!.direccion;
      email.text = widget.proveedor!.email;
      telefono.text = widget.proveedor!.telefono;
    }
  }

  final db = DatabaseHelper();

  createOrUpdateEmpresa() async {
    if (widget.proveedor == null) {
      await db.createProveedores(
        Proveedoresdb(
          ruc: ruc.text,
          empresa: empresa.text, 
          direccion: direccion.text, 
          email: email.text, 
          telefono: telefono.text
        )
      );
    } else {
      await db.updateProveedores(
        empresa.text, 
        direccion.text, 
        email.text, 
        telefono.text, 
        widget.proveedor!.ruc 
      );
    }
    if (!mounted) return;
    context.push('/proveedores');
  }

  @override
  Widget build(BuildContext context) {

    final isEditing = widget.proveedor != null;

    final textStyle = Theme.of(context).textTheme;
    final validate = context.watch<ValidateCubit>();
    final rucp = validate.state.codigo;
    final empresap = validate.state.userName;
    final direccionp = validate.state.direccion;
    final emailp = validate.state.email;
    final telefonop = validate.state.telefono;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CustomTextFormField(
              label: 'RUC',
              keyboardType: TextInputType.text,
              controller: ruc,
              onChanged: validate.codigoChanged,
              errorMessage: rucp.errorMessage,
              readOnly: isEditing,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Empresa',
              keyboardType: TextInputType.text,
              controller: empresa,
              onChanged: validate.userNameChanged,
              errorMessage: empresap.errorMessage,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Dirección',
              keyboardType: TextInputType.text,
              controller: direccion,
              onChanged: validate.direccionChanged,
              errorMessage: direccionp.errorMessage,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Correo',
              keyboardType: TextInputType.emailAddress,
              controller: email,
              onChanged: validate.emailChanged,
              errorMessage: emailp.errorMessage,
            ),
            SizedBox(
              height: 40
            ),
            CustomTextFormField(
              label: 'Teléfino',
              keyboardType: TextInputType.number,
              controller: telefono,
              onChanged: validate.telefonoChanged,
              errorMessage: telefonop.errorMessage,
            ),
            SizedBox(height: 250),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                buttonColor: Color.fromARGB(225, 51, 128, 124),
                text: isEditing ? 'Actualizar' : 'Guardar',
                textStyle: textStyle.titleMedium,
                onPressed: (){
                  if (widget.proveedor == null ) {
                    validate.onSubmit();
                    createOrUpdateEmpresa();
                  } else {
                    createOrUpdateEmpresa();
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