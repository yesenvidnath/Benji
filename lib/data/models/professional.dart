class Professional {
  final String name;
  final String role;
  final String avatarUrl;
  final bool isAvailable;

  Professional({
    required this.name,
    required this.role,
    required this.avatarUrl,
    this.isAvailable = true,
  });
}