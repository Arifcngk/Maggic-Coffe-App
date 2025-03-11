import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/provider/coffe_provider.dart';
import 'package:maggic_coffe/view/home/menu/widgets/coffe_card_widget.dart';
import 'package:provider/provider.dart';

class CoffeeListWidget extends StatefulWidget {
  const CoffeeListWidget({super.key});

  @override
  State<CoffeeListWidget> createState() => _CoffeeListWidgetState(); // Düzeltildi: Coffee
}

class _CoffeeListWidgetState extends State<CoffeeListWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final coffeeProvider = Provider.of<CoffeeProvider>(context, listen: false);
      coffeeProvider.fetchCoffees(); // İlk yüklemede her zaman çek
    });
  }

  @override
  Widget build(BuildContext context) {
    final coffeeProvider = Provider.of<CoffeeProvider>(context);

    return Positioned.fill(
      top: MediaQuery.of(context).size.height * 0.1,
      child: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
          color: Color(0xFF324A59),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Select your Coffee",
              textAlign: TextAlign.left,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: const Color(0xFFD8D8D8),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: coffeeProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : coffeeProvider.
                  coffees.isEmpty
                      ? const Center(
                          child: Text(
                            'Kahve bulunamadı',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        )
                      : GridView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 6,
                            childAspectRatio: 0.96,
                          ),
                          itemCount: coffeeProvider.coffees.length,
                          itemBuilder: (context, index) {
                            return CoffeeCardWidget(index: index,);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}