import 'package:formz/formz.dart';

enum PrecioError {empty, length}

class Precio extends FormzInput<String, PrecioError>{

  const Precio.pure() : super.pure('');

  const Precio.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if ( isValid || isPure ) return null;
    if ( displayError == PrecioError.empty ) return 'El campo es requerido';
    if ( displayError == PrecioError.length ) return 'Mínimo 1 caracteres';
    
    return null;
  }

  @override 
  PrecioError? validator( String value ) {
    if ( value.isEmpty || value.trim().isEmpty ) return PrecioError.empty;
    return null;
  }
}