import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class CustomAnimation extends EasyLoadingAnimation {
  CustomAnimation();

  @override
  Widget buildWidget(
    Widget child,
    AnimationController controller,
    AlignmentGeometry alignment,
  ) {
    return Opacity(
      opacity: controller.value,
      child: RotationTransition(
        turns: controller,
        child: child,
      ),
    );
  }
}

class CustomLoader {
  static Future<void> show() {
    return EasyLoading.show(
        status: 'Lütfen Bekleyiniz...',
        maskType: EasyLoadingMaskType.black,
        dismissOnTap: false);
  }

  static void close() {
    if (EasyLoading.isShow) {
      EasyLoading.dismiss();
    }
  }
}
