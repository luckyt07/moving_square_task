import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moving_square_task/square_animation_ctn.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const GetMaterialApp(
      home: Padding(
        padding: EdgeInsets.all(0.0),
        child: SquareAnimation(),
      ),
    );
  }
}

class SquareAnimation extends StatefulWidget {
  const SquareAnimation({super.key});

  @override
  State<SquareAnimation> createState() {
    return SquareAnimationState();
  }
}

class SquareAnimationState extends State<SquareAnimation>
    with SingleTickerProviderStateMixin {
  final _controller = Get.put(SquareAnimationCtn());

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller.controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(_controller.anim.value, 0),
              child: child,
            );
          },
          child: Container(
            width: SquareAnimationCtn.squareSize,
            height: SquareAnimationCtn.squareSize,
            decoration: BoxDecoration(
              color: Colors.red,
              border: Border.all(),
            ),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Obx(() {
              return ElevatedButton(
                onPressed: !_controller.leftButtonEnabled.value
                    ? null
                    : () => _controller.move(MoveDirection.left),
                child: const Text('to left'),
              );
            }),
            const SizedBox(width: 8),
            Obx(() {
              return ElevatedButton(
                onPressed: !_controller.rightButtonEnabled.value
                    ? null
                    : () => _controller.move(MoveDirection.right),
                child: const Text('to right'),
              );
            }),
          ],
        ),
      ],
    );
  }
}
