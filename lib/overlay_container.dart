import 'package:flutter/material.dart';

class OverlayContainer extends StatefulWidget {
  final Widget child;
  final OverlayContainerPosition position;
  final bool show;
  final bool asWideAsParent;

  OverlayContainer({
    Key key,
    @required this.show,
    @required this.child,
    this.asWideAsParent = false,
    this.position = const OverlayContainerPosition(0.0, 0.0),
  }) : super(key: key);

  @override
  _OverlayContainerState createState() => _OverlayContainerState();
}

class _OverlayContainerState extends State<OverlayContainer> {
  OverlayEntry _overlayEntry;
  bool _opened = false;

  @override
  void initState() {
    super.initState();
    if (widget.show) {
      _show();
    }
  }

  @override
  void didUpdateWidget(OverlayContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show) {
      _show();
      return;
    }
    _hide();
  }

  void _show() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 280));
      if (_opened) {
        _overlayEntry.remove();
      }
      _overlayEntry = _buildOverlayEntry();
      Overlay.of(context).insert(_overlayEntry);
      _opened = true;
    });
  }

  void _hide() {
    if (_opened) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _overlayEntry.remove();
        _opened = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  OverlayEntry _buildOverlayEntry() {
    RenderBox renderBox = context.findRenderObject();
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(builder: (context) {
      return Positioned(
        left: offset.dx + widget.position.left,
        top: offset.dy - widget.position.bottom,
        width: widget.asWideAsParent ? size.width : null,
        child: widget.child,
      );
    });
  }
}

class OverlayContainerPosition {
  final double left;
  final double bottom;

  const OverlayContainerPosition(this.left, this.bottom);
}
