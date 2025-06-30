import 'package:hive/hive.dart';

part 'models.g.dart';

@HiveType(typeId: 0)
class Aprendiz {
  @HiveField(0)
  final String idIdentificacion;
  @HiveField(1)
  final String nombreCompleto;
  @HiveField(2)
  final String programaFormacion;
  @HiveField(3)
  final String numeroFicha;
  @HiveField(4)
  final String? tipoSangre;
  @HiveField(5)
  final String? fotoPerfilPath;
  @HiveField(6)
  final String contrasena;
  @HiveField(7)
  final String? email;
  @HiveField(8)
  final DateTime fechaRegistro;
  @HiveField(9)
  final List<Dispositivo> dispositivos;

  Aprendiz({
    required this.idIdentificacion,
    required this.nombreCompleto,
    required this.programaFormacion,
    required this.numeroFicha,
    this.tipoSangre,
    this.fotoPerfilPath,
    required this.contrasena,
    this.email,
    required this.fechaRegistro,
    this.dispositivos = const [],
  });

  Map<String, dynamic> toJson() => {
    'idIdentificacion': idIdentificacion,
    'nombreCompleto': nombreCompleto,
    'programaFormacion': programaFormacion,
    'numeroFicha': numeroFicha,
    'tipoSangre': tipoSangre,
    'fotoPerfilPath': fotoPerfilPath,
    'contrasena': contrasena,
    'email': email,
    'fechaRegistro': fechaRegistro.toIso8601String(),
    'dispositivos': dispositivos.map((d) => d.toJson()).toList(),
  };

  factory Aprendiz.fromJson(Map<String, dynamic> json) => Aprendiz(
    idIdentificacion: json['idIdentificacion'],
    nombreCompleto: json['nombreCompleto'],
    programaFormacion: json['programaFormacion'],
    numeroFicha: json['numeroFicha'],
    tipoSangre: json['tipoSangre'],
    fotoPerfilPath: json['fotoPerfilPath'],
    contrasena: json['contrasena'],
    email: json['email'],
    fechaRegistro: DateTime.parse(json['fechaRegistro']),
    dispositivos: (json['dispositivos'] as List)
        .map((d) => Dispositivo.fromJson(d))
        .toList(),
  );
}

@HiveType(typeId: 1)
class Dispositivo {
  @HiveField(0)
  final String idDispositivo;
  @HiveField(1)
  final String idIdentificacion;
  @HiveField(2)
  final String nombreDispositivo;
  @HiveField(3)
  final DateTime fechaRegistro;

  Dispositivo({
    required this.idDispositivo,
    required this.idIdentificacion,
    required this.nombreDispositivo,
    required this.fechaRegistro,
  });

  Map<String, dynamic> toJson() => {
    'idDispositivo': idDispositivo,
    'idIdentificacion': idIdentificacion,
    'nombreDispositivo': nombreDispositivo,
    'fechaRegistro': fechaRegistro.toIso8601String(),
  };

  factory Dispositivo.fromJson(Map<String, dynamic> json) => Dispositivo(
    idDispositivo: json['idDispositivo'],
    idIdentificacion: json['idIdentificacion'],
    nombreDispositivo: json['nombreDispositivo'],
    fechaRegistro: DateTime.parse(json['fechaRegistro']),
  );
}