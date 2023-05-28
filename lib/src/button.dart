import 'package:button_with_loader/src/button_loading_state.dart';
import 'package:button_with_loader/src/extension.dart';
import 'package:button_with_loader/src/typedefs.dart';
import 'package:flutter/material.dart';

class _ButtonWithLoader extends StatefulWidget {
  _ButtonWithLoader({
    super.key,
    required this.onTap,
    this.durationforDoneSign,
    this.showDone = true,
    this.label,
    this.color,
    this.padding = const EdgeInsets.all(10),
    this.decoration,
    this.loadingIndicatorWidget,
    this.onDone,
    this.autoToIdeal = true,
    this.onError,
    this.onLoading,
    this.errorIndicatorWidget,
    this.idealIndicatorWidget,
    this.doneIndicatorWidget,
  }) : assert(
          color == null || decoration == null,
          'Cannot provide both a color and a decoration\n'
          'To provide both, use "decoration: BoxDecoration(color: color)".',
        );
  OnTapCallback? onTap;
  OnDoneCallback? onDone;
  OnErrorCallback? onError;
  OnLoadingCallback? onLoading;
  int? durationforDoneSign;
  bool? showDone;
  String? label = "Button";
  Color? color;
  bool? autoToIdeal;
  ButtonBuilder? builder;
  Widget? loadingIndicatorWidget;
  Widget? errorIndicatorWidget;
  Widget? doneIndicatorWidget;
  Widget? idealIndicatorWidget;
  BoxDecoration? decoration;
  EdgeInsetsGeometry? padding = const EdgeInsets.all(10);
  @override
  State<_ButtonWithLoader> createState() => _ButtonWithLoaderState();
}

class _ButtonWithLoaderState extends State<_ButtonWithLoader> {
  ValueNotifier<ButtonState> buttonState = ValueNotifier(ButtonState.ideal);
  Widget get loadingWidget =>
      widget.loadingIndicatorWidget ??
      const SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(strokeWidth: 4),
      );
  Widget get idealWidget =>
      widget.idealIndicatorWidget ??
      const SizedBox(
        width: 15,
        height: 15,
      );
  Widget get doneWidget =>
      widget.doneIndicatorWidget ??
      const SizedBox(
        width: 15,
        height: 15,
        child: FittedBox(
          child: Center(
            child: Icon(
              Icons.check,
              color: Colors.greenAccent,
            ),
          ),
        ),
      );
  Widget get errorWidget =>
      widget.errorIndicatorWidget ??
      const SizedBox(
        width: 15,
        height: 15,
        child: FittedBox(
          child: Center(
            child: Icon(
              Icons.warning_rounded,
              color: Colors.yellow,
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (buttonState.value != ButtonState.loading) {
          try {
            buttonState.value = ButtonState.loading;
            widget.onLoading?.call();

            await widget.onTap?.call();
            if (widget.showDone == true) {
              buttonState.value = ButtonState.done;
              widget.onDone?.call();
              if (widget.autoToIdeal == true) {
                await Future.delayed(
                    Duration(seconds: widget.durationforDoneSign ?? 3), () {
                  buttonState.value = ButtonState.ideal;
                });
              }
            } else {
              buttonState.value = ButtonState.ideal;
              widget.onDone?.call();
            }
          } catch (e, st) {
            buttonState.value = ButtonState.error;
            widget.onError?.call(e, st);
            if (widget.autoToIdeal == true) {
              await Future.delayed(
                  Duration(seconds: widget.durationforDoneSign ?? 3), () {
                buttonState.value = ButtonState.ideal;
              });
            }
          }
        }
      },
      child: ValueListenableBuilder(
        valueListenable: buttonState,
        builder: (context, state, child) {
          return widget.builder != null
              ? widget.builder!.call(context, state)
              : Container(
                  color: widget.color,
                  decoration: widget.decoration,
                  padding: widget.padding,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 15,
                          height: 15,
                        ),
                        5.wSpace,
                        Text(widget.label ?? "Button"),
                        5.wSpace,
                        buildLoader(state),
                      ],
                    ),
                  ),
                );
        },
      ),
    );
  }

  Widget buildLoader(ButtonState state) {
    switch (state) {
      case ButtonState.loading:
        return loadingWidget;

      case ButtonState.ideal:
        return idealWidget;

      case ButtonState.done:
        return doneWidget;

      case ButtonState.error:
        return errorWidget;
    }
  }
}

class ButtonWithLoader extends _ButtonWithLoader {
  ButtonWithLoader({
    super.key,
    required super.onTap,
    super.durationforDoneSign,
    super.showDone = true,
    required super.label,
    super.color,
    super.padding = const EdgeInsets.all(10),
    super.decoration,
    super.loadingIndicatorWidget,
    super.autoToIdeal = true,
    super.onDone,
    super.onError,
    super.onLoading,
    super.errorIndicatorWidget,
    super.idealIndicatorWidget,
    super.doneIndicatorWidget,
  });

  ButtonWithLoader.builder({
    super.key,
    required super.onTap,
    super.onDone,
    super.autoToIdeal = true,
    super.onError,
    super.showDone = true,
    super.onLoading,
    required ButtonBuilder builder,
  }) {
    super.builder = builder;
  }
}
