import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/tickets/presentation/widgets/active_tickets.dart';
import 'package:linos/features/tickets/presentation/widgets/balance_card.dart';
import 'package:linos/features/tickets/presentation/widgets/purchase_buttons.dart';
import 'package:linos/features/tickets/presentation/widgets/ticket_history_section.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.ticketsPage_activeTicketsTitle,
                style: context.theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              ActiveTickets(),
              SizedBox(height: 16.0),
              BalanceCard(),
              SizedBox(height: 16.0),
              PurchaseButtons(),
              SizedBox(height: 16.0),
              TicketHistorySection(),
            ],
          ),
        ),
      ),
    );
  }
}
