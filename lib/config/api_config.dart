class ApiConfig {
  // Configuración del servidor - CAMBIAR POR TU IP/DOMINIO
  static const String baseUrl = 'http://192.168.1.100:8080'; // IP de tu servidor Java
  static const String apiVersion = '/api/v1';
  
  // Endpoints principales
  static const String loginEndpoint = '$apiVersion/auth/login';
  static const String registerEndpoint = '$apiVersion/auth/register';
  static const String validateStudentEndpoint = '$apiVersion/students/validate';
  static const String studentProfileEndpoint = '$apiVersion/students/profile';
  static const String devicesEndpoint = '$apiVersion/devices';
  static const String programsEndpoint = '$apiVersion/programs';
  
  // Headers por defecto
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Headers con autenticación
  static Map<String, String> getAuthHeaders(String token) => {
    ...defaultHeaders,
    'Authorization': 'Bearer $token',
  };
}
