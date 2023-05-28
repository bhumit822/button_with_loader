import 'package:button_with_loader/src/button_loading_state.dart';
import 'package:flutter/material.dart';

typedef OnTapCallback = Future Function();
typedef OnDoneCallback = Function();
typedef OnErrorCallback = Function(dynamic error, dynamic stackTrace);
typedef OnLoadingCallback = Function();
typedef ButtonBuilder = Widget Function(
    BuildContext context, ButtonState buttonState);
