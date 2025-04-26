import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl; // Eklendi

  const ImageWidget({
    super.key,
    required this.imageUrl, // Eklendi
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Color(0xFFF7F8FB),
          borderRadius: BorderRadius.all(Radius.circular(30))),
      height: 150,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Image.network(
          imageUrl, // Güncellendi
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) =>
              const Icon(Icons.error), // Hata durumunda ikon
        ),
      ),
    );
  }
}