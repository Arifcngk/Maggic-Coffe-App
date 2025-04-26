import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/services/credit_card_service.dart';

class AddCreditCardScreen extends StatefulWidget {
  const AddCreditCardScreen({super.key});

  @override
  _AddCreditCardScreenState createState() => _AddCreditCardScreenState();
}

class _AddCreditCardScreenState extends State<AddCreditCardScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardTitleController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  Future<void> _addCard() async {
    if (_formKey.currentState!.validate()) {
      try {
        await CreditCardService().addCreditCard(
          cardTitle: _cardTitleController.text.trim(),
          cardNumber: _cardNumberController.text.trim().replaceAll(' ', ''),
          expiryDate: _expiryDateController.text.trim(),
          cvv: _cvvController.text.trim(),
        );
        Navigator.pop(context, true);
      } catch (e) {
        print('Add card error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Kart eklenemedi: $e',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Kart Ekle',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Yeni Kart Bilgileri',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                _buildTextField(
                  controller: _cardTitleController,
                  label: 'Kart Başlığı (örn. Visa, Master)',
                  validator: (value) =>
                      value!.isEmpty ? 'Kart başlığı gerekli' : null,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _cardNumberController,
                  label: 'Kart Numarası',
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                  validator: (value) {
                    if (value!.isEmpty) return 'Kart numarası gerekli';
                    if (!RegExp(r'^\d{16}$')
                        .hasMatch(value.replaceAll(' ', ''))) {
                      return '16 haneli kart numarası gerekli';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _buildTextField(
                        controller: _expiryDateController,
                        label: 'Son Kullanma (MM/YY)',
                        keyboardType: TextInputType.datetime,
                        validator: (value) {
                          if (value!.isEmpty)
                            return 'Son kullanma tarihi gerekli';
                          if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                            return 'MM/YY formatı gerekli';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildTextField(
                        controller: _cvvController,
                        label: 'CVV',
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        validator: (value) {
                          if (value!.isEmpty) return 'CVV gerekli';
                          if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                            return '3 haneli CVV gerekli';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: ElevatedButton(
                    onPressed: _addCard,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001833),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      minimumSize: const Size(200, 52),
                      elevation: 2,
                    ),
                    child: Text(
                      'Kart Ekle',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
    int? maxLength,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLength: maxLength,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14,
          color: Colors.black,
        ),
        filled: true,
        fillColor: const Color(0xFFF7F8FB),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFF001833), width: 1.5),
        ),
        errorStyle: GoogleFonts.poppins(
          fontSize: 12,
          color: Colors.red,
        ),
      ),
      style: GoogleFonts.poppins(
        fontSize: 14,
        color: Colors.black,
      ),
      validator: validator,
    );
  }

  @override
  void dispose() {
    _cardTitleController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
}
