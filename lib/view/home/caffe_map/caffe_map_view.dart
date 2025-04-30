import 'package:flutter/material.dart';
import 'package:maggic_coffe/global_widget/tabbar_global_widget.dart';
import 'package:provider/provider.dart';
import 'package:maggic_coffe/provider/branch_provider.dart';
import 'package:maggic_coffe/services/branch_service.dart';

class CoffeMapViewScreen extends StatefulWidget {
  const CoffeMapViewScreen({super.key});

  @override
  _CoffeMapViewScreenState createState() => _CoffeMapViewScreenState();
}

class _CoffeMapViewScreenState extends State<CoffeMapViewScreen> {
  @override
  void initState() {
    super.initState();
    // Veriyi çekmek için fetchBranches'i çağırıyoruz
    Provider.of<BranchProvider>(context, listen: false).fetchBranches();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF324A59),
      body: Stack(
        children: [
          // Üstteki Harita Bölgesi
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.7, // %40 Yükseklik
              child: Image.asset(
                "assets/img/maps.png",
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Alt Bölüm (Başlık ve Liste)
          Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              mainAxisSize: MainAxisSize.min, // Fazladan boşluk bırakmaz
              crossAxisAlignment:
                  CrossAxisAlignment.start, // Metni sola hizalar
              children: [
                // Alan-1 (Başlık)
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF324A59),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 30),
                  width: double.infinity,
                  child: Text(
                    "Select Magic Coffee Store",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),

                // Alan-2 (Şube Listeleme)
                Consumer<BranchProvider>(
                  builder: (context, provider, child) {
                    if (provider.branches.isEmpty) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                      ),
                      height: MediaQuery.of(context).size.height *
                          0.27, // %25 Yükseklik
                      child: ListView.builder(
                        padding:
                            const EdgeInsets.only(top: 14, right: 20, left: 20),
                        itemCount: provider.branches.length,
                        itemBuilder: (context, index) {
                          var branch = provider.branches[index];
                          return Container(
                            height: 60, // Konteyner yüksekliği
                            margin: const EdgeInsets.symmetric(vertical: 7),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                  16), // Köşe yuvarlaklığı
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xFFEEA4CE),
                                  Color(0xFFC58BF2)
                                ], // Gradient renkler
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 2,
                                  offset: Offset(2, 4), // Gölge efekti
                                ),
                              ],
                            ),
                            child: Center(
                              child: ListTile(
                                leading: const Icon(
                                  Icons.storefront,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                ),
                                title: Text(
                                  branch['branch_name'],
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                                onTap: () async {
                                  // Şube seçildiğinde, BranchProvider'a kaydediyoruz
                                  provider.selectBranch(branch);
                                  // Seçilen şubeyi SharedPreferences'a kaydediyoruz
                                  await BranchService().setSelectedBranch({
                                    'branch_id': branch['branch_id'],
                                    'branch_name': branch['branch_name'],
                                    'branch_address':
                                        branch['branch_address'] ??
                                            'No address provided'
                                  });
                                  // Şube seçildikten sonra BottomBarWidget'a yönlendiriyoruz
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const BottomBarWidget(), // Yönlendirme
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
