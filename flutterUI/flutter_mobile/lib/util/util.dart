import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_mobile/models/slika.dart';
import 'package:intl/intl.dart';

String formatNumber(dynamic) {
  var f = NumberFormat('#,##0.00', 'en_US');
  if (dynamic == null) {
    return '';
  }
  return f.format(dynamic);
}

Color getTextColor(String? stateMachine) {
  switch (stateMachine) {
    case 'Active':
      return Colors.blue;
    case 'Draft':
      return Colors.orange;
    case 'Sold':
      return Colors.green;
    case 'Done':
      return Colors.green;
    case 'Reserved':
      return Colors.purple;
    default:
      return Colors.black;
  }
}

String obradiSliku(String slika) {
  Uri uri = Uri.parse(slika);
  Uri novi = uri.replace(host: '10.0.2.2');
  String putanja = novi.toString();
  return putanja;
}

List<String> obradiSlike(List<Slika> slike) {
  List<String> nova = [];
  for (var item in slike) {
    nova.add(obradiSliku(item.putanja!));
  }
  return nova;
}
