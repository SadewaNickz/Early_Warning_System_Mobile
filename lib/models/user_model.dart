class UserModel {
  final String id;
  final String name;
  final String role;
  final String agency;
  final String initials;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.agency,
    required this.initials,
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? role,
    String? agency,
    String? initials,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      agency: agency ?? this.agency,
      initials: initials ?? this.initials,
    );
  }
}
