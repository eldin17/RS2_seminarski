// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lokacija.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Lokacija _$LokacijaFromJson(Map<String, dynamic> json) => Lokacija(
      lokacijaId: json['lokacijaId'] as int?,
      drzava: json['drzava'] as String?,
      grad: json['grad'] as String?,
      ulica: json['ulica'] as String?,
    );

Map<String, dynamic> _$LokacijaToJson(Lokacija instance) => <String, dynamic>{
      'lokacijaId': instance.lokacijaId,
      'drzava': instance.drzava,
      'grad': instance.grad,
      'ulica': instance.ulica,
    };
