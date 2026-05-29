import 'package:flutter/material.dart';

class CustomAnimatedDialog extends StatefulWidget {
  const CustomAnimatedDialog({super.key, required this.child});

  final Widget child;

  @override
  State<StatefulWidget> createState() => CustomAnimatedDialogState();
}

class CustomAnimatedDialogState extends State<CustomAnimatedDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 450));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(builder: (context, constraints) {
        return AnimatedPadding(
          duration: const Duration(milliseconds: 300),
          curve: Curves.decelerate,
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            child: Material(
              color: Colors.transparent,
              child: ScaleTransition(
                scale: scaleAnimation,
                child: GestureDetector(
                  onTap: () => FocusScope.of(context).unfocus(),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 30.0),
                      child: widget.child,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
