import 'package:formz/formz.dart';

enum ConfirPasswordError {empty, length}

class ConfirPassword extends FormzInput<String, ConfirPasswordError>{

  const ConfirPassword.pure() : super.pure('');

  const ConfirPassword.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if ( isValid || isPure ) return null;
    if ( displayError == ConfirPasswordError.empty ) return 'El campo es requerido';
    if ( displayError == ConfirPasswordError.length ) return 'Mínimo 8 caracteres';
    
    return null;
  }

  @override 
  ConfirPasswordError? validator( String value ) {
    if ( value.isEmpty || value.trim().isEmpty ) return ConfirPasswordError.empty;
    if ( value.length < 8 ) return ConfirPasswordError.length;

    return null;
  }
}