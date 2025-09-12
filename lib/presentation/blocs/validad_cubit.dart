import 'package:erp_prototipo/infrastructure/Inputs/inputs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'validad_state.dart';

class ValidateCubit extends Cubit<ValidateFormState>{
  ValidateCubit() : super(ValidateFormState());

  void onSubmit() {
    emit(
      state.copyWith(
        formStatus: FormStatus.validating,
        userName: Username.dirty(state.userName.value),
        email: Email.dirty(state.email.value),
        password: Password.dirty(state.password.value),
        confirPassword: ConfirPassword.dirty(state.confirPassword.value),
        cantidad: Cantidad.dirty(state.cantidad.value),
        codigo: Codigo.dirty(state.codigo.value),
        direccion: Direccion.dirty(state.direccion.value),
        precio: Precio.dirty(state.precio.value),
        telefono: Telefono.dirty(state.telefono.value),
        isValid: Formz.validate([
          state.userName,
          state.email,
          state.password,
          state.confirPassword,
          state.cantidad,
          state.codigo,
          state.direccion,
          state.precio,
          state.telefono
        ])
      )
    );
  }

  void userNameChanged(String value) {
    final userName = Username.dirty(value);
    emit(
      state.copyWith(
        userName: userName,
        isValid: Formz.validate([userName, state.email, state.password, state.confirPassword, state.cantidad, state.codigo, state.direccion, state.precio, state.telefono])
      )
    );
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        isValid: Formz.validate([email, state.userName, state.password, state.confirPassword, state.cantidad, state.codigo, state.direccion, state.precio, state.telefono])
      )
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(
      state.copyWith(
        password: password,
        isValid: Formz.validate([password, state.userName, state.email, state.confirPassword, state.cantidad, state.codigo, state.direccion, state.precio, state.telefono])
      )
    );
  }

  void confirPasswordChanged(String value) {
    final confirPassword = ConfirPassword.dirty(value);
    emit(
      state.copyWith(
        confirPassword: confirPassword,
        isValid: Formz.validate([confirPassword, state.userName, state.email, state.password, state.cantidad, state.codigo, state.direccion, state.precio, state.telefono])
      )
    );
  }
  void cantidadChanged(String value) {
    final cantidad = Cantidad.dirty(value);
    emit(
      state.copyWith(
        cantidad: cantidad,
        isValid: Formz.validate([cantidad, state.userName, state.email, state.password, state.confirPassword, state.codigo, state.direccion, state.precio, state.telefono])
      )
    );
  }
  void codigoChanged(String value) {
    final codigo = Codigo.dirty(value);
    emit(
      state.copyWith(
        codigo: codigo,
        isValid: Formz.validate([codigo, state.userName, state.email, state.password, state.confirPassword, state.cantidad, state.direccion, state.precio, state.telefono])
      )
    );
  }
  void direccionChanged(String value) {
    final direccion = Direccion.dirty(value);
    emit(
      state.copyWith(
        direccion: direccion,
        isValid: Formz.validate([direccion, state.userName, state.email, state.password, state.confirPassword, state.cantidad, state.codigo, state.precio, state.telefono])
      )
    );
  }
  void precioChanged(String value) {
    final precio = Precio.dirty(value);
    emit(
      state.copyWith(
        precio: precio,
        isValid: Formz.validate([precio, state.userName, state.email, state.password, state.confirPassword, state.cantidad, state.codigo, state.direccion, state.telefono])
      )
    );
  }
  void telefonoChanged(String value) {
    final telefono = Telefono.dirty(value);
    emit(
      state.copyWith(
        telefono: telefono,
        isValid: Formz.validate([telefono, state.userName, state.email, state.password, state.confirPassword, state.cantidad, state.codigo, state.direccion, state.precio])
      )
    );
  }
}