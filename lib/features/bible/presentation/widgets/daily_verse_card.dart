import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:holy_messages/core/utils/custom_snackbar.dart';

class DailyVerseCard extends StatefulWidget {
  final String verse;
  final String reference;
  final String? reflection;
  final bool isFavorited;
  final VoidCallback onFavorite;
  final VoidCallback onShare;
  final VoidCallback onTap;
  final VoidCallback? onRefresh;
  final bool isPremium;
  final bool isLoggedIn;

  const DailyVerseCard({
    super.key,
    required this.verse,
    required this.reference,
    this.reflection,
    required this.isFavorited,
    required this.onFavorite,
    required this.onShare,
    required this.onTap,
    this.onRefresh,
    required this.isPremium,
    this.isLoggedIn = false,
  });

  @override
  State<DailyVerseCard> createState() => _DailyVerseCardState();
}

class _DailyVerseCardState extends State<DailyVerseCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _slideAnimation;
  InterstitialAd? _interstitialAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _interstitialAd?.dispose();
    super.dispose();
  }

  void _loadInterstitialAd() {
    // Se for premium, não mostra ad
    if (widget.isPremium) {
      widget.onRefresh?.call();
      return;
    }
    
    // Mostrar dialog de carregamento
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                const Color(0xFFB45309).withOpacity(0.8),
              ),
            ),
          ),
        );
      },
    );
    
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712', // Test ad unit
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          // Fechar o spinner de carregamento
          if (mounted) {
            Navigator.pop(context);
          }
          _interstitialAd = ad;
          _isAdLoaded = true;
          _showInterstitialAd();
        },
        onAdFailedToLoad: (error) {
          // Fechar o spinner de carregamento
          if (mounted) {
            Navigator.pop(context);
          }
          _isAdLoaded = false;
          widget.onRefresh?.call();
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (_isAdLoaded && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          _interstitialAd?.dispose();
          _interstitialAd = null;
          widget.onRefresh?.call();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          _interstitialAd?.dispose();
          _interstitialAd = null;
          widget.onRefresh?.call();
        },
      );
      _interstitialAd!.show();
    } else {
      widget.onRefresh?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFFFEF3C7), // amber-50
                Colors.white,
                Color(0xFFFED7AA), // orange-50
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFCD34D).withOpacity(0.3),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.loose,
            children: [
              // Decorative elements
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 160,
                  height: 160,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        const Color(0xFFFCD34D).withOpacity(0.3),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 128,
                  height: 128,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [
                        const Color(0xFFFED7AA).withOpacity(0.2),
                        Colors.transparent,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(200),
                  ),
                ),
              ),
              // Cross symbol
              const Positioned(
                top: 24,
                right: 24,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(
                    Icons.add,
                    size: 60,
                    color: Color(0xFF78350F), // amber-900
                  ),
                ),
              ),
              // Main content
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Date badge
                      _buildAnimatedBadge(),
                      const SizedBox(height: 32),
                      // Verse
                      _buildAnimatedVerse(),
                      const SizedBox(height: 32),
                      // Reference
                      _buildAnimatedReference(),
                      // Reflection
                      if (widget.reflection != null)
                        _buildAnimatedReflection(),
                      const SizedBox(height: 32),
                      // Actions
                      _buildAnimatedActions(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildAnimatedBadge() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.3, 1),
        ),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFCD34D).withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.menu_book,
              size: 16,
              color: Color(0xFFB45309),
            ),
            const SizedBox(width: 8),
            const Text(
              'Mensagem do Dia',
              style: TextStyle(
                color: Color(0xFFB45309),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (widget.onRefresh != null) ...[
              const SizedBox(width: 12),
              GestureDetector(
                onTap: _loadInterstitialAd,
                child: const Icon(
                  Icons.refresh_rounded,
                  size: 18,
                  color: Color(0xFFB45309),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedVerse() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.4, 1),
        ),
      ),
      child: Text(
        '"${widget.verse}"',
        style: const TextStyle(
          fontSize: 32,
          fontFamily: 'Georgia',
          fontStyle: FontStyle.italic,
          color: Color(0xFF1E293B),
          height: 1.6,
          letterSpacing: 0.5,
          ),
          maxLines: 4,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        ),
    );
  }

  Widget _buildAnimatedReference() {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero)
          .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.6, 1),
        ),
      ),
      child: Text(
        '— ${widget.reference}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Color(0xFFB45309),
        ),
      ),
    );
  }

  Widget _buildAnimatedReflection() {
    return FadeTransition(
      opacity: Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.7, 1),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 1,
              color: const Color(0xFFFCD34D),
              margin: const EdgeInsets.only(bottom: 24),
            ),
            Text(
              widget.reflection!,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B5563),
                height: 1.6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedActions() {
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
          .animate(
        CurvedAnimation(
          parent: _animationController,
          curve: const Interval(0.8, 1),
        ),
      ),
      child: Row(
        children: [
          // Favorite button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.isLoggedIn ? widget.onFavorite : () {
                showTopSnackBar(
                  context,
                  message: 'Faça login para adicionar favoritos',
                  backgroundColor: const Color(0xFFFF9800),
                );
              },
              borderRadius: BorderRadius.circular(28),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: !widget.isLoggedIn
                      ? const Color(0xFFE2E8F0)
                      : widget.isFavorited
                          ? const Color(0xFFFEE2E2)
                          : const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Icon(
                  widget.isFavorited ? Icons.favorite : Icons.favorite_border,
                  size: 24,
                  color: !widget.isLoggedIn
                      ? const Color(0xFFCBD5E1)
                      : widget.isFavorited
                          ? const Color(0xFFEF4444)
                      : const Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Share button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: widget.onShare,
              borderRadius: BorderRadius.circular(28),
              child: Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: const Icon(
                  Icons.share,
                  size: 24,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
