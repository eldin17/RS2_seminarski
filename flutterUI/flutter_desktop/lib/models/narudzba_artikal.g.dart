// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba_artikal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NarudzbaArtikal _$NarudzbaArtikalFromJson(Map<String, dynamic> json) =>
    NarudzbaArtikal(
      narudzbaArtikalId: json['narudzbaArtikalId'] as int?,
      narudzbaId: json['narudzbaId'] as int?,
      artikalId: json['artikalId'] as int?,
      artikal: json['artikal'] == null
          ? null
          : Artikal.fromJson(json['artikal'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$NarudzbaArtikalToJson(NarudzbaArtikal instance) =>
    <String, dynamic>{
      'narudzbaArtikalId': instance.narudzbaArtikalId,
      'narudzbaId': instance.narudzbaId,
      'artikalId': instance.artikalId,
      'artikal': instance.artikal,
    };
