import 'package:hive/hive.dart';
import 'package:postgres/postgres.dart';
import '../models/models.dart';

class DatabaseService {
  static const String _hiveBoxName = 'aprendicesBox';
  static const String _postgresHost = 'hopper.proxy.rlwy.net';
  static const int _postgresPort = 47980;
  static const String _postgresDatabase = 'railway';
  static const String _postgresUsername = 'postgres';
  static const String _postgresPassword = 'QpxOPUaKNhfIufGenMKFHdEquICkGhEc';

  // Usar un getter lazy para el Box
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
      print('Guardado exitoso: ${_aprendicesBox.containsKey(aprendiz.idIdentificacion)}');
    } catch (e) {
      print('Error al guardar aprendiz: $e');
    }
  }

  Aprendiz? getAprendiz(String id) {
    return _aprendicesBox.get(id);
  }

  Future<void> addDevice(String idIdentificacion, String deviceName) async {
    final aprendiz = getAprendiz(idIdentificacion);
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
    }
  }
}