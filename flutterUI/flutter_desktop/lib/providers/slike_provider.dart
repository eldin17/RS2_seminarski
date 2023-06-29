import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/slika.dart';
import 'package:http/http.dart';

import '../models/login_response.dart';

class SlikeProvider with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "api/Slika";

  SlikeProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7152/");
  }

  Future<List<Slika>> getByArtikalId(int artikalId) async {
    var url = "$_baseUrl$_endpoint/getByArtikalId/$artikalId";

    var headers = {
      'accept': 'text/plain',
    };

    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<Slika> result = [];
      result = data;

      return result;
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<List<Slika>> getByZivotinjaId(int zivotinjaId) async {
    var url = "$_baseUrl$_endpoint/getByZivotinjaId/$zivotinjaId";

    var headers = {
      'accept': 'text/plain',
    };

    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<Slika> result = [];
      result = data;

      return result;
    } else {
      throw new Exception("Greska!");
    }
  }
}

bool isValidResponse(Response response) {
  if (response.statusCode < 299) {
    return true;
  } else if (response.statusCode == 401) {
    throw new Exception("Unauthorized");
  } else {
    throw new Exception(
        "Greska. Molimo pokusajte ponovo. Code:${response.statusCode}");
  }
}

String getQueryString(Map params,
    {String prefix = '&', bool inRecursion = false}) {
  String query = '';
  params.forEach((key, value) {
    if (inRecursion) {
      if (key is int) {
        key = '[$key]';
      } else if (value is List || value is Map) {
        key = '.$key';
      } else {
        key = '.$key';
      }
    }
    if (value is String || value is int || value is double || value is bool) {
      var encoded = value;
      if (value is String) {
        encoded = Uri.encodeComponent(value);
      }
      query += '$prefix$key=$encoded';
    } else if (value is DateTime) {
      query += '$prefix$key=${(value as DateTime).toIso8601String()}';
    } else if (value is List || value is Map) {
      if (value is List) value = value.asMap();
      value.forEach((k, v) {
        query +=
            getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
      });
    }
  });
  return query;
}
