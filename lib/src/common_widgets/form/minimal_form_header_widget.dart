import 'package:flutter/material.dart';

class MinimalFormHeaderWidget extends StatelessWidget {
  const MinimalFormHeaderWidget({
    super.key,
    this.imageColor,
    this.heightBetween,
    required this.image,
    this.imageHeight = 0.2,
    this.textAlign,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  });

  //Variables -- Declared in Constructor
  final Color? imageColor;
  final double imageHeight;
  final double? heightBetween;
  final String image;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        Image(image: AssetImage(image), color: imageColor, height: size.height * imageHeight),
      ],
    );
  }
}
