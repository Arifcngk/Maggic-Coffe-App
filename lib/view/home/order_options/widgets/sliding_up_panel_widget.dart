import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/view/home/order_options/view/order_is_confirmed_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpPanelWidget extends StatefulWidget {
  final PanelController panelController; // Panel kontrolcüsü

  SlidingUpPanelWidget({super.key, required this.panelController});

  @override
  _SlidingUpPanelWidgetState createState() => _SlidingUpPanelWidgetState();
}

class _SlidingUpPanelWidgetState extends State<SlidingUpPanelWidget> {
  int? _selectedPaymentMethod = 0; // Seçili ödeme yöntemi

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      controller: widget.panelController,
      minHeight: 0,
      maxHeight: MediaQuery.of(context).size.height * 0.4,
      borderRadius: BorderRadius.circular(25),
      panel: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 33),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Order Payment",
              textAlign: TextAlign.start,
              style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF001833)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            _creditCardCustom(context),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.08,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Total Price",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Color.fromARGB(255, 97, 99, 107)),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.001,
                    ),
                    Text(
                      "BYN 3.00",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 22,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        WidgetStateProperty.all<Color>(const Color(0xFF001833)),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(30), // borderRadius 30
                      ),
                    ),
                    minimumSize: WidgetStateProperty.all<Size>(
                        const Size(165, 52)), // Boyut 165x52
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderIsConfirmedView(),
                        ));
                  },
                  child: const Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // İçeriği ortala
                    children: [
                      Icon(
                        Icons.account_balance_wallet, // Çizdan ikonu
                        color: Colors.white, // İkonun rengi beyaz
                        size: 20, // İkon boyutu
                      ),
                      SizedBox(width: 8), // İkon ile yazı arasında boşluk
                      Text(
                        "Pay Now",
                        style: TextStyle(
                          color: Colors.white, // Yazı rengi beyaz
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  SizedBox _creditCardCustom(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.1,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: const Color(0xFFF7F8FB),
        ),
        child: Row(
          children: [
            Row(
              children: [
                // Radio butonu
                Radio<int>(
                  activeColor: const Color(0xFF001833),
                  value: 0,
                  groupValue: _selectedPaymentMethod,
                  onChanged: (value) {
                    setState(() {
                      _selectedPaymentMethod = value;
                    });
                  },
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.04,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Credit Card",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.001,
                    ),
                    Text(
                      "2450 2450 2450 2450",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 12,
                        color: const Color.fromARGB(255, 97, 99, 107),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.1,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/img/visa.png",
                  width: 60,
                  height: 15,
                ),
                const SizedBox(height: 10),
                Image.asset(
                  "assets/img/master.png",
                  width: 60,
                  height: 35,
                  fit: BoxFit.cover,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
