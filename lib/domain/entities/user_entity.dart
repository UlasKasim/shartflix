import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final String? id;
  final String? name;
  final String? email;
  final String? photoUrl;

  const UserEntity({
    this.id,
    this.name,
    this.email,
    this.photoUrl,
  });

  UserEntity copyWith({
    String? id,
    String? name,
    String? email,
    String? photoUrl,
  }) {
    return UserEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      photoUrl: photoUrl ?? this.photoUrl,
    );
  }

  @override
  List<Object?> get props => [id, name, email, photoUrl];

  @override
  bool get stringify => true;
}
