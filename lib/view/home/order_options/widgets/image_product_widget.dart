import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final String imageUrl;

  const ImageWidget({
    super.key,
    required this.imageUrl,
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
          'http://10.0.2.2:8000/coffee-images/$imageUrl',
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            print('Image error: $error');
            return const Icon(Icons.error, size: 50, color: Colors.grey);
          },
        ),
      ),
    );
  }
}
