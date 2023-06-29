import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_desktop/models/narudzba.dart';
import 'package:http/http.dart';

import '../models/login_response.dart';
import '../models/search_result.dart';

class NarudzbeProvider with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "api/Narudzba";

  NarudzbeProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7152/");
  }
  // Future<Narudzba> add(dynamic obj) async {
  //   var url = "$_baseUrl$_endpoint";

  //   var headers = {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer ${LoginResponse.token}",
  //     'accept': 'text/plain',
  //   };
  //   var uri = Uri.parse(url);
  //   var objEncoded = jsonEncode(obj);
  //   var body = objEncoded;

  //   var response = await http.post(
  //     uri,
  //     headers: headers,
  //     body: body,
  //   );

  //   if (isValidResponse(response)) {
  //     var data = jsonDecode(response.body);

  //     return Narudzba.fromJson(data);
  //   } else {
  //     throw new Exception("Greska!");
  //   }
  // }

  Future<SearchResult<Narudzba>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<Narudzba>();
      result.totalItems = data['totalItems'];

      for (var item in data['data']) {
        result.data.add(Narudzba.fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<Narudzba> getId(int id) async {
    var url = "$_baseUrl$_endpoint/$id";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = Narudzba.fromJson(data);
      print("${result.toString()}");
      return result;
    } else {
      throw new Exception("Greska!");
    }
  }

  // Future<Narudzba> delete(int id) async {
  //   var url = "$_baseUrl$_endpoint/$id/delete";

  //   var headers = {
  //     "Content-Type": "application/json",
  //     "Authorization": "Bearer ${LoginResponse.token}",
  //   };

  //   var uri = Uri.parse(url);

  //   var response = await http.put(
  //     uri,
  //     headers: headers,
  //   );

  //   if (isValidResponse(response)) {
  //     var data = jsonDecode(response.body);

  //     var result = Narudzba.fromJson(data);

  //     return result;
  //   } else {
  //     throw new Exception("Greska!");
  //   }
  // }
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