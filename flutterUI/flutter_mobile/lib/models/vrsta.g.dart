// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vrsta.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Vrsta _$VrstaFromJson(Map<String, dynamic> json) => Vrsta(
      vrstaId: json['vrstaId'] as int?,
      naziv: json['naziv'] as String?,
      rasaId: json['rasaId'] as int?,
      rasa: json['rasa'] == null
          ? null
          : Rasa.fromJson(json['rasa'] as Map<String, dynamic>),
      opis: json['opis'] as String?,
      boja: json['boja'] as String?,
      starost: json['starost'] as int?,
      prostor: json['prostor'] as bool?,
    );

Map<String, dynamic> _$VrstaToJson(Vrsta instance) => <String, dynamic>{
      'vrstaId': instance.vrstaId,
      'naziv': instance.naziv,
      'rasaId': instance.rasaId,
      'rasa': instance.rasa,
      'opis': instance.opis,
      'boja': instance.boja,
      'starost': instance.starost,
      'prostor': instance.prostor,
    };
