
class RentModel {
  final int id;
  final int userId;
  final String userName;
  final int bookId;
  final String bookTitle;
  final DateTime rentDate;
  final DateTime? returnPeriod;
  final DateTime? returnDate;
  final String status;

  RentModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.bookId,
    required this.bookTitle,
    required this.rentDate,
    required this.returnPeriod,
    required this.returnDate,
    required this.status,
  });

  factory RentModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] is Map
        ? Map<String, dynamic>.from(json['user'])
        : <String, dynamic>{};

    final book = json['book'] is Map
        ? Map<String, dynamic>.from(json['book'])
        : <String, dynamic>{};

    return RentModel(
      id: (json['id'] as num).toInt(),
      userId: (user['id'] as num).toInt(),
      userName: user['nameFull'] ?? '—',
      bookId: (book['id'] as num).toInt(),
      bookTitle: book['title'] ?? '—',
      rentDate: DateTime.parse(json['rentDate']),
      returnPeriod: json['returnPeriod'] != null
          ? DateTime.parse(json['returnPeriod'])
          : null,
      returnDate: json['returnDate'] != null
          ? DateTime.parse(json['returnDate'])
          : null,
      status: json['status'] ?? '—',
    );
  }
}
