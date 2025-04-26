import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/provider/coffe_provider.dart';
import 'package:maggic_coffe/view/home/order_options/view/order_options_view_screen.dart';
import 'package:provider/provider.dart';

class CoffeeCardWidget extends StatelessWidget {
  final int index;

  const CoffeeCardWidget({
    super.key,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final coffeeProvider = Provider.of<CoffeeProvider>(context);

    // Liste boşsa veya index geçersizse hata önleme
    if (coffeeProvider.coffees.isEmpty || index >= coffeeProvider.coffees.length) {
      return const SizedBox.shrink();
    }

    final coffee = coffeeProvider.coffees[index];

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderOptionsViewScreen(coffee: coffee),
          ),
        );
      },
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            coffee.imageUrl.isNotEmpty
                ? Image.network(
                    coffee.imageUrl, // Prefix kaldırıldı, internetten geliyor
                    width: 120,
                    height: 90,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error),
                  )
                : const Icon(Icons.image_not_supported, size: 90),
            const SizedBox(height: 10),
            Text(
              coffee.coffeeName, // Düzeltildi: coffeName → coffeeName
              style: GoogleFonts.dmSans(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}