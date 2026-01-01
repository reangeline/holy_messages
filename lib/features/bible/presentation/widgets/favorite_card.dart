import 'package:flutter/material.dart';

class FavoriteCard extends StatefulWidget {
  final String verse;
  final String reference;
  final String id;
  final int index;
  final VoidCallback onRemove;

  const FavoriteCard({
    super.key,
    required this.verse,
    required this.reference,
    required this.id,
    required this.index,
    required this.onRemove,
  });

  @override
  State<FavoriteCard> createState() => _FavoriteCardState();
}

class _FavoriteCardState extends State<FavoriteCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    Future.delayed(Duration(milliseconds: widget.index * 50), () {
      if (mounted) {
        _animationController.forward();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    return FadeTransition(
      opacity: fadeAnimation,
      child: ScaleTransition(
        scale: scaleAnimation,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white,
                const Color(0xFFFEF3C7).withOpacity(0.5),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFFCD34D),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFCD34D).withOpacity(0.15),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Stack(
            children: [
              // Coração no topo
              Positioned(
                top: 16,
                right: 16,
                child: Icon(
                  Icons.favorite,
                  size: 20,
                  color: const Color(0xFFF87171), // red-400
                ),
              ),
              // Conteúdo
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Verso
                  Text(
                    '"${widget.verse}"',
                    style: const TextStyle(
                      fontSize: 18,
                      fontFamily: 'Georgia',
                      color: Color(0xFF475569), // slate-700
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Referência e botão de remover
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.reference,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFFB45309), // amber-700
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: widget.onRemove,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: const Color(0xFF94A3B8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
