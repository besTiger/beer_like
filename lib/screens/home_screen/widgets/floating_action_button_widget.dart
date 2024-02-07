import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Function() onPressed;

  const CustomFloatingActionButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 70,
      height: 70,
      child: FloatingActionButton(
        onPressed: onPressed,
        child: Image.asset(
          'assets/logo_splash.png',
          width: 50,
          height: 50,
        ),
      ),
    );
  }
}
