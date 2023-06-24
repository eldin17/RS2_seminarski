import 'dart:ui';

import 'package:flutter/material.dart';
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
    default:
      return Colors.black;
  }
}
