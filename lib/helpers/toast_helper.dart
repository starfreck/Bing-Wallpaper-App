import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class Toast {
  dynamic context;
  dynamic message;

  Toast({
    required this.context,
    required this.message,
  }) {
    showToast(
      message,
      context: context,
      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      textStyle: Theme.of(context).textTheme.bodyLarge,
      borderRadius: BorderRadius.circular(25.0),
      animation: StyledToastAnimation.slideFromBottomFade,
      reverseAnimation: StyledToastAnimation.slideToBottomFade,
      startOffset: const Offset(0.0, 3.0),
      reverseEndOffset: const Offset(0.0, 3.0),
      position: const StyledToastPosition(
          align: Alignment.bottomCenter, offset: 75.0),
      duration: const Duration(seconds: 5),
      //Animation duration   animDuration * 2 <= duration
      animDuration: const Duration(milliseconds: 400),
      curve: Curves.linearToEaseOut,
      reverseCurve: Curves.fastOutSlowIn,
    );
  }
}
