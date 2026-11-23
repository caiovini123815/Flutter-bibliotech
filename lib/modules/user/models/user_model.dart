
class UserModel {
  final int id;
  final String nameFull;
  final String phone;
  final DateTime? dateBirth;
  final String address;
  final bool isAdmin;
  final bool isDisable;

  UserModel({
    required this.id,
    required this.nameFull,
    required this.phone,
    this.dateBirth,
    required this.address,
    required this.isAdmin,
    required this.isDisable,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: (json['id'] as num).toInt(),
      nameFull: json['nameFull'] ?? '',
      phone: json['phone'] ?? '',
      dateBirth: json['dateBirth'] != null
          ? DateTime.tryParse(json['dateBirth'].toString())
          : null,
      address: json['address'] ?? '',
      isAdmin: json['isAdmin'] ?? false,
      isDisable: json['isDisable'] ?? false,
    );
  }
}
