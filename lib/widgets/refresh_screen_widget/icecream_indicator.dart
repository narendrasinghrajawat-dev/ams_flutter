import 'dart:async';
import 'package:flutter/material.dart';
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import '../../core/constants/app_images_path.dart';
import '../../core/constants/app_theme_colors.dart';

// 1. First, create the custom IceCreamIndicator widget
class RefreshIndicatorWidget extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final IndicatorController? controller;

  const RefreshIndicatorWidget({
    super.key,
    required this.child,
    required this.onRefresh,
    this.controller,
  });

  @override
  State<RefreshIndicatorWidget> createState() => _RefreshIndicatorWidgetState();
}

class _RefreshIndicatorWidgetState extends State<RefreshIndicatorWidget>
    with SingleTickerProviderStateMixin {
  static const _assets = <ParallaxConfig>[

    ParallaxConfig(
      image: AssetImage(AppImagesPath.appIcon),
      level: 5,
    ),
  ];

  static const _indicatorSize = 60.0;
  static const _imageSize = 140.0;

  late AnimationController _spoonController;
  static final _spoonTween = CurveTween(curve: Curves.easeInOut);

  @override
  void initState() {
    _spoonController =
        AnimationController(vsync: this, duration: const Duration(seconds: 1));
    WidgetsBinding.instance.addPostFrameCallback((_) => _precacheImages());
    super.initState();
  }

  void _precacheImages() {
    for (final config in _assets) {
      precacheImage(config.image, context);
    }
  }

  Widget _buildImage(IndicatorController controller, ParallaxConfig asset) {
    return Transform.translate(
      offset: Offset(
        0,
        -(asset.level * (controller.value.clamp(1.0, 1.5) - 1.0) * 20) + 10,
      ),
      child: OverflowBox(
        maxHeight: _imageSize,
        minHeight: _imageSize,
        child: Image(
          image: asset.image,
          fit: BoxFit.contain,
          height: _imageSize,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CustomRefreshIndicator(
      controller: widget.controller,
      offsetToArmed: _indicatorSize,
      onRefresh: widget.onRefresh,
      autoRebuild: false,
      child: widget.child,
      onStateChanged: (change) {
        if (change.didChange(to: IndicatorState.loading)) {
          _spoonController.repeat(reverse: true);
        } else if (change.didChange(from: IndicatorState.loading)) {
          _spoonController.stop();
        } else if (change.didChange(to: IndicatorState.idle)) {
          _spoonController.value = 0.0;
        }
      },
      builder: (
          BuildContext context,
          Widget child,
          IndicatorController controller,
          ) {
        return Stack(
          children: <Widget>[
            AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                return SizedBox(
                  height: controller.value * _indicatorSize,
                  child: Stack(
                    children: <Widget>[
                      Center(
                        child:  CircularProgressIndicator(color: AppThemeColors.loaderColor,),
                      )
                    ],
                  ),
                );
              },
            ),
            AnimatedBuilder(
              builder: (context, _) {
                return Transform.translate(
                  offset: Offset(0.0, controller.value * _indicatorSize),
                  child: child,
                );
              },
              animation: controller,
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _spoonController.dispose();
    super.dispose();
  }
}

class ParallaxConfig {
  final int level;
  final AssetImage image;

  const ParallaxConfig({
    required this.level,
    required this.image,
  });
}
