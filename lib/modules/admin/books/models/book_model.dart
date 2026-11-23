class BookModel {
  final int id;
  final String title;
  final String? publicationDate;
  final String genre;
  final int numberPages;
  final int quantity;
  final Map<String, dynamic>? publisher;

  BookModel({
    required this.id,
    required this.title,
    this.publicationDate,
    required this.genre,
    required this.numberPages,
    required this.quantity,
    this.publisher,
  });

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      id: json['id'] as int,
      title: json['title']?.toString() ?? '',
      publicationDate: json['publicationDate']?.toString(),
      genre: json['genre']?.toString() ?? '',
      numberPages: json['numberPages'] ?? 0,
      quantity: json['quantity'] ?? 0,
      publisher: json['publisher'] is Map
          ? Map<String, dynamic>.from(json['publisher'])
          : null,
    );
  }

  String get publisherName {
    if (publisher == null) {
      return '—';
    }

    return publisher!['namePublisher']?.toString() ?? '—';
  }
}