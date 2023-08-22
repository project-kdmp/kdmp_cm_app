import 'package:flutter/material.dart';

class CustomAnimatedButton extends StatelessWidget {
  const CustomAnimatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.isEnabled = true,
    this.minimumSize = 50.0,
    this.borderRadius = 10,
  }) : super(key: key);

  final String text;
  final Function onPressed;
  final bool isEnabled;
  final double minimumSize;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isEnabled ? Colors.black : Colors.grey.shade300,
      ),
      child: GestureDetector(
        onTap: () {
          isEnabled ? onPressed() : null;
        },
        child: Container(
          width: double.infinity,
          height: 50.0,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: TextStyle(
              color: isEnabled ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}