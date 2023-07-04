// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'novost.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Novost _$NovostFromJson(Map<String, dynamic> json) => Novost(
      novostId: json['novostId'] as int?,
      naslov: json['naslov'] as String?,
      sadrzaj: json['sadrzaj'] as String?,
      datumPostavljanja: json['datumPostavljanja'] as String?,
      prodavacId: json['prodavacId'] as int?,
      prodavac: json['prodavac'] == null
          ? null
          : Prodavac.fromJson(json['prodavac'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NovostToJson(Novost instance) => <String, dynamic>{
      'novostId': instance.novostId,
      'naslov': instance.naslov,
      'sadrzaj': instance.sadrzaj,
      'datumPostavljanja': instance.datumPostavljanja,
      'prodavacId': instance.prodavacId,
      'prodavac': instance.prodavac,
    };
