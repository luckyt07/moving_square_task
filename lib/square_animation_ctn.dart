import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MoveDirection { left, right }

class SquareAnimationCtn extends GetxController
    with GetSingleTickerProviderStateMixin {
  static const double squareSize = 50.0;
  late AnimationController _controller;
  late Animation<double> _animation;

  Animation<double> get anim => _animation;
  AnimationController get controller => _controller;

  RxDouble offsetX = 0.0.obs; // Track X-axis movement
  double step = squareSize; // Move by 50 pixels per click

  RxBool leftButtonEnabled = RxBool(true);
  RxBool rightButtonEnabled = RxBool(true);

  bool putIntialOffset = false;

  double get leftThreshold => -(Get.width / 2) + squareSize / 2;

  double get righThreshold => (Get.width / 2) - squareSize / 2;

  final GlobalKey globalKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1), // Movement duration
    );

    _animation = Tween<double>(begin: 0, end: 0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        offsetX.value = _animation.value;
        print("OffsetX :::-> ${offsetX.value}");
      });

    _controller.addStatusListener((status) {
      if (status.isAnimating) {
        leftButtonEnabled(false);
        rightButtonEnabled(false);
      }

      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        _updateButtonState();
      }
    });
  }

  Offset _getCurrentOffset() {
    final RenderBox renderBox =
        globalKey.currentContext!.findRenderObject() as RenderBox;
    return renderBox.localToGlobal(Offset.zero);
  }

  void move(
    MoveDirection direction,
  ) {
    // if (!putIntialOffset) {
    //   offsetX.value = _getCurrentOffset().dx;
    //   putIntialOffset = true;
    // }
    double screenWidth = Get.width; // Get screen width dynamically
    double targetOffset = offsetX.value;

    if (direction == MoveDirection.left) {
      targetOffset = (offsetX.value - step).clamp(leftThreshold, righThreshold);
    } else if (direction == MoveDirection.right) {
      targetOffset = (offsetX.value + step).clamp(leftThreshold, righThreshold);
    }

    _animation = Tween<double>(begin: offsetX.value, end: targetOffset).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    )..addListener(() {
        offsetX.value = _animation.value;
      });

    _controller.forward(from: 0);
  }

  void _updateButtonState() {
    leftButtonEnabled(offsetX.value > leftThreshold);
    rightButtonEnabled(offsetX.value < righThreshold);
  }

  @override
  void onClose() {
    _controller.dispose();
    super.onClose();
  }
}
