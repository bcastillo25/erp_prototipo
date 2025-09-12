import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewPassword extends StatelessWidget {
  const NewPassword({super.key});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return BlocProvider( 
      create: (context) => ValidateCubit(),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Color.fromARGB(255, 51, 128, 124),
          title: Center(
            child: Text('Crear nueva contraseña',
            style: textStyle.titleMedium),
          ),
        ),
        body: const PasswordView(email: '',)
      ),
    );
  }
}

class PasswordView extends StatefulWidget {
  final String email;
  const PasswordView({super.key, required this.email});

  @override
  State<PasswordView> createState() => _PasswordViewState();
}

class _PasswordViewState extends State<PasswordView> {
  
  final formKey = GlobalKey<FormState>();
  final password = TextEditingController();
  final confir = TextEditingController();
  bool visible = true;

  Future<void> cambiarPassword() async {
    final nueva = password.text.trim();
    await DatabaseHelper().actualizarPassword(widget.email, nueva);
    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Contraseña actualizada.')));
    // ignore: use_build_context_synchronously
    context.push('/');
  }

  @override
  void dispose() {
    password.dispose();
    confir.dispose();
    super.dispose();
  }

  void validatePass() {
    if ( formKey.currentState!.validate()) return;
  }

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final validate = context.watch<ValidateCubit>();
    final valpassword = validate.state.password;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 30),
                Image.asset(
                  'assets/images/pass.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),
      
                const SizedBox(height: 50),
      
                Text('La contraseña debe contener mínimo 8 caracteres entre letras, números y símbolos.',
                  style: textStyle.titleSmall,
                  textAlign: TextAlign.justify,),
      
                const SizedBox(height: 50),

                Row(
                  children: [
                    Text('Nueva contraseña',
                      style: textStyle.titleSmall)
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: CustomTextFormField(
                    keyboardType: TextInputType.text,
                    controller: password,
                    onChanged: validate.passwordChanged,
                    errorMessage: valpassword.errorMessage,
                    obscureText: visible,
                    icon: IconButton(onPressed: (){
                      setState(() {
                        visible = !visible;
                      });
                    }, icon: Icon(visible ? Icons.visibility : Icons.visibility_off)),
                    validator: (value) {
                      if (value == null || value.isEmpty){
                        return 'Ingresa la contraseña';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    Text('Confirmar contraseña',
                      style: textStyle.titleSmall)
                  ],
                ),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: CustomTextFormField(
                    keyboardType: TextInputType.text,
                    controller: password,
                    onChanged: validate.passwordChanged,
                    errorMessage: valpassword.errorMessage,
                    obscureText: visible,
                    icon: IconButton(onPressed: (){
                      setState(() {
                        visible = !visible;
                      });
                    }, icon: Icon(visible ? Icons.visibility : Icons.visibility_off)),
                    validator: (value) {
                      if ( value == null || value.isEmpty ){
                        return 'Confirma tu contraseña';
                      }
                      if ( value != password.text) {
                        return 'La contraseña mo coincide';
                      }
                      return null;
                    },
                  ),
                ),

                SizedBox(height: 170),
                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: CustomFilledButton(
                    buttonColor: Color.fromARGB(255, 243, 175, 74),
                    text: 'Guardar',
                    textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                    onPressed: (){
                      validate.onSubmit();
                      validatePass();
                      cambiarPassword();
                    },),
                )
      
              ],
            ),
          ),
        ),
      ),
    );
  }
}
