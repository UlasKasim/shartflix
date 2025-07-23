import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../core/error/failures.dart';
import '../../repositories/auth_repository.dart';
import '../usecase.dart';

class UploadPhotoUseCase implements UseCase<String, UploadPhotoParams> {
  final AuthRepository repository;

  UploadPhotoUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(UploadPhotoParams params) async {
    // Validate file path
    if (params.filePath.isEmpty) {
      return const Left(ValidationFailure(message: 'Please select a photo'));
    }

    // Check file extension
    if (!_isValidImageFile(params.filePath)) {
      return const Left(ValidationFailure(
        message: 'Please select a valid image file (jpg, jpeg, png)',
      ));
    }

    return await repository.uploadPhoto(params.filePath);
  }

  bool _isValidImageFile(String filePath) {
    final allowedExtensions = ['.jpg', '.jpeg', '.png', '.webp'];
    final lowerPath = filePath.toLowerCase();
    return allowedExtensions.any((ext) => lowerPath.endsWith(ext));
  }
}

class UploadPhotoParams extends Equatable {
  final String filePath;

  const UploadPhotoParams({required this.filePath});

  @override
  List<Object> get props => [filePath];
}
