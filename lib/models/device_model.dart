class Device {
  final int id;
  final String numeroIdentificacion;
  final String idDispositivo;
  final String nombreDispositivo;
  final TipoDispositivo tipo;
  final DateTime fechaRegistro;
  final bool activo;

  Device({
    required this.id,
    required this.numeroIdentificacion,
    required this.idDispositivo,
    required this.nombreDispositivo,
    required this.tipo,
    required this.fechaRegistro,
    required this.activo,
  });

  // Constructor desde fila de base de datos
  factory Device.fromDatabaseRow(Map<String, dynamic> row) {
    return Device(
      id: row['id'],
      numeroIdentificacion: row['numero_identificacion'],
      idDispositivo: row['id_dispositivo'],
      nombreDispositivo: row['nombre_dispositivo'],
      tipo: TipoDispositivo.fromString(row['tipo_dispositivo']),
      fechaRegistro: DateTime.parse(row['fecha_registro']),
      activo: row['activo'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'numero_identificacion': numeroIdentificacion,
      'id_dispositivo': idDispositivo,
      'nombre_dispositivo': nombreDispositivo,
      'tipo_dispositivo': tipo.value,
      'fecha_registro': fechaRegistro.toIso8601String(),
      'activo': activo,
    };
  }
}

enum TipoDispositivo {
  computador('computador', 'Computador'),
  portatil('portatil', 'Portátil'),
  tablet('tablet', 'Tablet'),
  telefono('telefono', 'Teléfono'),
  cargador('cargador', 'Cargador'),
  mouse('mouse', 'Mouse'),
  teclado('teclado', 'Teclado'),
  audifonos('audifonos', 'Audífonos'),
  otro('otro', 'Otro');

  const TipoDispositivo(this.value, this.displayName);
  
  final String value;
  final String displayName;

  static TipoDispositivo fromString(String value) {
    return TipoDispositivo.values.firstWhere(
      (tipo) => tipo.value == value,
      orElse: () => TipoDispositivo.otro,
    );
  }
}
