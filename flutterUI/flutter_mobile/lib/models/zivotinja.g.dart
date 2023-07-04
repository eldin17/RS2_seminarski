// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zivotinja.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Zivotinja _$ZivotinjaFromJson(Map<String, dynamic> json) => Zivotinja(
      zivotinjaId: json['zivotinjaId'] as int?,
      naziv: json['naziv'] as String?,
      napomena: json['napomena'] as String?,
      cijena: (json['cijena'] as num?)?.toDouble(),
      dostupnost: json['dostupnost'] as bool?,
      datumPostavljanja: json['datumPostavljanja'] == null
          ? null
          : DateTime.parse(json['datumPostavljanja'] as String),
      stateMachine: json['stateMachine'] as String?,
      vrstaId: json['vrstaId'] as int?,
      vrsta: json['vrsta'] == null
          ? null
          : Vrsta.fromJson(json['vrsta'] as Map<String, dynamic>),
      slike: (json['slike'] as List<dynamic>?)
          ?.map((e) => Slika.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ZivotinjaToJson(Zivotinja instance) => <String, dynamic>{
      'zivotinjaId': instance.zivotinjaId,
      'naziv': instance.naziv,
      'napomena': instance.napomena,
      'cijena': instance.cijena,
      'dostupnost': instance.dostupnost,
      'datumPostavljanja': instance.datumPostavljanja?.toIso8601String(),
      'stateMachine': instance.stateMachine,
      'vrstaId': instance.vrstaId,
      'vrsta': instance.vrsta,
      'slike': instance.slike,
    };
