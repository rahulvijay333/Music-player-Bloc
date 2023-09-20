import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({
    super.key,
    required this.size,
    required this.heading,
    this.popFunction,
    this.optionLeftIconFunction,
    this.twoItems,
    this.popIcon,
    this.optionIcon,  this.widgetRight, this.widgetLeft,
  });

  final Size size;
  final String heading;
  final Function? popFunction;
  final Function? optionLeftIconFunction;
  final bool? twoItems;
  final Icon? popIcon;
  final Icon? optionIcon;
  final Widget? widgetRight;
  final Widget? widgetLeft;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.centerLeft,
      children: [
        Container(
          height: size.height * 0.07,
          width: size.width,
          child: Center(
              child: Text(
            heading,
            style: TextStyle(color: Colors.white, fontSize: size.width * 0.045,fontWeight: FontWeight.w500),
          )),
        ),
        twoItems == true
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                 widgetLeft!,
                  widgetRight!
                ],
              )
            : IconButton(
                onPressed: () {
                  if (popFunction != null) {
                    popFunction!();
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                icon: popIcon ??
                    Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ))
      ],
    );
  }
}
