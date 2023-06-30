import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_desktop/models/prodavac.dart';

import '../models/login_response.dart';
import '../models/search_result.dart';

import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as path;

class ProdavacProvider with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "api/Prodavac";

  ProdavacProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "http://localhost:7152/");
  }
  Future<SearchResult<Prodavac>> get({dynamic filter}) async {
    var url = "$_baseUrl$_endpoint";

    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var headers = {
      "Content-Type": "application/json",
      //"Authorization": "Bearer ${LoginResponse.token}",
    };

    var uri = Uri.parse(url);

    var response = await http.get(
      uri,
      headers: headers,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<Prodavac>();
      result.totalItems = data['totalItems'];

      for (var item in data['data']) {
        result.data.add(Prodavac.fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<Prodavac> getAktivnost() async {
    var url = "$_baseUrl$_endpoint/topByAktivnost";

    var headers = {
      "Content-Type": "application/json",
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

      var result = Prodavac.fromJson(data);
      print("${result.toString()}");
      return result;
    } else {
      throw new Exception("Greska!");
    }
  }

  Future<void> addSlikaProdavca(int id, File image) async {
    try {
      var url = 'http://localhost:7152/api/Prodavac/addSlikaProdavca/$id';

      final dioOptions = dio.BaseOptions(
        headers: {
          'Content-Type': 'multipart/form-data',
          'Authorization': 'Bearer ${LoginResponse.token}',
        },
      );
      final dioClient = dio.Dio(dioOptions);

      final formData = dio.FormData();

      final fileName = path.basename(image.path);
      formData.files.add(
        MapEntry(
          'vmSlika',
          await dio.MultipartFile.fromFile(
            image.path,
            filename: fileName,
            contentType: MediaType('image', 'jpeg'),
          ),
        ),
      );

      final response = await dioClient.post(
        url,
        data: formData,
      );

      if (response.statusCode == 200) {
        // Image uploaded successfully
        print('Image uploaded');
      } else {
        // Handle error
        print('Failed to upload image');
      }
    } catch (error) {
      // Handle error
      print('Failed to upload image: $error');
    }
  }

  Future<Prodavac> add(Prodavac obj) async {
    var url = "$_baseUrl$_endpoint";

    var headers = {
      'accept': 'text/plain',
      //"Authorization": "Bearer ${LoginResponse.token}",
      "Content-Type": "application/json",
    };
    var uri = Uri.parse(url);
    var body = jsonEncode(obj.toJson());

    var response = await http.post(
      uri,
      headers: headers,
      body: body,
    );

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var prodavac = Prodavac.fromJson(data);

      return prodavac;
    } else {
      throw Exception("Greska!");
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
