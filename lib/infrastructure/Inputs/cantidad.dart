import 'package:formz/formz.dart';

enum CantidadError {empty, length}

class Cantidad extends FormzInput<String, CantidadError>{

  const Cantidad.pure() : super.pure('');

  const Cantidad.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if ( isValid || isPure ) return null;
    if ( displayError == CantidadError.empty ) return 'El campo es requerido';
    if ( displayError == CantidadError.length ) return 'Mínimo 1 caracteres';
    
    return null;
  }

  @override 
  CantidadError? validator( String value ) {
    if ( value.isEmpty || value.trim().isEmpty ) return CantidadError.empty;
    return null;
  }
}