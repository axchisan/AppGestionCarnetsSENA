import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/sena_logo.dart';
import '../services/database_service.dart';
import '../models/models.dart';

class DeviceManagementScreen extends StatefulWidget {
  final Aprendiz? aprendiz;

  const DeviceManagementScreen({super.key, this.aprendiz});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  final _deviceIdController = TextEditingController();
  final _deviceNameController = TextEditingController();
  final _deviceTypeController = TextEditingController();

  final List<Map<String, dynamic>> _devices = [];
  String _selectedType = 'Portátil';
  final List<String> _deviceTypes = [
    'Portátil',
    'Tablet',
    'Teléfono',
    'Cargador',
    'Mouse',
    'Teclado',
    'Audífonos',
    'Otro',
  ];

  final DatabaseService _dbService = DatabaseService();
  static const int _maxDevices = 10;

  @override
  void initState() {
    super.initState();
    _loadDevices();
  }

  Future<void> _loadDevices() async {
    if (widget.aprendiz != null) {
      final aprendiz = await _dbService.getAprendizFromLocal(
        widget.aprendiz!.idIdentificacion,
      );
      if (aprendiz != null) {
        setState(() {
          _devices.clear();
          _devices.addAll(
            aprendiz.dispositivos.map(
              (d) => {
                'name': d.nombreDispositivo,
                'id': d.idDispositivo,
                'type': d.tipoDispositivo ?? 'Otro',
                'icon': _getIconForType(d.tipoDispositivo ?? 'Otro'),
              },
            ),
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _deviceIdController.dispose();
    _deviceNameController.dispose();
    _deviceTypeController.dispose();
    super.dispose();
  }

  void _addDevice() async {
    if (_deviceIdController.text.isNotEmpty &&
        _deviceNameController.text.isNotEmpty &&
        _selectedType.isNotEmpty) {
      if (_devices.length >= _maxDevices) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Has alcanzado el límite de 10 dispositivos'),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }

      if (_devices.any((d) => d['id'] == _deviceIdController.text.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('El ID del dispositivo ya está registrado'),
            backgroundColor: AppColors.red,
          ),
        );
        return;
      }

      if (widget.aprendiz != null) {
        await _dbService.addDevice(
          widget.aprendiz!.idIdentificacion,
          _deviceNameController.text.trim(),
          _deviceIdController.text.trim(),
          _selectedType,
        );
        await _loadDevices();
        setState(() {
          _deviceIdController.clear();
          _deviceNameController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dispositivo agregado exitosamente'),
            backgroundColor: AppColors.senaGreen,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  void _removeDevice(int index) async {
    if (widget.aprendiz != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Eliminar Dispositivo'),
            content: Text(
              '¿Estás seguro de que quieres eliminar "${_devices[index]['name']}"?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async {
                  final deviceId = _devices[index]['id'];
                  final aprendiz = await _dbService.getAprendizFromLocal(
                    widget.aprendiz!.idIdentificacion,
                  );
                  if (aprendiz != null) {
                    final updatedDispositivos = aprendiz.dispositivos
                        .where((d) => d.idDispositivo != deviceId)
                        .toList();
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
                    await _dbService.saveAprendiz(updatedAprendiz);
                    await _loadDevices();
                  }
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Dispositivo eliminado'),
                      backgroundColor: AppColors.red,
                    ),
                  );
                },
                child: const Text(
                  'Eliminar',
                  style: TextStyle(color: AppColors.red),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Portátil':
        return Icons.laptop;
      case 'Tablet':
        return Icons.tablet;
      case 'Teléfono':
        return Icons.smartphone;
      case 'Cargador':
        return Icons.power;
      case 'Mouse':
        return Icons.mouse;
      case 'Teclado':
        return Icons.keyboard;
      case 'Audífonos':
        return Icons.headphones;
      default:
        return Icons.devices;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              backgroundColor: AppColors.white,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.black),
                onPressed: () => Navigator.pop(context),
              ),
              title: const SenaLogo(
                width: 120,
                height: 40,
                showShadow: false,
              ),
              centerTitle: true,
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height - kToolbarHeight,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Center(
                        child: Text(
                          'Mis Dispositivos',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.black,
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        'Dispositivos Registrados',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: 200,
                        child: _devices.isEmpty
                            ? const Center(
                                child: Text(
                                  'No tienes dispositivos registrados',
                                  style: TextStyle(
                                    color: AppColors.gray,
                                    fontSize: 16,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _devices.length,
                                itemBuilder: (context, index) {
                                  final device = _devices[index];
                                  return Container(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: AppColors.lightGray,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          device['icon'],
                                          color: AppColors.senaGreen,
                                          size: 24,
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                device['name'],
                                                style: const TextStyle(
                                                  color: AppColors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                'ID: ${device['id']}',
                                                style: const TextStyle(
                                                  color: AppColors.gray,
                                                  fontSize: 14,
                                                ),
                                              ),
                                              Text(
                                                'Tipo: ${device['type']}',
                                                style: const TextStyle(
                                                  color: AppColors.gray,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () => _removeDevice(index),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: AppColors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Agregar Nuevo Dispositivo',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _deviceIdController,
                        decoration: InputDecoration(
                          labelText: 'ID del Dispositivo (Serial)',
                          hintText: 'Ej: PC001, TAB123, etc.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.senaGreen,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.senaGreen,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _deviceNameController,
                        decoration: InputDecoration(
                          labelText: 'Nombre del Dispositivo',
                          hintText: 'Ej: Acer, Samsung, etc.',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.senaGreen,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.senaGreen,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      DropdownButtonFormField<String>(
                        value: _selectedType,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Dispositivo',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.senaGreen,
                              width: 2,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: AppColors.senaGreen,
                              width: 2,
                            ),
                          ),
                        ),
                        items: _deviceTypes.map((tipo) {
                          return DropdownMenuItem<String>(
                            value: tipo,
                            child: Row(
                              children: [
                                Icon(
                                  _getIconForType(tipo),
                                  color: AppColors.senaGreen,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Text(tipo),
                              ],
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            setState(() {
                              _selectedType = newValue;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        text: 'Agregar Dispositivo',
                        onPressed: _addDevice,
                        icon: Icons.add,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          border: Border.all(color: Colors.blue.shade200),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue, size: 20),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Registra tus dispositivos para facilitar el acceso al centro de formación.',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}