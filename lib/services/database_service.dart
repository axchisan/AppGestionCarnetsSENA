import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:postgres/postgres.dart';
import 'package:path_provider/path_provider.dart';
import '../models/models.dart';

class DatabaseService {
  static const String _hiveBoxName = 'aprendicesBox';
  static const String _postgresHost = 'hopper.proxy.rlwy.net';
  static const int _postgresPort = 47980;
  static const String _postgresDatabase = 'railway';
  static const String _postgresUsername = 'postgres';
  static const String _postgresPassword = 'QpxOPUaKNhfIufGenMKFHdEquICkGhEc';

  Box<Aprendiz> get _aprendicesBox => Hive.box<Aprendiz>(_hiveBoxName);

  Future<bool> validateIdentification(String id) async {
    try {
      final conn = PostgreSQLConnection(
        _postgresHost,
        _postgresPort,
        _postgresDatabase,
        username: _postgresUsername,
        password: _postgresPassword,
      );
      await conn.open();
      final results = await conn.query(
        'SELECT id_identificacion FROM aprendices WHERE id_identificacion = @id',
        substitutionValues: {'id': id},
      );
      await conn.close();
      return results.isNotEmpty;
    } catch (e) {
      print('Error validating ID: $e');
      return false;
    }
  }

  Future<void> saveAprendiz(Aprendiz aprendiz) async {
    try {
      print('Intentando guardar aprendiz con ID: ${aprendiz.idIdentificacion}');
      await _aprendicesBox.put(aprendiz.idIdentificacion, aprendiz);
      print('Guardado local exitoso: ${_aprendicesBox.containsKey(aprendiz.idIdentificacion)}');
      await _syncToPostgres(aprendiz);
    } catch (e) {
      print('Error al guardar aprendiz: $e');
    }
  }

  Future<void> _syncToPostgres(Aprendiz aprendiz) async {
    try {
      final conn = PostgreSQLConnection(
        _postgresHost,
        _postgresPort,
        _postgresDatabase,
        username: _postgresUsername,
        password: _postgresPassword,
      );
      await conn.open();

      String? encodedImage = aprendiz.fotoPerfilPath != null
          ? base64Encode(await File(aprendiz.fotoPerfilPath!).readAsBytes())
          : null;

      print('Guardando contraseña hasheada: ${aprendiz.contrasena}');
      await conn.query(
        '''
        INSERT INTO aprendices (
          id_identificacion, nombre_completo, programa_formacion, numero_ficha, 
          tipo_sangre, foto_perfil, contrasena, email, fecha_registro
        ) VALUES (
          @id, @nombre, @programa, @ficha, @tipoSangre, @foto, @contrasena, @email, @fecha
        ) ON CONFLICT (id_identificacion) DO UPDATE SET 
          nombre_completo = @nombre, 
          programa_formacion = @programa, 
          numero_ficha = @ficha, 
          tipo_sangre = @tipoSangre, 
          foto_perfil = @foto, 
          contrasena = @contrasena, 
          email = @email, 
          fecha_registro = @fecha
        ''',
        substitutionValues: {
          'id': aprendiz.idIdentificacion,
          'nombre': aprendiz.nombreCompleto,
          'programa': aprendiz.programaFormacion,
          'ficha': aprendiz.numeroFicha,
          'tipoSangre': aprendiz.tipoSangre,
          'foto': encodedImage,
          'contrasena': aprendiz.contrasena,
          'email': aprendiz.email,
          'fecha': aprendiz.fechaRegistro.toIso8601String(),
        },
      );

      await conn.close();
      print('Sincronización con PostgreSQL exitosa para ID: ${aprendiz.idIdentificacion}');
    } catch (e) {
      print('Error al sincronizar con PostgreSQL: $e');
    }
  }

  Future<Aprendiz?> getAprendizFromLocal(String id) async {
    return _aprendicesBox.get(id);
  }

  Future<Aprendiz?> getAprendizFromPostgres(String id, String password) async {
    try {
      final conn = PostgreSQLConnection(
        _postgresHost,
        _postgresPort,
        _postgresDatabase,
        username: _postgresUsername,
        password: _postgresPassword,
      );
      await conn.open();
      print('Consultando aprendiz con ID: $id y contraseña hasheada: $password');
      final results = await conn.query(
        '''
        SELECT id_identificacion, nombre_completo, programa_formacion, numero_ficha, 
               tipo_sangre, foto_perfil, contrasena, email, fecha_registro 
        FROM aprendices WHERE id_identificacion = @id AND contrasena = @password
        ''',
        substitutionValues: {'id': id, 'password': password},
      );
      await conn.close();

      if (results.isNotEmpty) {
        final row = results.first;
        print('Resultado de consulta: $row');
        return Aprendiz(
          idIdentificacion: row[0] as String,
          nombreCompleto: row[1] as String,
          programaFormacion: row[2] as String,
          numeroFicha: row[3] as String,
          tipoSangre: row[4] as String?,
          fotoPerfilPath: (row[5] as String?) != null ? await _saveImageLocally(row[5] as String) : null,
          contrasena: row[6] as String,
          email: row[7] as String?,
          fechaRegistro: row[8] is String ? DateTime.parse(row[8] as String) : (row[8] as DateTime),
          dispositivos: [],
        );
      }
      print('No se encontró aprendiz con las credenciales proporcionadas');
      return null;
    } catch (e) {
      print('Error al obtener aprendiz de PostgreSQL: $e');
      return null;
    }
  }

  Future<String?> _saveImageLocally(String base64String) async {
    try {
      final bytes = base64Decode(base64String);
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/profile_${DateTime.now().millisecondsSinceEpoch}.png');
      await file.writeAsBytes(bytes);
      return file.path;
    } catch (e) {
      print('Error al guardar imagen localmente: $e');
      return null;
    }
  }

  Future<void> addDevice(String idIdentificacion, String deviceName) async {
    final aprendiz = await getAprendizFromLocal(idIdentificacion);
    if (aprendiz != null) {
      final newDevice = Dispositivo(
        idDispositivo: DateTime.now().millisecondsSinceEpoch,
        idIdentificacion: idIdentificacion,
        nombreDispositivo: deviceName,
        fechaRegistro: DateTime.now(),
      );
      final updatedDispositivos = List<Dispositivo>.from(aprendiz.dispositivos)..add(newDevice);
      final updatedAprendiz = Aprendiz(
        idIdentificacion: aprendiz.idIdentificacion,
        nombreCompleto: aprendiz.nombreCompleto,
        programaFormacion: aprendiz.programaFormacion,
        numeroFicha: aprendiz.numeroFicha,
        tipoSangre: aprendiz.tipoSangre,
        fotoPerfilPath: aprendiz.fotoPerfilPath,
        contrasena: aprendiz.contrasena,
        email: aprendiz.email,
        fechaRegistro: aprendiz.fechaRegistro,
        dispositivos: updatedDispositivos,
      );
      await saveAprendiz(updatedAprendiz);
      await _syncToPostgres(updatedAprendiz);
    }
  }
}