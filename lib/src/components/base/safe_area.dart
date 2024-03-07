import 'package:flutter/material.dart' as base;

class SafeArea extends base.SafeArea {
  const SafeArea({
    base.Key? key,
    required child,
    bool left = true,
    bool top = true,
    bool right = true,
    bool bottom = true,
    base.EdgeInsets minimum = base.EdgeInsets.zero,
    bool maintainBottomViewPadding = false,
  }) : super(
          key: key,
          child: child,
          left: left,
          top: top,
          right: right,
          bottom: bottom,
          minimum: minimum,
          maintainBottomViewPadding: maintainBottomViewPadding,
        );
}