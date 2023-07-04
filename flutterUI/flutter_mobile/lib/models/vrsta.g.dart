// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vrsta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vrsta _$VrstaFromJson(Map<String, dynamic> json) => Vrsta(
      vrstaId: json['vrstaId'] as int?,
      naziv: json['naziv'] as String?,
      rasa: json['rasa'] as String?,
      opis: json['opis'] as String?,
      boja: json['boja'] as String?,
      starost: json['starost'] as int?,
      prostor: json['prostor'] as bool?,
    );

Map<String, dynamic> _$VrstaToJson(Vrsta instance) => <String, dynamic>{
      'vrstaId': instance.vrstaId,
      'naziv': instance.naziv,
      'rasa': instance.rasa,
      'opis': instance.opis,
      'boja': instance.boja,
      'starost': instance.starost,
      'prostor': instance.prostor,
    };
