import 'dart:math';

import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/Inputs/email_service.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RestPassword extends StatelessWidget {
  const RestPassword({super.key});

  @override
  Widget build(BuildContext context) {
    
    final textStyle = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: ()=> FocusManager.instance.primaryFocus?.unfocus(),
      child: BlocProvider(
        create: (context) => ValidateCubit(),
        child: Scaffold(
          backgroundColor: Color.fromARGB(255, 51, 128, 124),
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 51, 128, 124),
            iconTheme: IconThemeData(color: Colors.white),
            title: Center(
              child: Text(
                'Recuperar Contraseña', 
                style: textStyle.titleMedium)),
          ),
          body:  const ResetView()),
      ),
    );
  }
}

class ResetView extends StatelessWidget {
  const ResetView({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final textStyle = Theme.of(context).textTheme;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox( height: 30,),

              Image.asset(
                'assets/images/pass.png',
                width: 250,
                height: 250,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 20),

              Text('Ingrese su correo electrónico vinculado con su cuenta, a la cual enviaremos un codigo.',
                style: textStyle.titleSmall),

              const SizedBox(height: 40),

              Container(
                height: size.height - 290 ,
                width: double.infinity,
                decoration: BoxDecoration(),
                child: EmailForm()),
            ],
          ),
        ),
      ),
    );
  }
}

class EmailForm extends StatefulWidget {
  const EmailForm({super.key});

  @override
  State<EmailForm> createState() => EmailFormState();
}

class EmailFormState extends State<EmailForm> {

  String? codigoGenerado;
  final email = TextEditingController();

  Future<void> enviarCodigo() async {
    final correo = email.text.trim();
    final existe = await DatabaseHelper().usuarioExiste(correo);
    if (!existe){
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Correo no registrado')));
      return;
    }

    codigoGenerado = (Random().nextInt(9000) + 1000).toString();

    final enviado = await EmailService.enviar(correo, codigoGenerado!);
    if (enviado){
      // ignore: use_build_context_synchronously
      context.push('/verifit');
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al enviar el código')));
    }
  }

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final validate = context.watch<ValidateCubit>();
    final valemail = validate.state.email;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [

          Row(
            children: [Text('Correo Electrónico', style: textStyle.titleSmall),
          ]), 

          CustomTextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: email,
            onChanged: validate.emailChanged,
            errorMessage: valemail.errorMessage,
            ),

          const SizedBox( height: 320,),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Enviar', 
              textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
              buttonColor: Color.fromARGB(255, 243, 175, 74),
              onPressed: (){
                  validate.onSubmit();
                  enviarCodigo();
              }),
          ),

          Spacer( flex: 1,)
        ],
      ),
    );
  }
}
