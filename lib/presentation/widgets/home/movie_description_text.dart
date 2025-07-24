import 'package:flutter/material.dart';

class MovieDescriptionText extends StatelessWidget {
  final String description;
  final String moreText;
  final VoidCallback onMoreTap;

  const MovieDescriptionText({
    super.key,
    required this.description,
    required this.moreText,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onMoreTap,
      behavior: HitTestBehavior.opaque,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return _buildDescriptionText(context, constraints);
        },
      ),
    );
  }

  Widget _buildDescriptionText(
      BuildContext context, BoxConstraints constraints) {
    final textStyle = Theme.of(context).textTheme.headlineSmall;
    final moreStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.w700,
        );

    // Short description case
    if (description.length <= 50) {
      return Text(
        description,
        style: textStyle,
        maxLines: 2,
      );
    }

    // Check if text exceeds 2 lines
    final textPainter = TextPainter(
      text: TextSpan(text: description, style: textStyle),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: constraints.maxWidth);

    if (textPainter.didExceedMaxLines) {
      // Text exceeds 2 lines, need to truncate with "More"
      return _buildTruncatedText(context, constraints, textStyle, moreStyle);
    } else {
      // Text fits in 2 lines, show with "More" below
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: textStyle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            moreText,
            style: moreStyle,
          ),
        ],
      );
    }
  }

  Widget _buildTruncatedText(
    BuildContext context,
    BoxConstraints constraints,
    TextStyle? textStyle,
    TextStyle? moreStyle,
  ) {
    final words = description.split(' ');
    String truncatedText = '';

    // Find the right place to cut
    for (int i = 0; i < words.length; i++) {
      final testText = words.sublist(0, i + 1).join(' ');
      final testPainter = TextPainter(
        text: TextSpan(
          text: '$testText $moreText',
          style: textStyle,
        ),
        maxLines: 2,
        textDirection: TextDirection.ltr,
      );
      testPainter.layout(maxWidth: constraints.maxWidth);

      if (testPainter.didExceedMaxLines) {
        break;
      }
      truncatedText = testText;
    }

    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: truncatedText,
            style: textStyle,
          ),
          TextSpan(
            text: ' $moreText',
            style: moreStyle,
          ),
        ],
      ),
    );
  }
}
