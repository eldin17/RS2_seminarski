// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kupac.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Kupac _$KupacFromJson(Map<String, dynamic> json) => Kupac(
      kupacId: json['kupacId'] as int?,
      brojNarudzbi: json['brojNarudzbi'] as int?,
      kuca: json['kuca'] as bool?,
      dvoriste: json['dvoriste'] as bool?,
      stan: json['stan'] as bool?,
      osoba: json['osoba'] == null
          ? null
          : Osoba.fromJson(json['osoba'] as Map<String, dynamic>),
      osobaId: json['osobaId'] as int?,
      lokacija: json['lokacija'] == null
          ? null
          : Lokacija.fromJson(json['lokacija'] as Map<String, dynamic>),
      lokacijaId: json['lokacijaId'] as int?,
      narudzbe: json['narudzbe'] as List<dynamic>?,
      slikaKupca: json['slikaKupca'] as String?,
      korisnickiNalog: json['korisnickiNalog'] == null
          ? null
          : KorisnickiNalog.fromJson(
              json['korisnickiNalog'] as Map<String, dynamic>),
      korisnickiNalogId: json['korisnickiNalogId'] as int?,
    );

Map<String, dynamic> _$KupacToJson(Kupac instance) => <String, dynamic>{
      'kupacId': instance.kupacId,
      'brojNarudzbi': instance.brojNarudzbi,
      'kuca': instance.kuca,
      'dvoriste': instance.dvoriste,
      'stan': instance.stan,
      'osoba': instance.osoba,
      'osobaId': instance.osobaId,
      'lokacija': instance.lokacija,
      'lokacijaId': instance.lokacijaId,
      'narudzbe': instance.narudzbe,
      'slikaKupca': instance.slikaKupca,
      'korisnickiNalog': instance.korisnickiNalog,
      'korisnickiNalogId': instance.korisnickiNalogId,
    };
