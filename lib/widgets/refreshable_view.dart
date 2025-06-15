import 'package:flutter/material.dart';

class RefreshableView extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final ScrollController? scrollController;
  final bool showIndicator;

  const RefreshableView({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.scrollController,
    this.showIndicator = true,
  }) : super(key: key);

  @override
  _RefreshableViewState createState() => _RefreshableViewState();
}

class _RefreshableViewState extends State<RefreshableView> {
  bool _isRefreshing = false;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        if (_isRefreshing) return;

        setState(() {
          _isRefreshing = true;
        });

        try {
          await widget.onRefresh();
        } catch (e) {
          // Show error snackbar
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erreur lors de l\'actualisation. Veuillez réessayer.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } finally {
          if (mounted) {
            setState(() {
              _isRefreshing = false;
            });
          }
        }
      },
      displacement: 20,
      color: Theme.of(context).colorScheme.primary,
      backgroundColor: Theme.of(context).colorScheme.surface,
      strokeWidth: 3,
      // Fix: Use the proper TriggerMode from the Material library
      triggerMode: RefreshIndicatorTriggerMode.onEdge,
      child: widget.child,
    );
  }
}
