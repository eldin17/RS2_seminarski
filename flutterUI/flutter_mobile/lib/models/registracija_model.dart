import 'package:json_annotation/json_annotation.dart';

part 'registracija_model.g.dart';

@JsonSerializable()
class RegisterModel {
  String? username;
  String? password;
  int? ulogaId;

  RegisterModel({
    this.username,
    this.password,
    this.ulogaId,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterModelFromJson(json);

  Map<String, dynamic> toJson() => _$RegisterModelToJson(this);
}
