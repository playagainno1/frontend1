import 'package:flutter/material.dart';

class BaseExactButton extends StatefulWidget {
  final Widget child;
  final void Function() onPressed;
  final Size size;

  const BaseExactButton(
      {required this.child,
      required this.onPressed,
      required this.size,
      super.key});

  @override
  State<BaseExactButton> createState() => _BaseExactButtonState();
}

class _BaseExactButtonState extends State<BaseExactButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        widget.onPressed();
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        surfaceTintColor: Colors.transparent,
        padding: const EdgeInsets.all(0),
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        minimumSize:  widget.size,
      ),
      child: widget.child,
    );
  }
}
