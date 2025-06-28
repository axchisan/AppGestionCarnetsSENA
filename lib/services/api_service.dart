import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../models/student_model.dart';
import '../models/device_model.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // Cliente HTTP
  final http.Client _client = http.Client();

  // Token de autenticación
  String? _authToken;
  
  void setAuthToken(String token) {
    _authToken = token;
  }

  String? get authToken => _authToken;

  // Método genérico para hacer peticiones HTTP
  Future<Map<String, dynamic>> _makeRequest(
    String method,
    String endpoint, {
    Map<String, dynamic>? body,
    bool requiresAuth = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConfig.baseUrl}$endpoint');
      
      Map<String, String> headers = requiresAuth && _authToken != null
          ? ApiConfig.getAuthHeaders(_authToken!)
          : ApiConfig.defaultHeaders;

      http.Response response;

      switch (method.toUpperCase()) {
        case 'GET':
          response = await _client.get(url, headers: headers);
          break;
        case 'POST':
          response = await _client.post(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'PUT':
          response = await _client.put(
            url,
            headers: headers,
            body: body != null ? jsonEncode(body) : null,
          );
          break;
        case 'DELETE':
          response = await _client.delete(url, headers: headers);
          break;
        default:
          throw Exception('Método HTTP no soportado: $method');
      }

      return _handleResponse(response);
    } on SocketException {
      throw Exception('Sin conexión a internet');
    } on HttpException {
      throw Exception('Error de conexión con el servidor');
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    final Map<String, dynamic> data = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else {
      throw Exception(data['message'] ?? 'Error del servidor');
    }
  }

  // MÉTODOS DE AUTENTICACIÓN
  
  /// Validar si un número de identificación existe en la base de datos
  Future<bool> validateStudentIdentification(String identificationNumber) async {
    try {
      final response = await _makeRequest(
        'POST',
        ApiConfig.validateStudentEndpoint,
        body: {'identification_number': identificationNumber},
      );
      
      return response['exists'] == true;
    } catch (e) {
      print('Error validando identificación: $e');
      return false;
    }
  }

  /// Registrar un nuevo aprendiz
  Future<Map<String, dynamic>> registerStudent({
    required String identificationNumber,
    required String fullName,
    required String email,
    required String password,
    required String program,
    required String ficha,
    String? photoBase64,
  }) async {
    final body = {
      'identification_number': identificationNumber,
      'full_name': fullName,
      'email': email,
      'password': password,
      'program': program,
      'ficha': ficha,
      if (photoBase64 != null) 'photo_base64': photoBase64,
    };

    return await _makeRequest('POST', ApiConfig.registerEndpoint, body: body);
  }

  /// Iniciar sesión
  Future<Map<String, dynamic>> login({
    required String identificationNumber,
    required String password,
  }) async {
    final response = await _makeRequest(
      'POST',
      ApiConfig.loginEndpoint,
      body: {
        'identification_number': identificationNumber,
        'password': password,
      },
    );

    // Guardar token de autenticación
    if (response['token'] != null) {
      setAuthToken(response['token']);
    }

    return response;
  }

  // MÉTODOS DE PERFIL DE ESTUDIANTE

  /// Obtener perfil del estudiante
  Future<Student> getStudentProfile() async {
    final response = await _makeRequest(
      'GET',
      ApiConfig.studentProfileEndpoint,
      requiresAuth: true,
    );

    return Student.fromJson(response['student']);
  }

  /// Actualizar perfil del estudiante
  Future<Student> updateStudentProfile({
    String? fullName,
    String? email,
    String? program,
    String? photoBase64,
  }) async {
    final body = <String, dynamic>{};
    
    if (fullName != null) body['full_name'] = fullName;
    if (email != null) body['email'] = email;
    if (program != null) body['program'] = program;
    if (photoBase64 != null) body['photo_base64'] = photoBase64;

    final response = await _makeRequest(
      'PUT',
      ApiConfig.studentProfileEndpoint,
      body: body,
      requiresAuth: true,
    );

    return Student.fromJson(response['student']);
  }

  // MÉTODOS DE DISPOSITIVOS

  /// Obtener dispositivos del estudiante
  Future<List<Device>> getStudentDevices() async {
    final response = await _makeRequest(
      'GET',
      ApiConfig.devicesEndpoint,
      requiresAuth: true,
    );

    return (response['devices'] as List)
        .map((device) => Device.fromJson(device))
        .toList();
  }

  /// Registrar un nuevo dispositivo
  Future<Device> registerDevice({
    required String deviceId,
    required String deviceName,
    required DeviceType type,
  }) async {
    final response = await _makeRequest(
      'POST',
      ApiConfig.devicesEndpoint,
      body: {
        'device_id': deviceId,
        'device_name': deviceName,
        'device_type': type.toString().split('.').last,
      },
      requiresAuth: true,
    );

    return Device.fromJson(response['device']);
  }

  /// Eliminar un dispositivo
  Future<void> deleteDevice(String deviceId) async {
    await _makeRequest(
      'DELETE',
      '${ApiConfig.devicesEndpoint}/$deviceId',
      requiresAuth: true,
    );
  }

  // MÉTODOS DE PROGRAMAS

  /// Obtener lista de programas disponibles
  Future<List<String>> getAvailablePrograms() async {
    final response = await _makeRequest('GET', ApiConfig.programsEndpoint);
    
    return (response['programs'] as List).cast<String>();
  }
}
