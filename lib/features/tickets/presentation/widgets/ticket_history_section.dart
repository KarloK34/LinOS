import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/app_router_config.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/widgets/error_state.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_state.dart';
import 'package:linos/features/tickets/presentation/widgets/purchased_ticket_card.dart';

class TicketHistorySection extends StatelessWidget {
  const TicketHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          context.l10n.ticketsPage_purchasedTicketsTitle,
          style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8),
        _PurchasedTicketsList(),
      ],
    );
  }
}

class _PurchasedTicketsList extends StatelessWidget {
  const _PurchasedTicketsList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsCubit, TicketsState>(
      builder: (context, state) {
        if (state is TicketsError) {
          return ErrorState(
            title: context.l10n.ticketHistory_errorLoadingHistory,
            message: AppErrorHandler.getLocalizedMessage(context, state.errorKey),
          );
        }

        if (state is TicketsLoaded) {
          final sortedPurchasedTickets = state.allTickets..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

          if (sortedPurchasedTickets.isEmpty) {
            return _EmptyState();
          }

          final recentTickets = sortedPurchasedTickets.take(5).toList();
          final hasMoreTickets = sortedPurchasedTickets.length > 5;
          return Column(
            children: [
              ...recentTickets.map((ticket) => PurchasedTicketCard(ticket: ticket)),
              if (hasMoreTickets) ...[
                SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () => context.go(AppRouterConfig.ticketsHistory, extra: sortedPurchasedTickets),
                    icon: Icon(Icons.history),
                    label: Text(context.l10n.ticketsPage_viewTicketHistoryLabel(sortedPurchasedTickets.length - 5)),
                    style: OutlinedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 12)),
                  ),
                ),
              ],
            ],
          );
        }

        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.history, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              context.l10n.ticketHistory_noTicketHistory,
              style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              context.l10n.ticketsPage_purchasedTicketsSubtitle,
              style: context.theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
