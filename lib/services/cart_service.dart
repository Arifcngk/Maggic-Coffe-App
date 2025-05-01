import '../models/cart_item.dart';
import '../services/api_service.dart';

class CartService {
  // Singleton instance
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  double getTotalPrice(List<CartItem> items) {
    return items.fold(0, (sum, item) {
      double basePrice = item.coffee.price;
      double volumePrice = 0;

      // Add price differences based on volume
      if (item.volumeMl == 350) {
        volumePrice = 10; // 10 TL extra for 350ml
      } else if (item.volumeMl == 450) {
        volumePrice = 20; // 20 TL extra for 450ml
      }

      return sum + (item.quantity * (basePrice + volumePrice));
    });
  }

  Future<List<CartItem>> getCart() async {
    return _items;
  }

  void addItem(CartItem item) {
    print('Sepete ekleniyor: $item');
    // Aynı kahve ve özelliklerde ürün varsa miktarını artır
    final existingItemIndex = _items.indexWhere((existingItem) =>
        existingItem.coffee.coffeeId == item.coffee.coffeeId &&
        existingItem.volumeMl == item.volumeMl &&
        existingItem.intensity == item.intensity &&
        existingItem.isTakeaway == item.isTakeaway);

    if (existingItemIndex != -1) {
      _items[existingItemIndex].quantity += item.quantity;
    } else {
      _items.add(item);
    }
    print('Sepet güncellendi: $_items');
  }

  void removeItem(CartItem item) {
    _items.remove(item);
  }

  void clearCart() {
    _items.clear();
  }

  Future<Map<String, dynamic>> createOrder({
    required List<CartItem> items,
    required int branchId,
    required int cardId,
  }) async {
    try {
      // Sipariş öğelerini hazırla
      final orderItems = items
          .map((item) => {
                'coffee_id': item.coffee.coffeeId,
                'quantity': item.quantity,
                'unit_price': item.coffee.price,
                'volume_ml': item.volumeMl,
                'is_takeaway': item.isTakeaway,
                'intensity': item.intensity,
              })
          .toList();

      // Toplam fiyatı hesapla
      final totalPrice = getTotalPrice(items);

      // API'ye sipariş oluşturma isteği gönder
      final response = await ApiService.createOrder(
        items: orderItems,
        branchId: branchId,
        cardId: cardId,
        totalPrice: totalPrice,
      );

      // Başarılı ise sepeti temizle
      if (response['message'] == 'Sipariş oluşturuldu') {
        _items.clear();
      }

      return response;
    } catch (e) {
      throw Exception('Sipariş oluşturulamadı: $e');
    }
  }
}
