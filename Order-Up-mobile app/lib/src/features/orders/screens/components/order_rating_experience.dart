import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

typedef RatingChangeCallback = void Function(double rating);

class RatingExperience extends StatelessWidget {
  const RatingExperience({
    super.key,
    required this.title,
    required this.rate,
    required this.ratingChangeCallback,
  });
  final String title;
  final double rate;
  final RatingChangeCallback ratingChangeCallback;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: Colors.white,
        border: Border.all(
          color: Colors.white,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColor.accentColor,
                ),
          ),
          StarRating(
            filledIconData: Icons.abc_outlined,
            halfFilledIconData: Icons.abc_rounded,
            defaultIconData: Icons.safety_check,
            rating: rate,
            size: 25.0,
            color: AppColor.primaryColor,
            borderColor: AppColor.primaryColor,
            onRatingChanged: ratingChangeCallback,
          ),
        ],
      ),
    );
  }
}

class StarRating extends StatelessWidget {
  const StarRating({
    super.key,
    this.starCount = 5,
    this.spacing = 0.0,
    this.rating = 0.0,
    required this.defaultIconData,
    required this.onRatingChanged,
    required this.color,
    required this.borderColor,
    this.size = 24,
    required this.filledIconData,
    required this.halfFilledIconData,
    this.allowHalfRating = true,
  });
  final int starCount;
  final double rating;
  final RatingChangeCallback onRatingChanged;
  final Color color;
  final Color borderColor;
  final double size;
  final bool allowHalfRating;
  final IconData filledIconData;
  final IconData halfFilledIconData;
  final IconData defaultIconData;
  final double spacing;

  Widget buildStar(BuildContext context, int index) {
    Icon icon;
    if (index >= rating) {
      icon = Icon(
        Icons.star_border,
        color: Theme.of(context).primaryColor,
        size: size,
      );
    } else if (index > rating - (allowHalfRating ? 1.0 : 0.5) &&
        index < rating) {
      icon = Icon(
        Icons.star_half,
        color: Theme.of(context).primaryColor,
        size: size,
      );
    } else {
      icon = Icon(
        Icons.star,
        color: Theme.of(context).primaryColor,
        size: size,
      );
    }

    return GestureDetector(
      onTap: () {
        onRatingChanged(index + 1.0);
      },
      onHorizontalDragUpdate: (dragDetails) {},
      child: icon,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: spacing,
        children: List.generate(
          starCount,
          (index) => buildStar(context, index),
        ),
      ),
    );
  }
}
