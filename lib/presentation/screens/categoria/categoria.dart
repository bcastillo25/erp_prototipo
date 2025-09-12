import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class NewCategoria extends StatelessWidget {
  const NewCategoria({super.key});

  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 51, 128, 124),
          title: Center(
            child: Text('Categoría',
              style: textStyle.titleLarge)),
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
                    child: Text(
                      'Nuevo categoría', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold),))
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: _FormView(),
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
  const _FormView();

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {

  final categoria = TextEditingController();

  final db = DatabaseHelper();

  createCategoria() async {
    var res = await db.createCategoria(
      Categoria( categoria: categoria.text ));
    if(res>0){
      if(!mounted) return;
      context.push('/categoria');
    }
  }

  @override
  Widget build(BuildContext context) {

    final validate = context.watch<ValidateCubit>();
    final categori = validate.state.userName;
    final textStyle = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Column(
          children: [
            SizedBox(
              height: 50,
            ),
            CustomTextFormField(
              label: 'Categoría',
              keyboardType: TextInputType.text,
              controller: categoria,
              onChanged: validate.userNameChanged,
              errorMessage: categori.errorMessage,
            ),
            SizedBox(
              height: 40
            ),
            SizedBox(height: 600),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: CustomFilledButton(
                buttonColor: Color.fromARGB(255, 51, 128, 124),
                text: 'Guardar',
                textStyle: textStyle.titleMedium,
                onPressed: (){
                  validate.onSubmit();
                  createCategoria();
                },
              ),
            ),
            // Spacer(),
          ],
      ),
    );
  }
}