import 'dart:async';
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart' as dio;

import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/artikal.dart';

import '../models/login_response.dart';
import 'package:http/http.dart' as http;
import '../models/search_result.dart';

import 'package:flutter/foundation.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class ArtikliProvider with ChangeNotifier {
  static String? _baseUrl;
  final String _endpoint = "api/Artikal";

  ArtikliProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://10.0.2.2:7152/");
  }

  Future<SearchResult<Artikal>> get({dynamic filter}) async {
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

      var result = SearchResult<Artikal>();
      result.totalItems = data['totalItems'];

      for (var item in data['data']) {
        result.data.add(Artikal.fromJson(item));
      }

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<Artikal> add(dynamic obj) async {
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

      return Artikal.fromJson(data);
    } else {
      throw Exception("Greska!");
    }
  }

  Future<Artikal> getId(int id) async {
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

      var result = Artikal.fromJson(data);
      print(result.toString());
      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<List<dynamic>> allowedActions(int id) async {
    var url = "$_baseUrl$_endpoint/$id/allowedActions";

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

      List<dynamic> result = [];

      result = data;

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<Artikal> activate(int id) async {
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

      var result = Artikal.fromJson(data);

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<Artikal> delete(int id) async {
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

      var result = Artikal.fromJson(data);

      return result;
    } else {
      throw Exception("Greska!");
    }
  }

  Future<Artikal> update(int id, dynamic obj) async {
    var url = "$_baseUrl$_endpoint/$id";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${LoginResponse.token}",
      'accept': 'text/plain',
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

      return Artikal.fromJson(data);
    } else {
      throw Exception("Greska!");
    }
  }

  Future<void> uploadImages(int id, List<File> images) async {
    try {
      var url = "$_baseUrl$_endpoint/addSlikeArtikla/$id";
      final dioOptions = dio.BaseOptions(
        headers: {
          'Content-Type': 'multipart/form-data',
          "Authorization": "Bearer ${LoginResponse.token}",
        },
      );
      final dioClient = dio.Dio(dioOptions);

      final formData = dio.FormData();

      for (int i = 0; i < images.length; i++) {
        final file = images[i];
        final fileName = path.basename(file.path);
        formData.files.add(MapEntry(
          'vmSlike',
          await dio.MultipartFile.fromFile(
            file.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        ));
      }

      final response = await dioClient.post(
        url,
        data: formData,
      );

      if (response.statusCode == 200) {
        // Images uploaded successfully
        print('Images uploaded');
      } else {
        // Handle error
        print('Failed to upload images');
      }
    } catch (error) {
      // Handle error
      print('Failed to upload images: $error');
    }
  }

  Future<Artikal> dostupnost(int id, bool obj) async {
    var url = "$_baseUrl$_endpoint/$id/dostupnost?dostupnost=$obj";

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

      var result = Artikal.fromJson(data);

      return result;
    } else {
      throw Exception("Greska!");
    }
  }
}

bool isValidResponse(http.Response response) {
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
