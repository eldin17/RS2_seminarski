// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registracija_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RegisterModel _$RegisterModelFromJson(Map<String, dynamic> json) =>
    RegisterModel(
      username: json['username'] as String?,
      password: json['password'] as String?,
      ulogaId: json['ulogaId'] as int?,
    );

Map<String, dynamic> _$RegisterModelToJson(RegisterModel instance) =>
    <String, dynamic>{
      'username': instance.username,
      'password': instance.password,
      'ulogaId': instance.ulogaId,
    };
