import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthLoginRequested({required this.email, required this.password});
  @override
  List<Object?> get props => [email, password];
}

class AuthRegisterRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String phone;
  const AuthRegisterRequested({
    required this.name,
    required this.email,
    required this.password,
    required this.phone,
  });
  @override
  List<Object?> get props => [name, email, password, phone];
}

class AuthPasswordResetRequested extends AuthEvent {
  final String email;
  const AuthPasswordResetRequested({required this.email});
  @override
  List<Object?> get props => [email];
}

class AuthUpdateProfileRequested extends AuthEvent {
  final String name;
  final String phone;
  final int avatarIndex;
  const AuthUpdateProfileRequested({
    required this.name,
    required this.phone,
    required this.avatarIndex,
  });
  @override
  List<Object?> get props => [name, phone, avatarIndex];
}

class AuthLogoutRequested extends AuthEvent {}
