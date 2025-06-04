import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_state.dart';

class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsCubit, TicketsState>(
      builder: (context, state) {
        if (state is TicketsLoaded) {
          return Card(
            elevation: 2,
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.l10n.ticketsPage_currentBalanceTitle,
                        style: context.theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.account_balance_wallet, color: context.theme.colorScheme.primary),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${state.userBalance.currentBalance.toStringAsFixed(2)} €',
                    style: context.theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.theme.colorScheme.primary,
                    ),
                  ),
                  SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () => _showTopUpDialog(context),
                      icon: Icon(Icons.payment),
                      label: Text(context.l10n.topUpBalance),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );
  }

  void _showTopUpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.topUpBalance),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(context.l10n.balanceCard_selectAmountMessage),
            SizedBox(height: 16),
            Wrap(
              spacing: 8,
              children: [10, 20, 50, 100].map((amount) {
                return ElevatedButton(
                  onPressed: () {
                    context.read<TicketsCubit>().addBalance(amount.toDouble());
                    context.pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(context.l10n.balanceCard_balanceAddedMessage(amount)),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                  child: Text('$amount €'),
                );
              }).toList(),
            ),
          ],
        ),
        actions: [TextButton(onPressed: () => context.pop(), child: Text(context.l10n.cancelButton))],
      ),
    );
  }
}
