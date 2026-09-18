import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_theme_colors.dart';

void showCommonDialog({
  required BuildContext context,
  required Widget child,
  bool isOpenSimpleDialog = false,
}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black54,
    builder: (BuildContext context) {
      final screenSize = MediaQuery.of(context).size;
      return isOpenSimpleDialog
          ? Dialog(
              insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              backgroundColor: AppThemeColors.popupBackgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Container(
                constraints: BoxConstraints(
                  maxHeight: screenSize.height * 0.9,
                  minWidth: screenSize.width * 0.88,
                  maxWidth: screenSize.width * 0.88,
                ),
                child: child,
              ),
            )
          : DraggableDialog(child: child);
    },
  );
}

class DraggableDialog extends StatefulWidget {
  final Widget child;

  const DraggableDialog({Key? key, required this.child}) : super(key: key);

  @override
  _DraggableDialogState createState() => _DraggableDialogState();
}

class _DraggableDialogState extends State<DraggableDialog> {
  Offset position = Offset.zero;
  final GlobalKey _dialogKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final dialogWidth = kIsWeb ? screenSize.width * 0.35 : screenSize.width * 0.90;
    final maxDialogHeight = screenSize.height * 0.9;
    final isDark = AppThemeColors.isDark;

    return Stack(
      children: [
        // Barrier for dismissing dialog
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.transparent,
          ),
        ),
        // Draggable dialog
        Positioned(
          left: (screenSize.width - dialogWidth) / 2 + position.dx,
          top: screenSize.height * 0.05 + position.dy,
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                final newX = position.dx + details.delta.dx;
                final newY = position.dy + details.delta.dy;

                final RenderBox? renderBox =
                    _dialogKey.currentContext?.findRenderObject() as RenderBox?;
                final actualDialogHeight =
                    renderBox?.size.height ?? maxDialogHeight;

                final minX = -((screenSize.width - dialogWidth) / 2);
                final maxX = (screenSize.width - dialogWidth) / 2;
                final minY = -(screenSize.height * 0.05);
                final maxY = screenSize.height - actualDialogHeight - 40;

                position = Offset(
                  newX.clamp(minX, maxX),
                  newY.clamp(minY, maxY),
                );
              });
            },
            child: Material(
              key: _dialogKey,
              elevation: 16,
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16.0),
              child: Container(
                width: dialogWidth,
                constraints: BoxConstraints(
                  maxHeight: maxDialogHeight,
                ),
                decoration: BoxDecoration(
                  color: AppThemeColors.popupBackgroundColor,
                  borderRadius: BorderRadius.circular(16.0),
                  border: Border.all(color: AppThemeColors.borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? const Color(0x66000000)
                          : const Color(0x1F000000),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Center(
                        child: Container(
                          width: 36,
                          height: 4,
                          decoration: BoxDecoration(
                            color: AppThemeColors.dividerColor,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                        child: SingleChildScrollView(
                          child: widget.child,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}