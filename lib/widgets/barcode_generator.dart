import 'package:flutter/material.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../utils/app_colors.dart';

class BarcodeGenerator extends StatelessWidget {
  final String data;
  final double width;
  final double height;

  const BarcodeGenerator({
    super.key,
    required this.data,
    this.width = 200,
    this.height = 60,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.gray.withOpacity(0.3)),
      ),
      child: BarcodeWidget(
        barcode: Barcode.code128(),
        data: data,
        width: width,
        height: height,
        drawText: false,
        color: Colors.black,
        backgroundColor: Colors.white,
      ),
    );
  }
}

class QRCodeGenerator extends StatelessWidget {
  final String data;
  final double size;

  const QRCodeGenerator({
    super.key,
    required this.data,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.gray.withOpacity(0.3)),
      ),
      child: QrImageView(
        data: data,
        version: QrVersions.auto,
        size: size,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
    );
  }
}
