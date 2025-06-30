// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AprendizAdapter extends TypeAdapter<Aprendiz> {
  @override
  final int typeId = 0;

  @override
  Aprendiz read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Aprendiz(
      idIdentificacion: fields[0] as String,
      nombreCompleto: fields[1] as String,
      programaFormacion: fields[2] as String,
      numeroFicha: fields[3] as String,
      tipoSangre: fields[4] as String?,
      fotoPerfilPath: fields[5] as String?,
      contrasena: fields[6] as String,
      email: fields[7] as String?,
      fechaRegistro: fields[8] as DateTime,
      dispositivos: (fields[9] as List).cast<Dispositivo>(),
    );
  }

  @override
  void write(BinaryWriter writer, Aprendiz obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.idIdentificacion)
      ..writeByte(1)
      ..write(obj.nombreCompleto)
      ..writeByte(2)
      ..write(obj.programaFormacion)
      ..writeByte(3)
      ..write(obj.numeroFicha)
      ..writeByte(4)
      ..write(obj.tipoSangre)
      ..writeByte(5)
      ..write(obj.fotoPerfilPath)
      ..writeByte(6)
      ..write(obj.contrasena)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.fechaRegistro)
      ..writeByte(9)
      ..write(obj.dispositivos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AprendizAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DispositivoAdapter extends TypeAdapter<Dispositivo> {
  @override
  final int typeId = 1;

  @override
  Dispositivo read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Dispositivo(
      idDispositivo: fields[0] as String,
      idIdentificacion: fields[1] as String,
      nombreDispositivo: fields[2] as String,
      fechaRegistro: fields[3] as DateTime,
      tipoDispositivo: fields[4] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Dispositivo obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.idDispositivo)
      ..writeByte(1)
      ..write(obj.idIdentificacion)
      ..writeByte(2)
      ..write(obj.nombreDispositivo)
      ..writeByte(3)
      ..write(obj.fechaRegistro)
      ..writeByte(4)
      ..write(obj.tipoDispositivo);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DispositivoAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
