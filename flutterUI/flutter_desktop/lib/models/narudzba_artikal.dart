import 'package:json_annotation/json_annotation.dart';

import 'artikal.dart';

part 'narudzba_artikal.g.dart';

@JsonSerializable()
class NarudzbaArtikal {
  int? narudzbaArtikalId;
  int? narudzbaId;
  int? artikalId;
  Artikal? artikal;

  NarudzbaArtikal({
    this.narudzbaArtikalId,
    this.narudzbaId,
    this.artikalId,
    this.artikal,
  });

  factory NarudzbaArtikal.fromJson(Map<String, dynamic> json) =>
      _$NarudzbaArtikalFromJson(json);

  Map<String, dynamic> toJson() => _$NarudzbaArtikalToJson(this);
}
