import 'dart:convert';
import 'dart:io';
import 'package:hive/hive.dart';
import 'package:postgres/postgres.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 
import '../models/models.dart';

class DatabaseService {
  static const String _hiveBoxName = 'aprendicesBox';

  // Obtenemos las variables de entorno con manejo de nulos
  static String get _postgresHost => dotenv.env['POSTGRES_HOST'] ?? 'default_host';
  static int get _postgresPort => int.tryParse(dotenv.env['POSTGRES_PORT'] ?? '5432') ?? 5432;
  static String get _postgresDatabase => dotenv.env['POSTGRES_DATABASE'] ?? 'default_db';
  static String get _postgresUsername => dotenv.env['POSTGRES_USERNAME'] ?? 'default_user';
  static String get _postgresPassword => dotenv.env['POSTGRES_PASSWORD'] ?? 'default_password';

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
      return false;
    }
  }

  Future<void> saveAprendiz(Aprendiz aprendiz) async {
    try {
      await _aprendicesBox.put(aprendiz.idIdentificacion, aprendiz);
      await _syncToPostgres(aprendiz);
    } catch (e) {}
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

      await conn.transaction((ctx) async {
        await ctx.query(
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

        await ctx.query('DELETE FROM dispositivos WHERE id_identificacion = @id', substitutionValues: {'id': aprendiz.idIdentificacion});
        for (var dispositivo in aprendiz.dispositivos) {
          await ctx.query(
            '''
            INSERT INTO dispositivos (id_dispositivo, id_identificacion, nombre_dispositivo, tipo_dispositivo, fecha_registro)
            VALUES (@idDispositivo, @id, @nombre, @tipo, @fecha)
            ON CONFLICT (id_identificacion, id_dispositivo) DO UPDATE SET 
              nombre_dispositivo = @nombre, 
              tipo_dispositivo = @tipo, 
              fecha_registro = @fecha
            ''',
            substitutionValues: {
              'idDispositivo': dispositivo.idDispositivo,
              'id': dispositivo.idIdentificacion,
              'nombre': dispositivo.nombreDispositivo,
              'tipo': dispositivo.tipoDispositivo ?? 'Otro',
              'fecha': dispositivo.fechaRegistro.toIso8601String(),
            },
          );
        }
      });

      await conn.close();
    } catch (e) {}
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
        final aprendiz = Aprendiz(
          idIdentificacion: row[0] as String,
          nombreCompleto: row[1] as String,
          programaFormacion: row[2] as String,
          numeroFicha: row[3] as String,
          tipoSangre: row[4] as String?,
          fotoPerfilPath: (row[5] as String?) != null ? await _saveImageLocally(row[5] as String) : null,
          contrasena: row[6] as String,
          email: row[7] as String?,
          fechaRegistro: row[8] is String ? DateTime.parse(row[8] as String) : (row[8] as DateTime),
          dispositivos: await _loadDevicesFromPostgres(id),
        );
        return aprendiz;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Dispositivo>> _loadDevicesFromPostgres(String idIdentificacion) async {
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
        'SELECT id_dispositivo, id_identificacion, nombre_dispositivo, tipo_dispositivo, fecha_registro FROM dispositivos WHERE id_identificacion = @id',
        substitutionValues: {'id': idIdentificacion},
      );
      await conn.close();

      return results.map((row) => Dispositivo(
        idDispositivo: row[0] as String,
        idIdentificacion: row[1] as String,
        nombreDispositivo: row[2] as String,
        tipoDispositivo: row[3] as String?,
        fechaRegistro: row[4] is String ? DateTime.parse(row[4] as String) : (row[4] as DateTime),
      )).toList();
    } catch (e) {
      return [];
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
      return null;
    }
  }

  Future<void> addDevice(String idIdentificacion, String deviceName, String deviceId, String deviceType) async {
    final aprendiz = await getAprendizFromLocal(idIdentificacion);
    if (aprendiz != null) {
      final newDevice = Dispositivo(
        idDispositivo: deviceId,
        idIdentificacion: idIdentificacion,
        nombreDispositivo: deviceName,
        tipoDispositivo: deviceType,
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
    }
  }
}