import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MessageItem {
  final String id;
  final String verse;
  final String reference;
  final DateTime? date;

  MessageItem({
    required this.id,
    required this.verse,
    required this.reference,
    this.date,
  });
}

class PreviousMessages extends StatefulWidget {
  final List<MessageItem> messages;
  final ValueChanged<MessageItem> onSelect;

  const PreviousMessages({
    super.key,
    required this.messages,
    required this.onSelect,
  });

  @override
  State<PreviousMessages> createState() => _PreviousMessagesState();
}

class _PreviousMessagesState extends State<PreviousMessages>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
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
    return Padding(
      padding: const EdgeInsets.only(top: 48, bottom: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: Color(0xFFD97706), // amber-600
                ),
                const SizedBox(width: 12),
                Text(
                  'Mensagens Anteriores',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: const Color(0xFF1E293B), // slate-800
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          // Lista de mensagens
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: widget.messages.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              return _buildMessageItem(context, widget.messages[index], index);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMessageItem(
    BuildContext context,
    MessageItem message,
    int index,
  ) {
    final slideAnimation =
        Tween<Offset>(begin: const Offset(-0.2, 0), end: Offset.zero)
            .animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(index * 0.1, (index + 1) * 0.1 + 0.3),
      ),
    );

    final fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Interval(index * 0.1, (index + 1) * 0.1 + 0.3),
      ),
    );

    final dateStr = message.date != null
        ? DateFormat('dd \'de\' MMMM', 'pt_BR').format(message.date!)
        : '';

    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => widget.onSelect(message),
            borderRadius: BorderRadius.circular(16),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.8),
                border: Border.all(
                  color: const Color(0xFFFCD34D).withOpacity(0.5),
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFCD34D).withOpacity(0),
                    blurRadius: 0,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (dateStr.isNotEmpty)
                          Text(
                            dateStr,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFFD97706), // amber-600
                            ),
                          ),
                        if (dateStr.isNotEmpty)
                          const SizedBox(height: 4),
                        Text(
                          message.verse.length > 60
                              ? '${message.verse.substring(0, 60)}...'
                              : message.verse,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF475569), // slate-700
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          message.reference,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Color(0xFF94A3B8), // slate-500
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: const Color(0xFFCBD5E1), // slate-300
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
