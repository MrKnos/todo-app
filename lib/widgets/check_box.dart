import 'package:flutter/material.dart';

class CheckBox extends StatelessWidget {
  const CheckBox({
    required this.isChecked,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  final bool isChecked;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: isChecked
          ? Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.amber,
              ),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.check,
                  size: 30,
                  color: Colors.black,
                ),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 4,
                  color: Colors.amber,
                ),
              ),
              child: const Icon(
                Icons.circle,
                color: Colors.white,
                size: 30,
              ),
            ),
    );
  }
}
