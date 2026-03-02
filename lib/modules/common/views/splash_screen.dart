import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_theme_colors.dart';
import '../../../../routes/app_routes.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../../data/utils/auth_helper.dart';
import '../../../widgets/text_and_icon_widgets/app_text_type.dart';

class SplashScreen extends StatefulWidget {
  final Duration duration;
  final String nextRoute;

  const SplashScreen({
    Key? key,
    this.duration = const Duration(milliseconds: 2800),
    this.nextRoute = AppRoutes.login,
  }) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;
  late final Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _scaleAnim = Tween<double>(begin: 0.9, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut),
    );
    _progressAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeIn);

    _ctrl.forward();

    print('splash screeen inti called');

    _ctrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(milliseconds: 200), () {
          if (!mounted) return;
          // central helper decides routing (login/admin/user)
          AuthHelper.checkAndRedirect();
        });
      }
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: AppThemeColors.splashGradientColors,
    );

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: gradient),
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _ctrl,
            builder: (context, child) {
              final progress = _progressAnim.value;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo + app name
                  ScaleTransition(
                    scale: _scaleAnim,
                    child: Column(
                      children: [
                        // circular icon background using centralized color
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            color: AppThemeColors.splashIconBg,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 10,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              AppConstIcons.appStaticIcon,
                              size: 56,
                              color: AppThemeColors.splashTextColor,
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // App name
                        AppTextWidget.large('AMS', color: AppThemeColors.splashTextColor),

                        const SizedBox(height: 10),

                        // subtle progress line under name (thin)
                        _buildThinProgress(progress),
                      ],
                    ),
                  ),

                  const Spacer(flex: 3),

                  // subtitle + progress
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 28.0),
                    child: Column(
                      children: [
                        AppTextWidget.small(
                          'Attendance Management System',
                          align: TextAlign.center,
                          color: AppThemeColors.splashTextColor.withOpacity(0.9),
                        ),
                        const SizedBox(height: 18),

                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: LinearProgressIndicator(
                            value: progress,
                            backgroundColor: AppThemeColors.splashTextColor.withOpacity(0.18),
                            valueColor: AlwaysStoppedAnimation<Color>(AppThemeColors.splashProgressColor),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(height: 26),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildThinProgress(double t) {
    final maxWidth = 140.0;
    return Container(
      width: maxWidth,
      height: 6,
      decoration: BoxDecoration(
        color: AppThemeColors.splashTextColor.withOpacity(0.18),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: t.clamp(0.0, 1.0),
          child: Container(
            height: 6,
            decoration: BoxDecoration(
              color: AppThemeColors.splashProgressColor,
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ),
      ),
    );
  }
}
