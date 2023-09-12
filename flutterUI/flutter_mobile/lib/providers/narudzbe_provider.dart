import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/narudzba.dart';
import 'package:http/http.dart';
import '../models/login_response.dart';
import '../models/search_result.dart';

class NarudzbeProvider with ChangeNotifier {
  static String? _baseUrl;
  final String _endpoint = "api/Narudzba";

  NarudzbeProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7152/");
  }

  Future<Narudzba> najskuplja1() async {
    var url = "$_baseUrl$_endpoint/topLastMonth";

    var headers = {
      'accept': 'text/plain',
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      Narudzba result = Narudzba.fromJson(data);

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<Narudzba> najskuplja2() async {
    var url = "$_baseUrl$_endpoint/topAllTime";

    var headers = {
      'accept': 'text/plain',
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      Narudzba result = Narudzba.fromJson(data);

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<double> zarada1() async {
    var url = "$_baseUrl$_endpoint/totalLastMonth";

    var headers = {
      'accept': 'text/plain',
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      double result = data.toDouble();

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<List<Narudzba>> getMonth() async {
    var url = "$_baseUrl$_endpoint/allLastMonth";

    var headers = {
      'accept': 'text/plain',
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      List<Narudzba> result = [];
      for (var item in data) {
        result.add(Narudzba.fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<double> zarada2() async {
    var url = "$_baseUrl$_endpoint/totalAllTime";

    var headers = {
      'accept': 'text/plain',
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      double result = data.toDouble();

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<Narudzba> add(dynamic obj) async {
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

      return Narudzba.fromJson(data);
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<Narudzba> addPayment(int id) async {
    var url = "$_baseUrl$_endpoint/AddPaymentFlutterStripe/$id";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
      'accept': 'text/plain',
    };
    var uri = Uri.parse(url);

    var response = await http.post(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return Narudzba.fromJson(data);
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<Narudzba> addArtikal(
      int narudzbaId, int artikalId, dynamic obj) async {
    var url = "$_baseUrl$_endpoint/$narudzbaId/AddArtikal/$artikalId";
    var queryString = getQueryString(obj);
    url = "$url?$queryString";
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

      return Narudzba.fromJson(data);
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<Narudzba> addZivotinja(int narudzbaId, int zivotinjaId) async {
    var url = "$_baseUrl$_endpoint/$narudzbaId/AddZivotinja/$zivotinjaId";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
      'accept': 'text/plain',
    };
    var uri = Uri.parse(url);

    var response = await http.post(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      return Narudzba.fromJson(data);
    } else {
      throw new Exception("Greska!");
    }
  }

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
      throw Exception("Greska!");
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
      print(result.toString());
      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<List<Narudzba>> getByKupacId(int id) async {
    var url = "$_baseUrl$_endpoint/getByKupac/$id";

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

      List<Narudzba> result = [];

      for (var item in data) {
        result.add(Narudzba.fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<Narudzba> delete(int id) async {
    var url = "$_baseUrl$_endpoint/$id/delete";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.put(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = Narudzba.fromJson(data);

      return result;
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<Narudzba> activate(int id) async {
    var url = "$_baseUrl$_endpoint/$id/activate";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.put(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = Narudzba.fromJson(data);

      return result;
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<Narudzba> deactivate(int id) async {
    var url = "$_baseUrl$_endpoint/$id/deactivate";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.put(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = Narudzba.fromJson(data);

      return result;
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<Narudzba> cancel(int id) async {
    var url = "$_baseUrl$_endpoint/$id/cancel";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.put(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = Narudzba.fromJson(data);

      return result;
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<Narudzba> removeArtikal(int artikalId, int narudzbaId) async {
    var url = "$_baseUrl$_endpoint/$narudzbaId/RemoveArtikal/$artikalId";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.put(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = Narudzba.fromJson(data);

      return result;
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<Narudzba> removeZivotinja(int zivotinjaId, int narudzbaId) async {
    var url = "$_baseUrl$_endpoint/$narudzbaId/RemoveZivotinja/$zivotinjaId";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.put(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = Narudzba.fromJson(data);

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
