import 'dart:convert';

import 'package:http/http.dart' as http;

Future<bool> sendecovig(
    double temperature, int spo2, int hr, int confidence) async {
  final response = await http.post(
    Uri.parse(
        'https://0vnn67udx7.execute-api.eu-central-1.amazonaws.com/default/testes2'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'patientid': 42,
      'name': "Enzo Torres",
      'hrate': hr,
      'spo2': spo2,
      'temperature': temperature,
      'confidence_value': confidence,
    }),
  );
  return response.body == "1";
}

Future<String> sendECG(
    List<int> data, List<double> x, List<double> y, List<double> z) async {
  final response = await http.post(
    Uri.parse('http://6e37-195-245-147-102.ngrok.io'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode({
      'data': data,
      'x': x,
      'y': y,
      'z': z,
      'age': 24,
      'sample_rate': 100,
    }),
  );
  print(response.body);
  final Map<String, dynamic> result = jsonDecode(response.body);
  return result["warning_message"];
}
