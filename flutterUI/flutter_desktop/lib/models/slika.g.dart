// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slika.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slika _$SlikaFromJson(Map<String, dynamic> json) => Slika(
      slikaId: json['slikaId'] as int?,
      naziv: json['naziv'] as String?,
      putanja: json['putanja'] as String?,
    );

Map<String, dynamic> _$SlikaToJson(Slika instance) => <String, dynamic>{
      'slikaId': instance.slikaId,
      'naziv': instance.naziv,
      'putanja': instance.putanja,
    };
