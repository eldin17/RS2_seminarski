// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'osoba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Osoba _$OsobaFromJson(Map<String, dynamic> json) => Osoba(
      osobaId: json['osobaId'] as int?,
      ime: json['ime'] as String?,
      prezime: json['prezime'] as String?,
      datumRodjenja: json['datumRodjenja'] == null
          ? null
          : DateTime.parse(json['datumRodjenja'] as String),
    );

Map<String, dynamic> _$OsobaToJson(Osoba instance) => <String, dynamic>{
      'osobaId': instance.osobaId,
      'ime': instance.ime,
      'prezime': instance.prezime,
      'datumRodjenja': instance.datumRodjenja?.toIso8601String(),
    };
