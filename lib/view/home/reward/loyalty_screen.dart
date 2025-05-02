import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maggic_coffe/services/api_service.dart';
import 'package:maggic_coffe/global_widget/appbar_global_widget.dart';

class LoyaltyScreen extends StatefulWidget {
  const LoyaltyScreen({super.key});

  @override
  _LoyaltyScreenState createState() => _LoyaltyScreenState();
}

class _LoyaltyScreenState extends State<LoyaltyScreen> {
  int _weeklyOrderCount = 0;
  int _totalPoints = 0;
  List<dynamic> _coffeeHistory = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApi();
  }

  Future<void> _initializeApi() async {
    await ApiService.init();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      print('Loading user points...');
      final pointsData = await ApiService.getUserPoints();
      print('Points data: $pointsData');

      print('Loading weekly orders...');
      final weeklyData = await ApiService.getWeeklyOrderCount();
      print('Weekly data: $weeklyData');

      print('Loading coffee history...');
      final historyData = await ApiService.getCoffeeHistory();
      print('History data: $historyData');
      print(
          'First item in history: ${historyData.isNotEmpty ? historyData[0] : 'No data'}');
      print(
          'Point value of first item: ${historyData.isNotEmpty ? historyData[0]['point_value'] : 'No data'}');

      setState(() {
        _totalPoints = pointsData['total_points'] ?? 0;
        _weeklyOrderCount = weeklyData['weeklyOrderCount'] ?? 0;
        _coffeeHistory = historyData;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading data: $e');
      setState(() {
        _isLoading = false;
        _error = 'Veri yüklenemedi: $e';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veri yüklenemedi: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarGlobalWidget(txt: 'Sadakat Programı'),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: RefreshIndicator(
                onRefresh: _loadData,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Puan Kartı
                      _buildPointsCard(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      // Haftalık Siparişler
                      _buildWeeklyOrders(),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02),
                      // Kahve Geçmişi
                      _buildCoffeeHistory(),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildPointsCard() {
    // Bir sonraki ücretsiz kahve için gereken puanı hesapla
    final nextFreeCoffeePoints = 250;
    final remainingPoints =
        nextFreeCoffeePoints - (_totalPoints % nextFreeCoffeePoints);
    final progressValue =
        (_totalPoints % nextFreeCoffeePoints) / nextFreeCoffeePoints;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF324A59), Color(0xFF001833)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Puanlarım',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '$_totalPoints Puan',
                    style: GoogleFonts.poppins(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: progressValue,
                backgroundColor: Colors.white.withOpacity(0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                remainingPoints == nextFreeCoffeePoints
                    ? 'Ücretsiz kahve için $nextFreeCoffeePoints puan toplayın!'
                    : '$remainingPoints puan sonra ücretsiz kahve!',
                style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                ),
              ),
              if (_totalPoints >= nextFreeCoffeePoints) ...[
                const SizedBox(height: 16),
                Center(
                  child: ElevatedButton(
                    onPressed: () => _showFreeCoffeeDialog(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    child: Text(
                      'Ücretsiz Kahve Kullan',
                      style: GoogleFonts.poppins(
                        color: const Color(0xFF324A59),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showFreeCoffeeDialog() async {
    try {
      final coffees = await ApiService.getCoffees();
      final branches = await ApiService.getBranches();
      if (!mounted) return;

      int? selectedBranchId;
      int? selectedCoffeeId;

      showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            title: Text(
              'Ücretsiz Kahve Seç',
              style: GoogleFonts.poppins(
                color: const Color(0xFF324A59),
                fontWeight: FontWeight.w600,
              ),
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Şube Seçimi
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Şube Seçin',
                      labelStyle: GoogleFonts.poppins(
                        color: const Color(0xFF324A59),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF324A59),
                        ),
                      ),
                    ),
                    value: selectedBranchId,
                    items: branches.map((branch) {
                      return DropdownMenuItem<int>(
                        value: branch['branch_id'],
                        child: Text(
                          branch['branch_name'],
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF324A59),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedBranchId = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  // Kahve Seçimi
                  DropdownButtonFormField<int>(
                    decoration: InputDecoration(
                      labelText: 'Kahve Seçin',
                      labelStyle: GoogleFonts.poppins(
                        color: const Color(0xFF324A59),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF324A59),
                        ),
                      ),
                    ),
                    value: selectedCoffeeId,
                    items: coffees.map((coffee) {
                      return DropdownMenuItem<int>(
                        value: coffee['coffee_id'],
                        child: Text(
                          coffee['coffee_name'],
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF324A59),
                          ),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedCoffeeId = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  'İptal',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF324A59),
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: selectedBranchId != null && selectedCoffeeId != null
                    ? () async {
                        try {
                          await ApiService.redeemFreeCoffee(
                            selectedCoffeeId!,
                            selectedBranchId!,
                          );
                          if (!mounted) return;
                          Navigator.pop(context);
                          _loadData(); // Puanları yenile
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Ücretsiz kahveniz başarıyla kullanıldı!'),
                              backgroundColor: Colors.green,
                            ),
                          );
                        } catch (e) {
                          if (!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Hata: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF324A59),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: Text(
                  'Onayla',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Veriler yüklenirken hata oluştu: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Widget _buildWeeklyOrders() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Haftalık Siparişler',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF324A59),
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              '$_weeklyOrderCount/7',
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: const Color(0xFF324A59),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xFF324A59).withOpacity(0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF324A59).withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(7, (index) {
              final isActive = index < _weeklyOrderCount;
              return Column(
                children: [
                  Image.asset(
                    isActive
                        ? "assets/img/coffe_cupe.png"
                        : "assets/img/coffe_cupe_1.png",
                    width: 30,
                    height: 30,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${index + 1}',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      color: isActive
                          ? const Color(0xFF324A59)
                          : const Color(0xFFD8D8D8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildCoffeeHistory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "History Rewards",
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: const Color(0xFF324A59),
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.02),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _coffeeHistory.length,
          itemBuilder: (context, index) {
            final item = _coffeeHistory[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['coffee_name'],
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: const Color(0xFF324A59),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(
                          height: MediaQuery.of(context).size.height * 0.004),
                      Text(
                        '${item['order_date']}',
                        style: GoogleFonts.poppins(
                          fontSize: 10,
                          color: const Color(0xFFD8D8D8),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    '+${item['point_value'] ?? 0} Pts',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: const Color(0xFF324A59),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
