// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artikal.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Artikal _$ArtikalFromJson(Map<String, dynamic> json) => Artikal(
      artikalId: json['artikalId'] as int?,
      naziv: json['naziv'] as String?,
      cijena: (json['cijena'] as num?)?.toDouble(),
      dostupnost: json['dostupnost'] as bool?,
      opis: json['opis'] as String?,
      stateMachine: json['stateMachine'] as String?,
      kategorijaId: json['kategorijaId'] as int?,
      kategorija: json['kategorija'] == null
          ? null
          : Kategorija.fromJson(json['kategorija'] as Map<String, dynamic>),
      slike: (json['slike'] as List<dynamic>?)
          ?.map((e) => Slika.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ArtikalToJson(Artikal instance) => <String, dynamic>{
      'artikalId': instance.artikalId,
      'naziv': instance.naziv,
      'cijena': instance.cijena,
      'dostupnost': instance.dostupnost,
      'opis': instance.opis,
      'stateMachine': instance.stateMachine,
      'kategorijaId': instance.kategorijaId,
      'kategorija': instance.kategorija,
      'slike': instance.slike,
    };
