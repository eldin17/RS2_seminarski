import 'package:flutter_mobile/models/zivotinja.dart';
import 'package:json_annotation/json_annotation.dart';

import 'kupac.dart';
import 'narudzba_artikal.dart';

part 'narudzba.g.dart';

@JsonSerializable()
class Narudzba {
  int? narudzbaId;
  String? datumNarudzbe;
  double? totalFinal;
  String? stateMachine;
  Kupac? kupac;
  int? kupacId;
  List<NarudzbaArtikal>? narudzbeArtikli;
  List<Zivotinja>? zivotinje;

  Narudzba({
    this.narudzbaId,
    this.datumNarudzbe,
    this.totalFinal,
    this.stateMachine,
    this.kupac,
    this.kupacId,
    this.narudzbeArtikli,
    this.zivotinje,
  });

  factory Narudzba.fromJson(Map<String, dynamic> json) =>
      _$NarudzbaFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbaToJson(this);
}
