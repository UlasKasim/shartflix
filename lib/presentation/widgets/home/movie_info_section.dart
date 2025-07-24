import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shartflix/core/constants/constants.dart';
import 'package:shartflix/core/extensions/extensions.dart';
import 'package:shartflix/domain/entities/entities.dart';
import 'package:shartflix/presentation/widgets/home/home.dart';

class MovieInfoSection extends StatelessWidget {
  final MovieEntity movie;
  final VoidCallback onMoreTap;

  const MovieInfoSection({
    super.key,
    required this.movie,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App Logo
        SvgPicture.asset(
          AssetConstants.iconLogo,
          height: 40,
          width: 40,
        ),

        const SizedBox(width: 16),

        // Movie Title and Description
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                movie.title,
                style: Theme.of(context).textTheme.headlineLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Description with "More" functionality
              MovieDescriptionText(
                description: movie.description,
                moreText: context.l10n.more,
                onMoreTap: onMoreTap,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
