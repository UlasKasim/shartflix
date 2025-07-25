import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shartflix/presentation/widgets/common/common.dart';

import '../../../core/extensions/localization_extension.dart';
import '../../../core/services/navigation_service.dart';
import '../../../core/injection/injection_container.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/responsive_helper.dart';
import '../../blocs/profile/profile_bloc.dart';
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
      // Check if widget is still mounted after async operation
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
    final r = context.responsive;

    return Scaffold(
      backgroundColor: AppTheme.backgroundDark,
      body: BlocListener<ProfileBloc, ProfileState>(
        listener: (context, profileState) {
          if (profileState is ProfilePhotoUploadSuccess) {
            sl<NavigationService>().showSnackBar(
              context.l10n.photoUploadSuccess,
              type: SnackBarType.success,
            );
            context.pop();
          } else if (profileState is ProfilePhotoUploadError) {
            sl<NavigationService>().showSnackBar(
              profileState.message,
              type: SnackBarType.error,
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: r.horizontalPadding),
            child: Column(
              children: [
                PhotoUploadHeader(
                  title: context.l10n.profileDetail,
                  onBackPressed: () => context.pop(),
                ),

                const SizedBox(height: 30),

                // Content
                Expanded(
                  child: r.contentWrapper(
                    child: Column(
                      children: [
                        // Title and Description
                        _buildTitleSection(context, r),

                        SizedBox(height: r.responsive(mobile: 48, tablet: 64)),

                        // Photo Upload Area - responsive
                        PhotoUploadArea(
                          selectedImagePath: _selectedImagePath,
                          onTap: _pickImage,
                        ),

                        const Spacer(),

                        // Continue Button - responsive
                        _buildContinueButton(context, r),

                        SizedBox(height: r.largeSpacing),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleSection(BuildContext context, ResponsiveHelper r) {
    return Column(
      children: [
        Text(
          context.l10n.uploadYourPhotos,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: r.responsive(mobile: 18, tablet: 22),
                fontWeight: FontWeight.w600,
                height: 1.0,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: r.smallSpacing),
        Text(
          context.l10n.photoUploadDescription,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontSize: r.responsive(mobile: 13, tablet: 16),
                fontWeight: FontWeight.w400,
                height: 1.0,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildContinueButton(BuildContext context, ResponsiveHelper r) {
    return BlocBuilder<ProfileBloc, ProfileState>(
      builder: (context, state) {
        return Container(
          width: double.infinity,
          constraints: BoxConstraints(
            maxWidth: r.responsive(mobile: double.infinity, tablet: 300),
          ),
          child: PrimaryButton.bottomSheet(
            text: context.l10n.continueText,
            onPressed: _selectedImagePath != null ? _onContinuePressed : () {},
            isLoading: state is ProfilePhotoUploading,
            isEnabled: _selectedImagePath != null,
          ),
        );
      },
    );
  }
}
