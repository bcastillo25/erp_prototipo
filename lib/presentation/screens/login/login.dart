import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/users.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        body: BlocProvider(
          create: (context) => ValidateCubit(),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox( height: 80),
          
                Image.asset(
                  'assets/images/logo.png',
                  width: 270,
                  height: 270,
                  fit: BoxFit.contain,
                ),
          
                Container(
                  height: size.height - 340,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(0))
                  ),
                  child: LoginView(),
                )
              ]
            ),
          ),
        ),
      ),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

    @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {

  final email = TextEditingController();
  final password = TextEditingController();

  bool visible = true;

  bool isLoginTrue = false;

  final db = DatabaseHelper();
  login() async{
    var res = await db.login(
      Users(email: email.text, password: password.text));
    if (res == true) {
      if(!mounted) return;
      context.go('/home');
    } else {
      setState(() {
        isLoginTrue = true;
        showDialog(
          context: context, 
          builder: (context) => AlertDialog(
            title: Text('Credenciales incorrectas'),
            content: Text('Usuario o contraseña no válido'),
            actions:<Widget> [
              CustomFilledButton(
                buttonColor: Colors.transparent,
                text: 'ACEPTAR',
                textStyle: TextStyle(color: Colors.blue),
                onPressed:() => context.pop(),  
              )
            ],
          ),
          );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

  final textStyle = Theme.of(context).textTheme;
    final validate = context.watch<ValidateCubit>();
    final valemail = validate.state.email;
    final valpassword = validate.state.password;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          const SizedBox( height: 20),
          Text('Bienvenido', style: textStyle.titleLarge),
          const SizedBox(height: 90),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text('Usuario', style: textStyle.titleSmall),
            ]
          ),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: CustomTextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: email,
              onChanged: validate.emailChanged,
              errorMessage: valemail.errorMessage,
            ),
          ),
      
          const SizedBox( height: 20),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [Text('Contraseña', style: textStyle.titleSmall),
            ]
          ),

          SizedBox(
            width: double.infinity,
            height: 55,
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
            ),
          ),
          const SizedBox( height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => context.push('/rest-password'), 
                child: Text('Olvidaste tu contraseña?', style: textStyle.titleSmall,)
              )
            ],
          ),

          const Spacer( flex: 2),
      
          SizedBox(
            width: double.infinity,
            height: 60,
            child: CustomFilledButton(
              text: 'Iniciar Sesión' ,
              textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
              buttonColor: Color.fromARGB(255, 243, 175, 74),
              onPressed: (){
                login();
                validate.onSubmit();
              },
            ),
          ),
      
          // const Spacer( flex: 1),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('¿No tienes cuenta?', style: textStyle.titleSmall),
              TextButton(
                onPressed: () => context.go('/register'), 
                child: const Text('Registrate', style: TextStyle( fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white))
              )
            ],

          ),

          const Spacer( flex: 1),
        ],
      ),
    );
  }
  
}
