import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/users.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        appBar: AppBar(
          title: Center(child: Text('Crear Cuenta', style: textStyle.titleLarge)),
          backgroundColor: Color.fromARGB(255, 51, 128, 124),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        body: BlocProvider(
          create: (context) => ValidateCubit(),
          child: _RegisterView()
        )
      ),
    );
  }
}


class _RegisterView extends StatelessWidget {
  const _RegisterView();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [

              const SizedBox(height: 20),

              Image.asset(
                'assets/images/logo.png',
                width: 190,
                height: 190,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 60),

              Container(
                height: size.height - 230,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(0))
                ),
                child: RegisterForm(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

    @override
  State<RegisterForm> createState() => _RegisterFormState();

}

class _RegisterFormState extends State<RegisterForm> {

  final formKey = GlobalKey<FormState>();
  final  fullName = TextEditingController();
  final  email = TextEditingController();
  final  password = TextEditingController();
  final  confPassword = TextEditingController();

  bool visible = true;
  bool visiblep = true;

  final db = DatabaseHelper();

  register() async {
    var res = await db.createUser(
      Users(fullName: fullName.text, email: email.text, password: password.text));
    if(res>0){
      if(!mounted) return;
      context.go('/');
    }
  }
  @override
  void dispose() {
    password.dispose();
    confPassword.dispose();
    super.dispose();
  }

  // void validatePass() {
  //   if ( formKey.currentState!.validate()) return;
  // }

  String hasPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final validate = context.watch<ValidateCubit>();
    final fullNameval = validate.state.userName;
    final emailval = validate.state.email;
    final passwordval = validate.state.password;
    final confPasswordval = validate.state.confirPassword;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [

          Row(
            children: [
              Text('Nombre', style: textStyle.titleSmall)
            ],
          ), 
          SizedBox(
            width: double.infinity,
            height: 55,
            child: CustomTextFormField(
              controller: fullName,
              onChanged: validate.userNameChanged,
              errorMessage: fullNameval.errorMessage,
            ),
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              Text('Correo', style: textStyle.titleSmall)
            ],
          ), 
          SizedBox(
            width: double.infinity,
            height: 55,
            child: CustomTextFormField(
              controller: email,
              onChanged: validate.emailChanged,
              errorMessage: emailval.errorMessage,
            ),
          ),

          SizedBox(height: 20),

          Row(
            children: [
              Text('Contraseña', style: textStyle.titleSmall)
            ],
          ), 
          SizedBox(
            width: double.infinity,
            height: 55,
            child: CustomTextFormField(
              controller: password,
              obscureText: visible,
              onChanged: validate.passwordChanged,
              errorMessage: passwordval.errorMessage,
              icon: IconButton(
                icon: Icon(visible ? Icons.visibility : Icons.visibility_off),
                onPressed: (){
                  setState(() {
                    visible = !visible;
                  });
                },
              ),
              validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Ingresa la contraseña';
                  }
                  return null;
                },
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Text('Confirmar Contraseña', style: textStyle.titleSmall)
            ],
          ), 
          SizedBox(
            width: double.infinity,
            height: 55,
            child: CustomTextFormField(
              controller: confPassword,
              obscureText: visiblep,
              onChanged: validate.confirPasswordChanged,
              errorMessage: confPasswordval.errorMessage,
              icon: IconButton(
                onPressed: (){
                  setState(() {
                    visiblep = !visiblep;
                  });
                }, 
                icon: Icon(visiblep ? Icons.visibility : Icons.visibility_off)
              ),
              validator: (value) {
                if ( value == null || value.isEmpty ){
                  return 'Confirma Contraseña';
                }
                if ( value != confPassword.text) {
                  return 'Las contraseñas no coinciden';
                }
                return null;
              },
            ),
          ),

          const SizedBox(
            height: 100,
          ),

          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Crear Cuenta',
              textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
              buttonColor: Color.fromARGB(255, 243, 175, 74),
              // Color.fromARGB(255, 243, 175, 74)
              onPressed: (){
                  validate.onSubmit();
                  // validatePass();
                  register();
              },
            ),
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿Ya tienes cuenta?', style: textStyle.titleSmall),
              TextButton(
                onPressed: (){
                  context.go('/');
                }, 
                child: Text('Iniciar Sesión', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 243, 175, 74)),)
              )
            ],
          ),

          // Spacer(flex: 1)
        ],
      ),
    );
  }

}
