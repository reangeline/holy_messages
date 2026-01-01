import 'package:flutter/material.dart';

typedef NavItemBuilder = Widget Function(IconData icon, String label, bool isActive);

class BottomNavItem {
  final IconData icon;
  final String label;
  final String id;

  BottomNavItem({
    required this.icon,
    required this.label,
    required this.id,
  });
}

class BottomNav extends StatefulWidget {
  final List<BottomNavItem> items;
  final String currentPage;
  final ValueChanged<String> onItemSelected;

  const BottomNav({
    super.key,
    required this.items,
    required this.currentPage,
    required this.onItemSelected,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 768;

    if (!isMobile) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: Colors.white.withOpacity(0.5),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withOpacity(0.1),
              blurRadius: 24,
              spreadRadius: 0,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: widget.items.map((item) {
                final isActive = widget.currentPage == item.id;
                return _buildNavItem(item, isActive);
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BottomNavItem item, bool isActive) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => widget.onItemSelected(item.id),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            decoration: isActive
                ? BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFEF3C7), // amber-100
                        Color(0xFFFED7AA), // orange-100
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  )
                : null,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  item.icon,
                  size: 24,
                  color: isActive
                      ? const Color(0xFFB45309) // amber-700
                      : const Color(0xFF94A3B8), // slate-400
                ),
                const SizedBox(height: 4),
                Text(
                  item.label,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isActive
                        ? const Color(0xFFB45309) // amber-700
                        : const Color(0xFF94A3B8), // slate-400
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
