import 'package:flutter/material.dart';
import '../utils/app_colors.dart';
import '../widgets/custom_button.dart';
import '../widgets/sena_logo.dart';

class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({super.key});

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  final _deviceIdController = TextEditingController();
  final _deviceNameController = TextEditingController();
  
  final List<Map<String, dynamic>> _devices = [
    {
      'name': 'PC - Escritorio',
      'id': 'PC123456',
      'icon': Icons.computer,
      'type': 'Computador',
    },
    {
      'name': 'Tablet - Samsung',
      'id': 'TAB456789',
      'icon': Icons.tablet,
      'type': 'Tablet',
    },
    {
      'name': 'Móvil - iPhone',
      'id': 'MOB789012',
      'icon': Icons.smartphone,
      'type': 'Teléfono',
    },
  ];

  String _selectedType = 'Computador';
  final List<String> _deviceTypes = [
    'Computador',
    'Portátil',
    'Tablet',
    'Teléfono',
    'Cargador',
    'Mouse',
    'Teclado',
    'Audífonos',
    'Otro',
  ];

  @override
  void dispose() {
    _deviceIdController.dispose();
    _deviceNameController.dispose();
    super.dispose();
  }

  void _addDevice() {
    if (_deviceIdController.text.isNotEmpty && _deviceNameController.text.isNotEmpty) {
      setState(() {
        _devices.add({
          'name': _deviceNameController.text,
          'id': _deviceIdController.text,
          'icon': _getIconForType(_selectedType),
          'type': _selectedType,
        });
        _deviceIdController.clear();
        _deviceNameController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Dispositivo agregado exitosamente'),
          backgroundColor: AppColors.senaGreen,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: AppColors.red,
        ),
      );
    }
  }

  void _removeDevice(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Eliminar Dispositivo'),
          content: Text('¿Estás seguro de que quieres eliminar "${_devices[index]['name']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _devices.removeAt(index);
                });
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

  IconData _getIconForType(String type) {
    switch (type) {
      case 'Computador':
      case 'Portátil':
        return Icons.computer;
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
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const SenaLogo(
          width: 100,
          height: 32,
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
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

              // Lista de dispositivos
              const Text(
                'Dispositivos Registrados',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.black,
                ),
              ),
              const SizedBox(height: 16),

              Expanded(
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
                                        device['type'],
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

              // Sección agregar dispositivo
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

              // Formulario para agregar dispositivo
              TextField(
                controller: _deviceIdController,
                decoration: InputDecoration(
                  labelText: 'ID del Dispositivo',
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
                  hintText: 'Ej: Mi Laptop, Tablet Personal, etc.',
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

              // Dropdown para tipo de dispositivo
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

              // Información adicional
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  border: Border.all(color: Colors.blue.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Colors.blue,
                      size: 20,
                    ),
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
            ],
          ),
        ),
      ),
    );
  }
}
