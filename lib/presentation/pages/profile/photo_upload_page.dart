import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/extensions/localization_extension.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/injection/injection_container.dart';
import '../../../core/theme/app_theme.dart';
import '../../blocs/profile/profile_bloc.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/profile/photo_upload_header.dart';
import '../../widgets/profile/photo_upload_area.dart';

class PhotoUploadPage extends StatefulWidget {
  const PhotoUploadPage({super.key});

  @override
  State<PhotoUploadPage> createState() => _PhotoUploadPageState();
}

class _PhotoUploadPageState extends State<PhotoUploadPage> {
  String? _selectedImagePath;
  final ImagePicker _imagePicker = ImagePicker();

  void _onImageSelected(String imagePath) {
    setState(() {
      _selectedImagePath = imagePath;
    });
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image != null) {
        _onImageSelected(image.path);
      }
    } catch (e) {
      if (mounted) {
        sl<NavigationService>().showSnackBar(
          context.l10n.errorImagePicker,
          type: SnackBarType.error,
        );
      }
    }
  }

  void _onContinuePressed() {
    if (_selectedImagePath != null) {
      context.read<ProfileBloc>().add(
            ProfilePhotoUploadRequested(filePath: _selectedImagePath!),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfilePhotoUploadSuccess) {
            sl<NavigationService>().showSnackBar(
              context.l10n.photoUploadSuccess,
              type: SnackBarType.success,
            );
            context.pop(); // Return to profile page
          } else if (state is ProfilePhotoUploadError) {
            sl<NavigationService>().showSnackBar(
              state.message,
              type: SnackBarType.error,
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                // Header
                PhotoUploadHeader(
                  title: context.l10n.profileDetail,
                  onBackPressed: () => context.pop(),
                ),

                const Spacer(flex: 2),

                // Content
                Column(
                  children: [
                    // Title
                    Text(
                      context.l10n.uploadYourPhotos,
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                height: 1.0,
                              ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 8),

                    // Description
                    Text(
                      context.l10n.photoUploadDescription,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                height: 1.0,
                              ),
                      textAlign: TextAlign.center,
                    ),

                    const SizedBox(height: 48),

                    // Photo Upload Area
                    PhotoUploadArea(
                      selectedImagePath: _selectedImagePath,
                      onTap: _pickImage,
                    ),
                  ],
                ),

                const Spacer(flex: 3),

                // Continue Button
                BlocBuilder<ProfileBloc, ProfileState>(
                  builder: (context, state) {
                    return PrimaryButton.bottomSheet(
                      text: context.l10n.continueText,
                      onPressed: _selectedImagePath != null
                          ? _onContinuePressed
                          : () {},
                      isLoading: state is ProfilePhotoUploading,
                      isEnabled: _selectedImagePath != null,
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
