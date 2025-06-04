import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/navigation/app_router_config.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/utils/error_message_helper.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_state.dart';
import 'package:linos/features/tickets/presentation/widgets/history_ticket_card.dart';

class TicketHistorySection extends StatelessWidget {
  const TicketHistorySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              context.l10n.ticketsPage_purchasedTicketsTitle,
              style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () => context.read<TicketsCubit>().refreshTickets(),
              child: Text(context.l10n.ticketsPage_refresh),
            ),
          ],
        ),
        SizedBox(height: 8),
        BlocBuilder<TicketsCubit, TicketsState>(
          builder: (context, state) {
            if (state is TicketsLoaded) {
              final sortedPurchasedTickets = state.allTickets..sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));

              if (sortedPurchasedTickets.isEmpty) {
                return _buildEmptyState(context);
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

            if (state is TicketsError) {
              return _buildErrorState(context, state.message);
            }

            return _buildLoadingState();
          },
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context) {
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

  Widget _buildErrorState(BuildContext context, String message) {
    return Container(
      padding: EdgeInsets.all(32),
      child: Center(
        child: Column(
          children: [
            Icon(Icons.error_outline, size: 48, color: Colors.red),
            SizedBox(height: 8),
            Text(
              context.l10n.ticketHistory_errorLoadingHistory,
              style: context.theme.textTheme.titleMedium?.copyWith(color: Colors.red),
            ),
            Text(
              ErrorMessageHelper.getLocalizedErrorMessage(context, message),
              style: context.theme.textTheme.bodyMedium?.copyWith(color: Colors.red, fontSize: 12),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => context.read<TicketsCubit>().loadUserData(),
              child: Text(context.l10n.button_retry),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Container(
      padding: EdgeInsets.all(32),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
