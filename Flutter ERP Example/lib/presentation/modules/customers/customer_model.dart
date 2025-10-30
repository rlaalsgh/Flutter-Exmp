class Customer {
  final int id;
  final String name;
  final String phone;
  final String email;
  final String address;

  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.address,
  });

  // ✅ copyWith 메서드 추가
  Customer copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
  }) {
    return Customer(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  // ✅ JSON 변환이 필요할 경우 (나중 DB 연동 대비)
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'phone': phone,
        'email': email,
        'address': address,
      };

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        email: json['email'] ?? '',
        address: json['address'] ?? '',
      );
}
