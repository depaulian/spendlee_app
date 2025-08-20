import 'package:flutter/material.dart';

class CoreFormHeaderWidget extends StatelessWidget {
  const CoreFormHeaderWidget({
    Key? key,
    this.imageColor,
    this.heightBetween,
    required this.title,
    required this.subTitle,
    this.textAlign,
    this.crossAxisAlignment = CrossAxisAlignment.start,
  }) : super(key: key);

  //Variables -- Declared in Constructor
  final Color? imageColor;
  final double? heightBetween;
  final String title, subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final TextAlign? textAlign;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        SizedBox(height: heightBetween),
        Text(title, style: Theme.of(context).textTheme.displayLarge),
        Text(subTitle, textAlign: textAlign, style: Theme.of(context).textTheme.bodyLarge),
      ],
    );
  }
}
