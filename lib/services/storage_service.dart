import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/student_model.dart';

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  // Claves para SharedPreferences
  static const String _studentDataKey = 'student_data';
  static const String _isLoggedInKey = 'is_logged_in';

  /// Guardar datos del estudiante
  Future<void> saveStudentData(Student student) async {
    final prefs = await SharedPreferences.getInstance();
    final studentJson = jsonEncode(student.toJson());
    await prefs.setString(_studentDataKey, studentJson);
  }

  /// Obtener datos del estudiante
  Future<Student?> getStudentData() async {
    final prefs = await SharedPreferences.getInstance();
    final studentJson = prefs.getString(_studentDataKey);
    
    if (studentJson != null) {
      final studentMap = jsonDecode(studentJson);
      return Student.fromJson(studentMap);
    }
    
    return null;
  }

  /// Marcar como logueado
  Future<void> setLoggedIn(bool isLoggedIn) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLoggedInKey, isLoggedIn);
  }

  /// Verificar si está logueado
  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  /// Limpiar datos de sesión
  Future<void> clearSessionData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_studentDataKey);
    await prefs.setBool(_isLoggedInKey, false);
  }
}
