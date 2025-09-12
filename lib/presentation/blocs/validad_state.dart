part of 'validad_cubit.dart';

enum FormStatus {invalid, valid, validating, posting}

class ValidateFormState extends Equatable{

  final FormStatus formStatus;
  final bool isValid;
  final Username userName;
  final Email email;
  final Password password;
  final ConfirPassword confirPassword;
  final Cantidad cantidad;
  final Codigo codigo;
  final Direccion direccion;
  final Precio precio;
  final Telefono telefono;

  const ValidateFormState({
    this.formStatus = FormStatus.invalid,
    this.isValid = false,
    this.userName = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirPassword = const ConfirPassword.pure(),
    this.cantidad = const Cantidad.pure(),
    this.codigo = const Codigo.pure(),
    this.direccion = const Direccion.pure(),
    this.precio = const Precio.pure(),
    this.telefono = const Telefono.pure(),
  });

  ValidateFormState copyWith({
    FormStatus? formStatus,
    bool? isValid,
    Username? userName,
    Email? email,
    Password? password,
    ConfirPassword? confirPassword,
    Cantidad? cantidad,
    Codigo? codigo,
    Direccion? direccion,
    Precio? precio,
    Telefono? telefono,
  }) => ValidateFormState(
    formStatus: formStatus ?? this.formStatus,
    isValid: isValid ?? this.isValid,
    userName: userName ?? this.userName,
    email: email ?? this.email,
    password: password ?? this.password,
    confirPassword: confirPassword ?? this.confirPassword,
    cantidad: cantidad ?? this.cantidad,
    codigo: codigo ?? this.codigo,
    direccion: direccion ?? this.direccion,
    precio: precio ?? this.precio,
    telefono: telefono ?? this.telefono
  );

  @override
  List<Object> get props => [formStatus, isValid, userName, email, password, confirPassword, cantidad, codigo, direccion, precio, telefono];
}