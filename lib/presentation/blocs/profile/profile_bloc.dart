import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:shartflix/domain/entities/entities.dart';
import 'package:shartflix/domain/usecases/usecases.dart';

// Profile Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class ProfilePhotoUploadRequested extends ProfileEvent {
  final String filePath;

  const ProfilePhotoUploadRequested({required this.filePath});

  @override
  List<Object> get props => [filePath];
}

class ProfileDataUpdated extends ProfileEvent {
  final UserEntity user;

  const ProfileDataUpdated({required this.user});

  @override
  List<Object> get props => [user];
}

// Profile States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileDataLoaded extends ProfileState {
  final UserEntity user;

  const ProfileDataLoaded({required this.user});

  @override
  List<Object> get props => [user];
}

class ProfilePhotoUploading extends ProfileState {}

class ProfilePhotoUploadSuccess extends ProfileState {
  final String photoUrl;

  const ProfilePhotoUploadSuccess({required this.photoUrl});

  @override
  List<Object> get props => [photoUrl];
}

class ProfilePhotoUploadError extends ProfileState {
  final String message;

  const ProfilePhotoUploadError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UploadPhotoUseCase _uploadPhotoUseCase;

  ProfileBloc(this._uploadPhotoUseCase) : super(ProfileInitial()) {
    on<ProfilePhotoUploadRequested>(_onProfilePhotoUploadRequested);
    on<ProfileDataUpdated>(_onProfileDataUpdated);
  }

  Future<void> _onProfilePhotoUploadRequested(
    ProfilePhotoUploadRequested event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfilePhotoUploading());

    final result = await _uploadPhotoUseCase(
      UploadPhotoParams(filePath: event.filePath),
    );

    result.fold(
      (failure) => emit(ProfilePhotoUploadError(message: failure.message)),
      (photoUrl) => emit(ProfilePhotoUploadSuccess(photoUrl: photoUrl)),
    );
  }

  void _onProfileDataUpdated(
    ProfileDataUpdated event,
    Emitter<ProfileState> emit,
  ) {
    emit(ProfileDataLoaded(user: event.user));
  }
}
