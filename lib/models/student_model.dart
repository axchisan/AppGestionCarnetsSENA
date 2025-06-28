class Student {
  final String numeroIdentificacion;
  final String nombreCompleto;
  final String email;
  final String programaFormacion;
  final String numeroFicha;
  final String? fotoPerfil; 
  final DateTime fechaCreacion;
  final bool activo;

  Student({
    required this.numeroIdentificacion,
    required this.nombreCompleto,
    required this.email,
    required this.programaFormacion,
    required this.numeroFicha,
    this.fotoPerfil,
    required this.fechaCreacion,
    required this.activo,
  });

  // Constructor desde fila de base de datos
  factory Student.fromDatabaseRow(Map<String, dynamic> row) {
    return Student(
      numeroIdentificacion: row['numero_identificacion'],
      nombreCompleto: row['nombre_completo'],
      email: row['email'] ?? '',
      programaFormacion: row['programa_formacion'],
      numeroFicha: row['numero_ficha'],
      fotoPerfil: row['foto_perfil'],
      fechaCreacion: DateTime.parse(row['fecha_creacion']),
      activo: row['activo'] ?? true,
    );
  }

  // Convertir a JSON para almacenamiento local
  Map<String, dynamic> toJson() {
    return {
      'numero_identificacion': numeroIdentificacion,
      'nombre_completo': nombreCompleto,
      'email': email,
      'programa_formacion': programaFormacion,
      'numero_ficha': numeroFicha,
      'foto_perfil': fotoPerfil,
      'fecha_creacion': fechaCreacion.toIso8601String(),
      'activo': activo,
    };
  }

  // Constructor desde JSON para almacenamiento local
  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      numeroIdentificacion: json['numero_identificacion'],
      nombreCompleto: json['nombre_completo'],
      email: json['email'] ?? '',
      programaFormacion: json['programa_formacion'],
      numeroFicha: json['numero_ficha'],
      fotoPerfil: json['foto_perfil'],
      fechaCreacion: DateTime.parse(json['fecha_creacion']),
      activo: json['activo'] ?? true,
    );
  }

  // Datos para el código de barras num identificacion
  String get barcodeData => numeroIdentificacion;

  // Método para obtener iniciales para avatar
  String get initials {
    final names = nombreCompleto.split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    }
    return nombreCompleto.isNotEmpty ? nombreCompleto[0].toUpperCase() : 'A';
  }
}
