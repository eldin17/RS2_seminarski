import 'package:json_annotation/json_annotation.dart';

import 'korisnicki_nalog.dart';
import 'lokacija.dart';
import 'osoba.dart';

part 'kupac.g.dart';

@JsonSerializable()
class Kupac {
  int? kupacId;
  int? brojNarudzbi;
  bool? kuca;
  bool? dvoriste;
  bool? stan;
  Osoba? osoba;
  Lokacija? lokacija;
  List<dynamic>? narudzbe;
  String? slikaKupca;
  KorisnickiNalog? korisnickiNalog;

  Kupac({
    this.kupacId,
    this.brojNarudzbi,
    this.kuca,
    this.dvoriste,
    this.stan,
    this.osoba,
    this.lokacija,
    this.narudzbe,
    this.slikaKupca,
    this.korisnickiNalog,
  });
  factory Kupac.fromJson(Map<String, dynamic> json) => _$KupacFromJson(json);

  Map<String, dynamic> toJson() => _$KupacToJson(this);
}
