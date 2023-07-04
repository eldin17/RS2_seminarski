import 'package:flutter_mobile/models/prodavac.dart';
import 'package:json_annotation/json_annotation.dart';
part 'novost.g.dart';

@JsonSerializable()
class Novost {
  int? novostId;
  String? naslov;
  String? sadrzaj;
  String? datumPostavljanja;
  int? prodavacId;
  Prodavac? prodavac;

  Novost({
    this.novostId,
    this.naslov,
    this.sadrzaj,
    this.datumPostavljanja,
    this.prodavacId,
    this.prodavac,
  });

  factory Novost.fromJson(Map<String, dynamic> json) => _$NovostFromJson(json);

  Map<String, dynamic> toJson() => _$NovostToJson(this);
}
