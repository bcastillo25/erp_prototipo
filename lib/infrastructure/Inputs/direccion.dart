import 'package:formz/formz.dart';

enum DireccionError {empty, length}

class Direccion extends FormzInput<String, DireccionError>{

  const Direccion.pure() : super.pure('');

  const Direccion.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if ( isValid || isPure ) return null;
    if ( displayError == DireccionError.empty ) return 'El campo es requerido';
    // if ( displayError == UsernameError.length ) return 'Mínimo 4 caracteres';
    
    return null;
  }

  @override 
  DireccionError? validator( String value ) {
    if ( value.isEmpty || value.trim().isEmpty ) return DireccionError.empty;
    // if ( value.length <4 ) return UsernameError.length;

    return null;
  }
}