import 'package:json_annotation/json_annotation.dart';

part 'lokacija.g.dart';

@JsonSerializable()
class Lokacija {
  int? lokacijaId;
  String? drzava;
  String? grad;
  String? ulica;

  Lokacija({
    this.lokacijaId,
    this.drzava,
    this.grad,
    this.ulica,
  });

  factory Lokacija.fromJson(Map<String, dynamic> json) =>
      _$LokacijaFromJson(json);

  Map<String, dynamic> toJson() => _$LokacijaToJson(this);
}
