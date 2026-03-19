import 'package:flutter/material.dart';
import '../favourites/favourite_service.dart';

class HeartButton extends StatefulWidget {
  final String trainerId;
  final double size;
  final Color activeColor;

  const HeartButton({
    super.key,
    required this.trainerId,
    this.size = 22,
    this.activeColor = Colors.red,
  });

  @override
  State<HeartButton> createState() => _HeartButtonState();
}

class _HeartButtonState extends State<HeartButton>
    with SingleTickerProviderStateMixin {
  bool _isFavourite = false;
  bool _isLoading = true;
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      lowerBound: 0.8,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _checkFavourite();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _checkFavourite() async {
    final isFav = await FavouriteService.isFavourite(widget.trainerId);
    if (mounted) setState(() { _isFavourite = isFav; _isLoading = false; });
  }

  Future<void> _toggle() async {
    // Animate
    _ctrl.reverse().then((_) => _ctrl.forward());

    setState(() => _isFavourite = !_isFavourite);

    final result = await FavouriteService.toggleFavourite(widget.trainerId);
    if (mounted) setState(() => _isFavourite = result);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return SizedBox(
        width: widget.size,
        height: widget.size,
        child: const CircularProgressIndicator(
          strokeWidth: 1.5,
          color: Colors.grey,
        ),
      );
    }

    return GestureDetector(
      onTap: _toggle,
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Icon(
          _isFavourite ? Icons.favorite : Icons.favorite_border,
          color: _isFavourite ? widget.activeColor : Colors.grey.shade400,
          size: widget.size,
        ),
      ),
    );
  }
}