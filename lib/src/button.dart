import 'package:button_with_loader/src/button_loading_state.dart';
import 'package:button_with_loader/src/extension.dart';
import 'package:button_with_loader/src/typedefs.dart';
import 'package:flutter/material.dart';

class ButtonWithLoaderBase extends StatelessWidget {
  ButtonWithLoaderBase({
    super.key,
    required this.onTap,
    this.durationforDoneSign,
    this.showDone = true,
    this.label = "Button",
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
  final OnTapCallback? onTap;
  final OnDoneCallback? onDone;
  final OnErrorCallback? onError;
  final OnLoadingCallback? onLoading;
  final int? durationforDoneSign;
  final bool? showDone;
  final String? label;
  final Color? color;
  final bool? autoToIdeal;
  final Widget? loadingIndicatorWidget;
  final Widget? errorIndicatorWidget;
  final Widget? doneIndicatorWidget;
  final Widget? idealIndicatorWidget;
  final BoxDecoration? decoration;

  final EdgeInsetsGeometry? padding;

  final ValueNotifier<ButtonState> buttonState =
      ValueNotifier(ButtonState.ideal);
  final BuilderShell builder = BuilderShell();
  Widget get loadingWidget =>
      loadingIndicatorWidget ??
      const SizedBox(
        width: 15,
        height: 15,
        child: CircularProgressIndicator(strokeWidth: 4),
      );

  Widget get idealWidget =>
      idealIndicatorWidget ??
      const SizedBox(
        width: 15,
        height: 15,
      );

  Widget get doneWidget =>
      doneIndicatorWidget ??
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
      errorIndicatorWidget ??
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
            onLoading?.call();

            await onTap?.call();
            if (showDone == true) {
              buttonState.value = ButtonState.done;
              onDone?.call();
              if (autoToIdeal == true) {
                await Future.delayed(
                    Duration(seconds: durationforDoneSign ?? 3), () {
                  buttonState.value = ButtonState.ideal;
                });
              }
            } else {
              buttonState.value = ButtonState.ideal;
              onDone?.call();
            }
          } catch (e, st) {
            buttonState.value = ButtonState.error;
            onError?.call(e, st);
            if (autoToIdeal == true) {
              await Future.delayed(Duration(seconds: durationforDoneSign ?? 3),
                  () {
                buttonState.value = ButtonState.ideal;
              });
            }
          }
        }
      },
      child: ValueListenableBuilder(
        valueListenable: buttonState,
        builder: (context, state, child) {
          return builder.builder != null
              ? builder.builder!.call(context, state)
              : Container(
                  color: color,
                  decoration: decoration,
                  padding: padding,
                  child: IntrinsicHeight(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(
                          width: 15,
                          height: 15,
                        ),
                        5.wSpace,
                        Text(label ?? "Button"),
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

class ButtonWithLoader extends ButtonWithLoaderBase {
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
    required Widget Function(BuildContext, ButtonState) builder,
  }) {
    super.builder.builder = builder;
  }
}

class BuilderShell {
  ButtonBuilder? builder;
}
