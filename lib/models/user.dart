class User {
  final int id;
  final String username;
  final String email;
  final String? phone;
  final String? address;

  User({
    required this.id,
    required this.username,
    required this.email,
    this.phone,
    this.address,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    final id = json['user_id'] ?? json['id'];
    if (id == null) {
      throw Exception('Kullanıcı ID bulunamadı');
    }
    return User(
      id: id is int
          ? id
          : int.parse(id.toString()), // String gelirse int'e çevir
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
    );
  }
}
