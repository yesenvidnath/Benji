class Professional {
  final String name;
  final String role;
  final String avatarUrl;
  final bool isAvailable;
  final String specialization;
  final double reviewCount;
  final double rating;

  Professional({
    required this.name,
    required this.role,
    required this.avatarUrl,
    this.isAvailable = true, 
    required this.specialization,
    required this.reviewCount,
    required this.rating,
  });
}