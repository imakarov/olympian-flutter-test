import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class HandTapOverlay extends StatefulWidget {
  const HandTapOverlay({
    super.key,
    required this.child,
    required this.onTap,
    this.showHandTap = false,
  });

  final bool showHandTap;
  final Widget child;
  final Future<void> Function() onTap;

  @override
  State<HandTapOverlay> createState() => _HandTapOverlayState();
}

class _HandTapOverlayState extends State<HandTapOverlay> {
  OverlayEntry? _overlayEntry;
  late final LayerLink _layerLink;
  late final LottieBuilder _lottieAnimation;

  @override
  void initState() {
    if (widget.showHandTap) {
      _layerLink = LayerLink();
      _lottieAnimation = Lottie.network(
        'https://raw.githubusercontent.com/imakarov/olympian-flutter-test/master/Animation.json',
        repeat: true,
      );
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        _createOverlay();
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.showHandTap) {
      return widget.child;
    }
    return CompositedTransformTarget(
      link: _layerLink,
      child: widget.child,
    );
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    return OverlayEntry(builder: (context) {
      return Positioned(
        height: size.height * 2,
        child: CompositedTransformFollower(
          link: _layerLink,
          offset: Offset(size.width / 3, 0),
          child: GestureDetector(
            onTap: () async {
              _removeOverlay();
              await widget.onTap();
              _createOverlay();
            },
            child: _lottieAnimation,
          ),
        ),
      );
    });
  }

  void _createOverlay() {
    final overlay = Overlay.of(context);
    _overlayEntry = _createOverlayEntry();
    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    print('qwe');
    if (_overlayEntry == null) {
      return;
    }
    _overlayEntry!.remove();
    _overlayEntry = null;
  }
}
