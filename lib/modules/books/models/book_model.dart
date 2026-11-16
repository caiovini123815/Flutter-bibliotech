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
      id: json['id'],
      title: json['title'] ?? '',
      publicationDate: json['publicationDate'],
      genre: json['genre'] ?? '',
      numberPages: json['numberPages'] ?? 0,
      quantity: json['quantity'] ?? 0,
      publisher: json['publisher'],
    );
  }

  String get publisherName {
    if (publisher == null) return '—';

    return publisher!['namePublisher']?.toString() ?? '—';
  }
}