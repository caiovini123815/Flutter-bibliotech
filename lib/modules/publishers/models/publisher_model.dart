class PublisherModel {
  final int id;
  final String namePublisher;
  final String email;
  final String phonePublisher;
  final String website;

  PublisherModel({
    required this.id,
    required this.namePublisher,
    required this.email,
    required this.phonePublisher,
    required this.website,
  });

  factory PublisherModel.fromJson(Map<String, dynamic> json) {
    return PublisherModel(
      id: json['id'],
      namePublisher: json['namePublisher'] ?? '',
      email: json['email'] ?? '—',
      phonePublisher: json['phonePublisher'] ?? '—',
      website: json['website'] ?? '—',
    );
  }
}