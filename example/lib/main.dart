import 'package:button_with_loader/button_with_loader.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ButtonExampleWidget(),
    );
  }
}

class ButtonExampleWidget extends StatelessWidget {
  const ButtonExampleWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ButtonWithLoader(
              doneIndicatorWidget: const SizedBox(
                height: 15,
                width: 15,
                child: FittedBox(
                  child: Icon(
                    Icons.check,
                    color: Colors.white,
                  ),
                ),
              ),
              onTap: () async {
                await Future.delayed(const Duration(seconds: 3));
              },
              label: "Test",
              loadingIndicatorWidget: const SizedBox(
                height: 15,
                width: 15,
                child: FittedBox(
                  child: CircularProgressIndicator(
                    strokeWidth: 5,
                    color: Colors.white,
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.amber, borderRadius: BorderRadius.circular(20)),
            ),
            10.hSpace,
            ButtonWithLoader.builder(
              // autoToIdeal: false,
              onTap: () async {
                await Future.delayed(const Duration(seconds: 3));
              },
              builder: (context, buttonState) {
                return Container(
                  height: 40,
                  width: 120,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.purple),
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: buttonState == ButtonState.loading
                        ? const FittedBox(
                            child: CircularProgressIndicator(
                            strokeWidth: 6,
                            color: Colors.purple,
                          ))
                        : Text(
                            buttonState == ButtonState.error
                                ? "Try again"
                                : buttonState == ButtonState.done
                                    ? "Submited"
                                    : "Submit",
                            style: TextStyle(color: Colors.purple),
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
