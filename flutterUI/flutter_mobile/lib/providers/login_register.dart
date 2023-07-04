import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/login_response.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/korisnicki_nalog.dart';
import '../models/registracija_model.dart';

class LoginRegisterProvider with ChangeNotifier {
  static String? _baseUrl;
  final String _endpoint = "api/KorisnickiNalog";
  //http://localhost:7152/api/KorisnickiNalog/login
  LoginRegisterProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7152/");
  }

  Future<void> login(String username, String password) async {
    var url = "$_baseUrl$_endpoint/login";
    var uri = Uri.parse(url);

    var body = {
      "username": username,
      "password": password,
    };

    var response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      if (data['ulogaNaziv'] != "Kupac") {
        throw Exception("Pristup dozvoljen samo za ulogu Prodavac!");
      }
      LoginResponse.token = data['token'];
      LoginResponse.idLogiranogKorisnika = data['idLogiranogKorisnika'];
      LoginResponse.ulogaNaziv = data['ulogaNaziv'];

      return;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<KorisnickiNalog> register(RegisterModel obj) async {
    var url = "$_baseUrl$_endpoint/register";
    var uri = Uri.parse(url);

    var body = {
      "username": obj.username,
      "password": obj.password,
      "ulogaId": obj.ulogaId,
    };

    var response = await http.post(
      uri,
      headers: {
        'accept': 'text/plain',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      // Registration successful
      var korisnickiNalog = KorisnickiNalog.fromJson(data);
      return korisnickiNalog;
    } else {
      throw Exception("Greska pri registraciji!");
    }
  }

  bool isValidResponse(Response response) {
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 400) {
      throw Exception("Pogresno korisnicko ime ili sifra");
    } else {
      throw Exception("Greska. Molimo pokusajte ponovo.");
    }
  }
}
