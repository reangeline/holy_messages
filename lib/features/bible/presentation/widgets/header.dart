import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/bible_providers.dart';

class Header extends ConsumerStatefulWidget {
  final String title;
  final String? subtitle;
  final bool translateTitle; // Se true, usa o título como está; se false, traduz

  const Header({
    super.key,
    required this.title,
    this.subtitle,
    this.translateTitle = true, // Por padrão, usa o título fornecido diretamente
  });

  @override
  ConsumerState<Header> createState() => _HeaderState();
}

class _HeaderState extends ConsumerState<Header> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = ref.watch(appStringsProvider);
    final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    final slideAnimation = Tween<Offset>(begin: const Offset(0, -0.2), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 40),
          child: Column(
            children: [
              // Badge com sparkles
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.star,
                    size: 20,
                    color: Color(0xFFD97706), // amber-500
                  ),
                  const SizedBox(width: 8),
                  Text(
                    strings.wordOfGod.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12, 
                      fontFamily: 'Allura',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFFB45309), // amber-600
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.star,
                    size: 20,
                    color: Color(0xFFD97706), // amber-500
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Título
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 36,
                  fontFamily: 'Georgia',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A), // slate-900
                ),
              ),
              // Subtítulo (se fornecido)
              if (widget.subtitle != null) ...[
                const SizedBox(height: 8),
                Text(
                  widget.subtitle!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF64748B), // slate-500
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
