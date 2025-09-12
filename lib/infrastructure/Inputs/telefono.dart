import 'package:formz/formz.dart';

enum TelefonoError {empty, length}

class Telefono extends FormzInput<String, TelefonoError>{

  const Telefono.pure() : super.pure('');

  const Telefono.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if ( isValid || isPure ) return null;
    if ( displayError == TelefonoError.empty ) return 'El campo es requerido';
    // if ( displayError == UsernameError.length ) return 'Mínimo 4 caracteres';
    
    return null;
  }

  @override 
  TelefonoError? validator( String value ) {
    if ( value.isEmpty || value.trim().isEmpty ) return TelefonoError.empty;
    // if ( value.length <4 ) return UsernameError.length;

    return null;
  }
}