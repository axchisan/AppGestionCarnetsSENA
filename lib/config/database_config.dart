class DatabaseConfig {
  // Configuración de la base de datos PostgreSQL
  // CAMBIAR ESTOS VALORES POR LOS DE TU SERVIDOR
  static const String host = 'localhost'; // o tu IP del servidor
  static const String port = '5432';
  static const String database = 'sena_carnets_db';
  static const String username = 'tu_usuario';
  static const String password = 'tu_password';
  
  // URL del servidor intermedio (Node.js, PHP, etc.)
  static const String serverUrl = 'http://192.168.1.100:3000'; // CAMBIAR POR TU IP
  
  // String de conexión completa
  static String get connectionString => 
      'postgresql://$username:$password@$host:$port/$database';
}
