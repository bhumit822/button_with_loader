import 'package:flutter/widgets.dart';

extension SizedBoxSpace on num {
  Widget get hSpace => SizedBox(
        height: toDouble(),
      );

  Widget get wSpace => SizedBox(
        width: toDouble(),
      );
}
