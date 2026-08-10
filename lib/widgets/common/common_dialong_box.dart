
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_theme_colors.dart';

void showCommonDialog({required BuildContext context, required Widget child, isOpenSimpleDialog = false,}) {
  showDialog(
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black45,
    builder: (BuildContext context) {
      final screenSize = MediaQuery.of(context).size;
      return isOpenSimpleDialog ?
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        backgroundColor: AppThemeColors.popupBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Container(
            constraints: BoxConstraints(
              maxHeight: screenSize.height * 0.9,
              minWidth: screenSize.width * 0.88,
              maxWidth: screenSize.width * 0.88,
            ),
            child: Flexible(
              child: child,
            )
        ),
      ) : DraggableDialog(
          child: child);
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
    final dialogWidth =  kIsWeb ? screenSize.width * 0.3 : screenSize.width * 0.88;
    final maxDialogHeight = screenSize.height * 0.9;

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
          top: screenSize.height * 0.05 + position.dy, // Start from top instead of center
          child: GestureDetector(
            onPanUpdate: (details) {
              setState(() {
                final newX = position.dx + details.delta.dx;
                final newY = position.dy + details.delta.dy;

                // Get actual dialog size after build
                final RenderBox? renderBox = _dialogKey.currentContext?.findRenderObject() as RenderBox?;
                final actualDialogHeight = renderBox?.size.height ?? maxDialogHeight;

                // Boundary constraints - allow full screen movement
                final minX = -((screenSize.width - dialogWidth) / 2);
                final maxX = (screenSize.width - dialogWidth) / 2;
                final minY = -(screenSize.height * 0.1); // Can go to very top
                final maxY = screenSize.height - actualDialogHeight - 50; // Leave some margin at bottom

                position = Offset(
                  newX.clamp(minX, maxX),
                  newY.clamp(minY, maxY),
                );
              });
            },
            child: Material(
              key: _dialogKey, // Add key to get actual size
              elevation: 24,
              color: AppThemeColors.popupBackgroundColor,
              borderRadius: BorderRadius.circular(8.0),
              child: Container(
                width: dialogWidth,
                constraints: BoxConstraints(
                  maxHeight: maxDialogHeight,
                ),
                decoration: BoxDecoration(
                  color: AppThemeColors.popupBackgroundColor,
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: AppThemeColors.borderColor),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drag handle
                    Container(
                      width: double.infinity,
                      height: 10,
                      decoration: BoxDecoration(
                        // color: Colors.grey[100],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5.0),
                          topRight: Radius.circular(5.0),
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ),
                    // Content
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.all(5),
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