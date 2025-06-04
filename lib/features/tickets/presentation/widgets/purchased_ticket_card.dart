import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/tickets/data/models/ticket.dart';

class PurchasedTicketCard extends StatelessWidget {
  final Ticket ticket;

  const PurchasedTicketCard({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isExpired = ticket.isExpired;
    final isActive = ticket.isActive;

    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(Icons.confirmation_number_outlined, color: theme.colorScheme.primary),
        title: Text(
          ticket.type.typeName.displayName(context),
          style: context.theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              context.l10n.ticketHistoryPage_purchased + _formatDate(ticket.purchaseDate),
              style: context.theme.textTheme.bodySmall,
            ),
            Text(
              context.l10n.ticketHistoryPage_validUntil + _formatDate(ticket.validUntil),
              style: context.theme.textTheme.bodySmall?.copyWith(color: isExpired ? Colors.grey : null),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '${ticket.pricePaid.toStringAsFixed(2)} €',
              style: context.theme.textTheme.bodyMedium?.copyWith(color: isExpired ? Colors.grey : null),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isActive ? Colors.green : (isExpired ? Colors.grey : Colors.red),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                isActive
                    ? context.l10n.activeTicketCard_active
                    : (isExpired ? context.l10n.activeTicketCard_expired : context.l10n.ticketHistoryPage_used),
                style: context.theme.textTheme.labelSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
