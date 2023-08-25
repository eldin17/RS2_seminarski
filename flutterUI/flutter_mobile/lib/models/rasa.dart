import 'package:json_annotation/json_annotation.dart';

part 'rasa.g.dart';

@JsonSerializable()
class Rasa {
  int? rasaId;
  String? naziv;

  Rasa({
    this.rasaId,
    this.naziv,
  });

  factory Rasa.fromJson(Map<String, dynamic> json) => _$RasaFromJson(json);

  Map<String, dynamic> toJson() => _$RasaToJson(this);
}
