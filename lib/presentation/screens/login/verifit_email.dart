import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class VerifitEmail extends StatefulWidget {
  const VerifitEmail({super.key});

  @override
  State<VerifitEmail> createState() => VerifitEmailState();
}

class VerifitEmailState extends State<VerifitEmail> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Color.fromARGB(255, 51, 128, 124),
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 51, 128, 124),
        iconTheme: IconThemeData(color: Colors.white),
        title: Center(
          child: Text(
            'Verificar correo electrónico',
            style: textStyle.titleMedium,
          ),
        ),
      ),
      body: BlocProvider(
        create: (context) => ValidateCubit(),
        child: EmailView(codigoenviado: ''),
      ),
    );
  }
}

class EmailView extends StatefulWidget {
  final String codigoenviado;
  const EmailView({super.key, required this.codigoenviado});

  @override
  State<EmailView> createState() => _EmailViewState();
}

class _EmailViewState extends State<EmailView> {
  final codigo = TextEditingController();

  void verificarCodigo() {
    if (codigo.text.trim() == widget.codigoenviado) {
      context.push('/new-password');
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Código incorrecto.')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    final validate = context.watch<ValidateCubit>();
    final codigov = validate.state.codigo;

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
                  'assets/images/email.png',
                  width: 250,
                  height: 250,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 30),

                Text(
                  'Ingrese el código de 4 digitos enviado a su correo eléctronico',
                  style: textStyle.titleSmall,
                ),

                const SizedBox(height: 100),

                Row(
                  children: [
                    SizedBox(width: 60),
                    SizedBox(
                      width: 240,
                      height: 60,
                      child: CustomTextFormField(
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.number,
                        controller: codigo,
                        onChanged: validate.codigoChanged,
                        errorMessage: codigov.errorMessage,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 50),

                const SizedBox(height: 180),

                SizedBox(
                  width: double.infinity,
                  height: 60,
                  child: CustomFilledButton(
                    buttonColor: Color.fromARGB(255, 243, 175, 74),
                    text: 'Verificar',
                    textStyle: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.black),
                    onPressed: () {
                      validate.onSubmit();
                      verificarCodigo();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
