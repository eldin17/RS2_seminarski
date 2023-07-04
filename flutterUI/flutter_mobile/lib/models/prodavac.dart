import 'package:json_annotation/json_annotation.dart';

import 'korisnicki_nalog.dart';
import 'osoba.dart';

part 'prodavac.g.dart';

@JsonSerializable()
class Prodavac {
  int? prodavacId;
  String? poslovnaJedinica;
  String? slikaProdavca;
  int? osobaId;
  Osoba? osoba;
  KorisnickiNalog? korisnickiNalog;
  int? korisnickiNalogId;

  Prodavac({
    this.prodavacId,
    this.poslovnaJedinica,
    this.slikaProdavca,
    this.osobaId,
    this.osoba,
    this.korisnickiNalog,
    this.korisnickiNalogId,
  });

  factory Prodavac.fromJson(Map<String, dynamic> json) =>
      _$ProdavacFromJson(json);

  Map<String, dynamic> toJson() => _$ProdavacToJson(this);
}
