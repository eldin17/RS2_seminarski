// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'narudzba.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Narudzba _$NarudzbaFromJson(Map<String, dynamic> json) => Narudzba(
      narudzbaId: json['narudzbaId'] as int?,
      datumNarudzbe: json['datumNarudzbe'] as String?,
      totalFinal: (json['totalFinal'] as num?)?.toDouble(),
      stateMachine: json['stateMachine'] as String?,
      kupac: json['kupac'] == null
          ? null
          : Kupac.fromJson(json['kupac'] as Map<String, dynamic>),
      kupacId: json['kupacId'] as int?,
      narudzbeArtikli: (json['narudzbeArtikli'] as List<dynamic>?)
          ?.map((e) => NarudzbaArtikal.fromJson(e as Map<String, dynamic>))
          .toList(),
      zivotinje: (json['zivotinje'] as List<dynamic>?)
          ?.map((e) => Zivotinja.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$NarudzbaToJson(Narudzba instance) => <String, dynamic>{
      'narudzbaId': instance.narudzbaId,
      'datumNarudzbe': instance.datumNarudzbe,
      'totalFinal': instance.totalFinal,
      'stateMachine': instance.stateMachine,
      'kupac': instance.kupac,
      'kupacId': instance.kupacId,
      'narudzbeArtikli': instance.narudzbeArtikli,
      'zivotinje': instance.zivotinje,
    };
