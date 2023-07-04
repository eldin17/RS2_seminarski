import 'kategorija.dart';
import 'package:flutter_mobile/models/slika.dart';
import 'package:json_annotation/json_annotation.dart';

part 'artikal.g.dart';

@JsonSerializable()
class Artikal {
  int? artikalId;
  String? naziv;
  double? cijena;
  bool? dostupnost;
  String? opis;
  String? stateMachine;
  int? kategorijaId;
  Kategorija? kategorija;
  List<Slika>? slike;

  Artikal({
    this.artikalId,
    this.naziv,
    this.cijena,
    this.dostupnost,
    this.opis,
    this.stateMachine,
    this.kategorijaId,
    this.kategorija,
    this.slike,
  });

  factory Artikal.fromJson(Map<String, dynamic> json) =>
      _$ArtikalFromJson(json);

  Map<String, dynamic> toJson() => _$ArtikalToJson(this);
}
