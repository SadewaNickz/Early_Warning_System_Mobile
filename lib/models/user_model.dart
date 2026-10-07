/// Model representasi data akun pengguna / operator yang sedang aktif di aplikasi EWS.
class UserModel {
  /// Identifier unik pengguna
  final String id;

  /// Nama lengkap operator / petugas
  final String name;

  /// Peran pengguna (misal: 'Operator Lapangan', 'Administrator')
  final String role;

  /// Instansi kedinasan (misal: 'DPU Kota Semarang')
  final String agency;

  /// Inisial 2 huruf untuk ditampilkan pada avatar (misal: 'BP')
  final String initials;

  const UserModel({
    required this.id,
    required this.name,
    required this.role,
    required this.agency,
    required this.initials,
  });

  /// Membuat salinan objek dengan modifikasi nilai tertentu
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
