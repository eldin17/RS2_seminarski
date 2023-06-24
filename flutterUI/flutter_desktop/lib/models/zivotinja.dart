import 'package:flutter_desktop/models/slika.dart';
import 'package:flutter_desktop/models/vrsta.dart';
import 'package:json_annotation/json_annotation.dart';

part 'zivotinja.g.dart';

@JsonSerializable()
class Zivotinja {
  int? zivotinjaId;
  String? naziv;
  String? napomena;
  double? cijena;
  bool? dostupnost;
  DateTime? datumPostavljanja;
  String? stateMachine;
  int? vrstaId;
  Vrsta? vrsta;
  List<Slika>? slike;

  Zivotinja({
    this.zivotinjaId,
    this.naziv,
    this.napomena,
    this.cijena,
    this.dostupnost,
    this.datumPostavljanja,
    this.stateMachine,
    this.vrstaId,
    this.vrsta,
    this.slike,
  });

  factory Zivotinja.fromJson(Map<String, dynamic> json) =>
      _$ZivotinjaFromJson(json);

  Map<String, dynamic> toJson() => _$ZivotinjaToJson(this);
}
