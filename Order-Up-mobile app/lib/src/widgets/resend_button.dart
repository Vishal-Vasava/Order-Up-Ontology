import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class ResendButton extends StatefulWidget {
  const ResendButton({
    super.key,
    required this.onPressed,
  });
  final VoidCallback onPressed;
  @override
  _ResendButtonState createState() => _ResendButtonState();
}

class _ResendButtonState extends State<ResendButton>
    with TickerProviderStateMixin {
  late AnimationController controller;
  Duration get duration => controller.duration! * controller.value;
  bool get expired => duration.inSeconds == 0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );

    super.initState();
    controller.reverse(from: 1);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (BuildContext context, Widget? child) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (!expired)
              AnimatedOpacity(
                opacity: expired ? 0.0 : 1.0,
                duration: defaultDuration,
                child: CircleAvatar(
                  radius: 13.0,
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.7),
                  child: Text(
                    '${duration.inSeconds}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: AppColor.whiteColor,
                        ),
                  ),
                ),
              ),
            TextButton(
              onPressed: controller.isAnimating
                  ? null
                  : () {
                      controller.reverse(from: 1);
                      widget.onPressed.call();
                    },
              child: Text(
                'Resend'.hardcoded,
              ),
            ),
          ],
        );
      },
    );
  }
}
