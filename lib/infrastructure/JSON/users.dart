class Users {
    final int? usrId;
    final String? fullName;
    final String email;
    final String password;

    Users({
        this.usrId,
        this.fullName,
        required this.email,
        required this.password,
    });

    factory Users.fromJson(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        fullName: json["fullName"],
        email: json["email"],
        password: json["password"],
    );

    Map<String, dynamic> toJson() => {
        "usrId": usrId,
        "fullName": fullName,
        "email": email,
        "password": password,
    };
}
