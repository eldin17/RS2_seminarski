import 'package:json_annotation/json_annotation.dart';

part 'vrsta.g.dart';

@JsonSerializable()
class Vrsta {
  int? vrstaId;
  String? naziv;
  String? rasa;
  String? opis;
  String? boja;
  int? starost;
  bool? prostor;

  Vrsta({
    this.vrstaId,
    this.naziv,
    this.rasa,
    this.opis,
    this.boja,
    this.starost,
    this.prostor,
  });

  factory Vrsta.fromJson(Map<String, dynamic> json) => _$VrstaFromJson(json);

  Map<String, dynamic> toJson() => _$VrstaToJson(this);
}
