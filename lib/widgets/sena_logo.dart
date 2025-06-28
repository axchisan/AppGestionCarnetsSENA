import 'package:flutter/material.dart';

class SenaLogo extends StatelessWidget {
  final double width;
  final double height;
  final bool showShadow;

  const SenaLogo({
    super.key,
    this.width = 150,
    this.height = 50,
    this.showShadow = false,
  });

  @override
  Widget build(BuildContext context) {
    Widget logoImage = Image.asset(
      'assets/images/sena_logo.png',
      width: width,
      height: height,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF00A651),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              'SENA',
              style: TextStyle(
                color: Colors.white,
                fontSize: height * 0.4,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      },
    );

    if(showShadow) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: logoImage,
      );
    }
    return logoImage;
  }
}
