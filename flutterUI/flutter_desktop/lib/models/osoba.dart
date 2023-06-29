import 'package:json_annotation/json_annotation.dart';

part 'osoba.g.dart';

@JsonSerializable()
class Osoba {
  int? osobaId;
  String? ime;
  String? prezime;
  DateTime? datumRodjenja;

  Osoba({
    this.osobaId,
    this.ime,
    this.prezime,
    this.datumRodjenja,
  });

  factory Osoba.fromJson(Map<String, dynamic> json) => _$OsobaFromJson(json);

  Map<String, dynamic> toJson() => _$OsobaToJson(this);
}
