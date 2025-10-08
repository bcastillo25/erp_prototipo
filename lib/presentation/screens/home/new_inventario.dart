import 'package:erp_prototipo/SQLite/database_helper.dart';
import 'package:erp_prototipo/infrastructure/JSON/jsons.dart';
import 'package:erp_prototipo/presentation/blocs/validad_cubit.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_filled_button.dart';
import 'package:erp_prototipo/presentation/widgets/inputs/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class NewInventario extends StatefulWidget {
  final Inventariodb? producto;
  const NewInventario({super.key, this.producto});

  @override
  State<NewInventario> createState() => _NewInventarioState();
}

class _NewInventarioState extends State<NewInventario> {
  @override
  Widget build(BuildContext context) {

    final textStyle = Theme.of(context).textTheme;
    final isEditing = widget.producto != null;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Color.fromARGB(255, 51, 128, 124),
          title: Center(
            child: Text('Inventario',
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
                      'Editar Producto' :
                      'Ingrese el nuevo producto', 
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold),))
                ),
                Container(
                  padding: EdgeInsets.zero,
                  child: _FormView(widget.producto),
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
  final Inventariodb? producto;
  const _FormView(this.producto);

  @override
  State<_FormView> createState() => _FormViewState();
}

class _FormViewState extends State<_FormView> {

  @override
  void initState() {
    handler = DatabaseHelper();
    categoria = handler.getCategorias();

    handler.initDB().whenComplete((){
      categoria = getAllCategoria();
    });
    super.initState();
    if (widget.producto != null) {
      codigodp.text = widget.producto!.codigo;
      productop.text = widget.producto!.producto;
      categoriap.text = widget.producto!.proid.toString();
      selectedItem = widget.producto!.proid.toString();
      cantidadp.text = widget.producto!.cantidad.toString();
      preciop.text = widget.producto!.precio.toString();
    }
  }

  final codigodp = TextEditingController();
  final productop = TextEditingController();
  final categoriap = TextEditingController();
  final cantidadp = TextEditingController();
  final preciop = TextEditingController();
  final MobileScannerController cameraController = MobileScannerController();

  late DatabaseHelper handler;
  late Future<List<Categoria>> categoria;

  Future<List<Categoria>> getAllCategoria() {
    return handler.getCategorias();
  }

  final db = DatabaseHelper();

  createOrUpdateProducto() async {
    // final existe = await db.existeCodigo(codigodp.text);
    
    if (widget.producto == null) {
      // if (existe) {
      //   showDialog(
      //     // ignore: use_build_context_synchronously
      //     context: context, 
      //     builder: (context) => AlertDialog(
      //       title: Text('Error'),
      //       content: Text('El código ${codigodp.text} ya está registrado.'),
      //       actions: [
      //         TextButton(
      //           onPressed: () => context.pop(), 
      //           child: Text('Acepar')
      //         )
      //       ],
      //     ),
      //   );
      //   return;
      // }
      await db.createProduct(
        Inventariodb(
          codigo: codigodp.text, 
          producto: productop.text, 
          proid: int.parse(categoriap.text),
          cantidad: int.parse(cantidadp.text),
          precio: double.parse(preciop.text)
        )
      );
    } else {
      await db.updateProduct(
        productop.text,
        categoriap.text, 
        cantidadp.text, 
        preciop.text, 
        widget.producto!.codigo
      );
    }
  }

  String? selectedItem;

  @override
  void dispose() {
    productop.dispose();
    cantidadp.dispose();
    preciop.dispose();
    categoriap.dispose();
    codigodp.dispose();
    cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final isEditing = widget.producto != null;

    final validate = context.watch<ValidateCubit>();
    final codigo = validate.state.codigo;
    final producto = validate.state.userName;
    final cantidad = validate.state.cantidad;
    final precio = validate.state.precio;
    final textStyle = Theme.of(context).textTheme;

    Color getColor(Set<WidgetState> states) {
      return Colors.black;
    }

    const borderRadius = Radius.circular(10);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Form(
        child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: CustomTextFormField(
                  label: 'Código',
                  keyboardType: TextInputType.text,
                  controller: codigodp,
                  onChanged: validate.codigoChanged,
                  errorMessage: codigo.errorMessage,
                  readOnly: isEditing,
                  icon: IconButton(
                    icon: Icon(Icons.qr_code_scanner_rounded),
                    onPressed: () async {
                      showScanner(context);
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 40
              ),
              CustomTextFormField(
                label: 'Producto',
                keyboardType: TextInputType.text,
                controller: productop,
                onChanged: validate.userNameChanged,
                errorMessage: producto.errorMessage,
              ),
              SizedBox(
                height: 40
              ),
              Container(
                width: double.infinity,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: borderRadius, topRight: borderRadius, bottomLeft: borderRadius, bottomRight: borderRadius),
                  boxShadow: [ 
                    BoxShadow(
                      color: Colors.black54,
                      blurRadius: 10,
                      offset: Offset(0, 5)
                    )
                  ] 
                ),
                child: FutureBuilder<List<Categoria>>(
                  future: categoria, 
                  builder: (context, snapshot) {
                    if ( snapshot.connectionState == ConnectionState.waiting ){
                      return const CircularProgressIndicator();
                    } else if ( snapshot.hasData && snapshot.data!.isEmpty ) {
                      return const Center(child: Text('Sin Datos'));
                    } else if ( snapshot.hasError ) {
                      return Text(snapshot.error.toString());
                    } else {
                      final items = snapshot.data ?? <Categoria>[];
                      return DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          floatingLabelStyle: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 23),
                          labelText: 'Categoría',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.only(bottomLeft: borderRadius, bottomRight: borderRadius, topLeft: borderRadius, topRight: borderRadius),
                          ),
                          suffix: IconButton(onPressed: (){
                            context.push('/newcategoria');
                          }, icon: Icon(Icons.add))
                        ),
                        value: selectedItem,
                        items: items.map<DropdownMenuItem<String>>((Categoria value){
                          return DropdownMenuItem<String>(
                            value: value.id.toString(),
                            child: Text(value.categoria, style: TextStyle(color: WidgetStateColor.resolveWith(getColor), fontSize: 18),)
                          );
                        }).toList(), 
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedItem = newValue;
                            categoriap.text = newValue ?? '';
                          });
                        }
                      );
                    } 
                  },
                ),
              ),
              SizedBox(
                height: 40
              ),
              CustomTextFormField(
                label: 'Cantidad',
                keyboardType: TextInputType.number,
                inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  if (value == null || value.isEmpty){
                    return '';
                  }
                  try {
                    int.parse(value);
                  } catch (e) {
                    return 'Ingrese un número entero';
                  }
                  return null;
                },
                controller: cantidadp,
                onChanged: validate.cantidadChanged,
                errorMessage: cantidad.errorMessage,
              ),
              if (isEditing) ...[
                SizedBox(height: 10),
                Text('Stock actual: ${widget.producto?.cantidad ?? 0}',
                style: TextStyle(fontSize: 16, color: Colors.grey),
                )
              ],
              SizedBox(
                height: 40
              ),
              CustomTextFormField(
                label: 'Precio',
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                  if ( value == null || value.isEmpty ) {
                    return 'Por favor ingrese un precio';
                  }
                  final precio = double.tryParse(value);
                  if (precio == null) {
                    return ' Ingrese un número válido';
                  }
                  if(precio <= 0) {
                    return 'El precio debe ser mayor a cero';
                  }
                  if (!RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(value)){
                    return 'Formato invalidó. Use #.#';
                  }
                  return null;
                },
                controller: preciop,
                onChanged: validate.precioChanged,
                errorMessage: precio.errorMessage,
              ),
              SizedBox(height: 250),
              SizedBox(
                width: double.infinity,
                height: 60,
                child: CustomFilledButton(
                  buttonColor: Color.fromARGB(255, 51, 128, 124),
                  text:isEditing ? 'Actualizar' : 'Guardar',
                  textStyle: textStyle.titleMedium,
                  onPressed: (){
                    if (widget.producto == null) {
                      validate.onSubmit();
                      createOrUpdateProducto();
                    } else {
                      createOrUpdateProducto();
                    }
                  },
                ),
              ),
              // Spacer(),
            ],
        ),
      ),
    );
  }
  
  Future<void> showScanner(BuildContext context) async {
    await showModalBottomSheet(
      context: context, 
      builder: (context) {
        return MobileScanner(
            controller: cameraController,
            onDetect: (barcodes) {
              if (barcodes.rawValue != null) {
                codigodp.text = barcodes.rawValue!;
                Navigator.pop(context);
              }
            },
          );
      }
    );
  }
}

extension on BarcodeCapture {
  get rawValue => null;
}

// extension on BarcodeCapture {
//   get rawValue => null;
// }