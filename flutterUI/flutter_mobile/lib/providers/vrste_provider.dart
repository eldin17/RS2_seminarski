import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/vrsta.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../models/login_response.dart';
import '../models/search_result.dart';

class VrsteProvider with ChangeNotifier {
  static String? _baseUrl;
  final String _endpoint = "api/Vrsta";

  VrsteProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7152/");
  }

  Future<SearchResult<Vrsta>> get({dynamic filter}) async {
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

      var result = SearchResult<Vrsta>();
      result.totalItems = data['totalItems'];

      for (var item in data['data']) {
        result.data.add(Vrsta.fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<Vrsta> add(Vrsta obj) async {
    var url = "$_baseUrl$_endpoint";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
      'accept': 'text/plain',
    };
    var uri = Uri.parse(url);
    var objEncoded = jsonEncode(obj);
    var body = objEncoded;

    var response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return Vrsta.fromJson(data);
    } else {
      throw Exception("Greska!");
    }
  }

  Future<Vrsta> update(int id, dynamic obj) async {
    var url = "$_baseUrl$_endpoint/$id";

    var headers = {
      'accept': 'text/plain',
      "Authorization": "Bearer ${LoginResponse.token}",
      "Content-Type": "application/json",
    };
    var uri = Uri.parse(url);
    var objEncoded = jsonEncode(obj);
    var body = objEncoded;

    var response = await http.put(
      uri,
      headers: headers,
      body: body,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return Vrsta.fromJson(data);
    } else {
      throw Exception("Greska!");
    }
  }
}

bool isValidResponse(Response response) {
  if (response.statusCode < 299) {
    return true;
  } else if (response.statusCode == 401) {
    throw Exception("Unauthorized");
  } else {
    throw Exception(
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
      query += '$prefix$key=${(value).toIso8601String()}';
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
