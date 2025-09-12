import 'dart:convert';

import 'package:http/http.dart' as http;

class EmailService {
  static Future<bool> enviar(String correo, String codigo) async {
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final res = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'service_id': 'service_id22',
        'template_id': 'template_ii599wz',
        'user_id': 'IM4AmZm-jgtP6gQwv',
        'template_params': {
          'user_email': correo,
          'codigo': codigo,
        }
      })
    );
    return res.statusCode == 200;
  }
}