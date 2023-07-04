import 'package:json_annotation/json_annotation.dart';

part 'slika.g.dart';

@JsonSerializable()
class Slika {
  int? slikaId;
  String? naziv;
  String? putanja;

  Slika({
    this.slikaId,
    this.naziv,
    this.putanja,
  });

  factory Slika.fromJson(Map<String, dynamic> json) => _$SlikaFromJson(json);

  Map<String, dynamic> toJson() => _$SlikaToJson(this);
}
