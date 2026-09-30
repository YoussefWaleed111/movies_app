import 'package:equatable/equatable.dart';

class UserProfile extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int avatarIndex;
  final int wishlistCount;
  final int historyCount;

  const UserProfile({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.avatarIndex,
    required this.wishlistCount,
    required this.historyCount,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    int? avatarIndex,
    int? wishlistCount,
    int? historyCount,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarIndex: avatarIndex ?? this.avatarIndex,
      wishlistCount: wishlistCount ?? this.wishlistCount,
      historyCount: historyCount ?? this.historyCount,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        avatarIndex,
        wishlistCount,
        historyCount,
      ];
}
