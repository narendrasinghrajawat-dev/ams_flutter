import 'package:flutter/material.dart';

import '../../core/constants/app_theme_colors.dart';

class CustomRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  const CustomRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _CustomRefreshIndicatorState createState() => _CustomRefreshIndicatorState();
}

class _CustomRefreshIndicatorState extends State<CustomRefreshIndicator> {
  double _dragOffset = 0.0;
  bool _isRefreshing = false;
  bool _shouldRefresh = false;

  @override
  Widget build(BuildContext context) {

    print('called refresh screnen');

    return NotificationListener<ScrollNotification>(
      onNotification: (notification) {
        if (notification is ScrollUpdateNotification) {
          if (notification.metrics.extentBefore == 0 && notification.scrollDelta! < 0) {
            setState(() {
              _dragOffset -= notification.scrollDelta!;
              if (_dragOffset > 80) {
                _shouldRefresh = true;
              } else {
                _shouldRefresh = false;
              }
            });
          }
        } else if (notification is ScrollEndNotification) {
          if (_shouldRefresh && !_isRefreshing) {
            _startRefresh();
          } else {
            setState(() {
              _dragOffset = 0.0;
              _shouldRefresh = false;
            });
          }
        }
        return false;
      },
      child: Stack(
        children: [
          widget.child,
          if (_dragOffset > 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: _buildRefreshHeader(),
            ),
        ],
      ),
    );
  }

  Widget _buildRefreshHeader() {
    return Container(
      height: _dragOffset,
      color: AppThemeColors.loaderColor,
      alignment: Alignment.center,
      child: _isRefreshing
          ? const SizedBox(
        width: 24,
        height: 24,
        child: CircularProgressIndicator(
          strokeWidth: 3.0,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      )
          : Text(
        _shouldRefresh ? "Release to refresh" : "Put down to refresh",
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Future<void> _startRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    await widget.onRefresh();

    setState(() {
      _isRefreshing = false;
      _dragOffset = 0.0;
      _shouldRefresh = false;
    });
  }
}