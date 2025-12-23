

import 'package:flutter/material.dart';

import '../../../../../../widgets/card/common_card.dart';
import '../../../../../../widgets/text_and_icon_widgets/app_text_type.dart';

class ForgotPasswordButton extends StatelessWidget {
  final VoidCallback onTap;

  const ForgotPasswordButton({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CommonCardWidget(
      padding: 0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.password,
                  color: Colors.orange.shade600,
                  size: 22,
                ),
                const SizedBox(width: 10),
                AppTextWidget.large(
                  'Forgot Password',
                  color: Colors.orange.shade600,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
