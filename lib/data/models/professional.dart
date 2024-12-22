class Professional {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final double rating;
  final int reviewCount;
  final String specialization;
  final bool isAvailable;
  final double chargePerHr; // New field for hourly charge

  Professional({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.rating,
    required this.reviewCount,
    required this.specialization,
    required this.isAvailable,
    required this.chargePerHr,
  });

  factory Professional.fromJson(Map<String, dynamic> json) {
    return Professional(
      id: json['id'].toString(),
      name: json['name'] ?? 'Unknown',
      role: json['role'] ?? 'Unknown',
      avatarUrl: json['avatarUrl'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: json['reviewCount'] ?? 0,
      specialization: json['specialization'] ?? 'Unknown',
      isAvailable: (json['isAvailable'] ?? '').toString().toLowerCase() == 'active',
      chargePerHr: (json['charge_per_Hr'] as num?)?.toDouble() ?? 0.0, // Parse hourly charge
    );
  }
}
