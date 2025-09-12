import 'package:formz/formz.dart';

enum CodigoError {empty, length}

class Codigo extends FormzInput<String, CodigoError>{

  const Codigo.pure() : super.pure('');

  const Codigo.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if ( isValid || isPure ) return null;
    if ( displayError == CodigoError.empty ) return 'El campo es requerido';
    // if ( displayError == UsernameError.length ) return 'Mínimo 4 caracteres';
    
    return null;
  }

  @override 
  CodigoError? validator( String value ) {
    if ( value.isEmpty || value.trim().isEmpty ) return CodigoError.empty;
    // if ( value.length <4 ) return CodigoError.length;

    return null;
  }
}