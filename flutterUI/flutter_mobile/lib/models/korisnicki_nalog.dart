import 'package:flutter_mobile/models/uloga.dart';
import 'package:json_annotation/json_annotation.dart';

part 'korisnicki_nalog.g.dart';

@JsonSerializable()
class KorisnickiNalog {
  int? korisnickiNalogId;
  String? username;
  String? datumRegistracije;
  Uloga? uloga;

  KorisnickiNalog({
    this.korisnickiNalogId,
    this.username,
    this.datumRegistracije,
    this.uloga,
  });

  factory KorisnickiNalog.fromJson(Map<String, dynamic> json) =>
      _$KorisnickiNalogFromJson(json);

  Map<String, dynamic> toJson() => _$KorisnickiNalogToJson(this);
}
