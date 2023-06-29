// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'korisnicki_nalog.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KorisnickiNalog _$KorisnickiNalogFromJson(Map<String, dynamic> json) =>
    KorisnickiNalog(
      korisnickiNalogId: json['korisnickiNalogId'] as int?,
      username: json['username'] as String?,
      datumRegistracije: json['datumRegistracije'] as String?,
      uloga: json['uloga'] == null
          ? null
          : Uloga.fromJson(json['uloga'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$KorisnickiNalogToJson(KorisnickiNalog instance) =>
    <String, dynamic>{
      'korisnickiNalogId': instance.korisnickiNalogId,
      'username': instance.username,
      'datumRegistracije': instance.datumRegistracije,
      'uloga': instance.uloga,
    };
