// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prodavac.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Prodavac _$ProdavacFromJson(Map<String, dynamic> json) => Prodavac(
      prodavacId: json['prodavacId'] as int?,
      poslovnaJedinica: json['poslovnaJedinica'] as String?,
      slikaProdavca: json['slikaProdavca'] as String?,
      osobaId: json['osobaId'] as int?,
      osoba: json['osoba'] == null
          ? null
          : Osoba.fromJson(json['osoba'] as Map<String, dynamic>),
      korisnickiNalog: json['korisnickiNalog'] == null
          ? null
          : KorisnickiNalog.fromJson(
              json['korisnickiNalog'] as Map<String, dynamic>),
      korisnickiNalogId: json['korisnickiNalogId'] as int?,
    );

Map<String, dynamic> _$ProdavacToJson(Prodavac instance) => <String, dynamic>{
      'prodavacId': instance.prodavacId,
      'poslovnaJedinica': instance.poslovnaJedinica,
      'slikaProdavca': instance.slikaProdavca,
      'osobaId': instance.osobaId,
      'osoba': instance.osoba,
      'korisnickiNalog': instance.korisnickiNalog,
      'korisnickiNalogId': instance.korisnickiNalogId,
    };
