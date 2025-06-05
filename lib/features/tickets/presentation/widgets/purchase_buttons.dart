import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/utils/request_state.dart';
import 'package:linos/core/utils/request_state_extensions.dart';
import 'package:linos/features/tickets/data/enums/ticket_type.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_state.dart';

class PurchaseButtons extends StatelessWidget {
  const PurchaseButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<TicketsCubit, TicketsState>(
      listener: (context, state) {
        if (state is TicketsLoaded) {
          final purchaseStatus = state.purchaseStatus;
          if (purchaseStatus is RequestSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(context.l10n.purchaseButtons_purchaseSuccessMessage),
                backgroundColor: Colors.green,
              ),
            );
            context.read<TicketsCubit>().clearPurchaseStatus();
            return;
          }
          if (purchaseStatus is RequestError) {
            state.purchaseStatus.showErrorSnackBar(context);
            context.read<TicketsCubit>().clearPurchaseStatus();
          }
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            context.l10n.ticketsPage_purchaseTicketsTitle,
            style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 12),
          BlocBuilder<TicketsCubit, TicketsState>(
            builder: (context, state) {
              final isLoading = state is TicketsLoaded && state.purchaseStatus is RequestLoading;

              return Column(
                children: TicketType.values.map((ticketType) {
                  return _buildPurchaseButton(isLoading, context, ticketType);
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }

  Container _buildPurchaseButton(bool isLoading, BuildContext context, TicketType ticketType) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: ElevatedButton(
          onPressed: isLoading ? null : () => _purchaseTicket(context, ticketType),
          style: ElevatedButton.styleFrom(
            backgroundColor: context.theme.colorScheme.primaryContainer,
            foregroundColor: context.theme.colorScheme.onPrimaryContainer,
          ),
          child: isLoading
              ? CircularProgressIndicator()
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          ticketType.typeName.displayName(context),
                          style: context.theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _getValidityText(ticketType, context),
                          style: context.theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                    Text(
                      '${ticketType.price.toStringAsFixed(2)} €',
                      style: context.theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: context.theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _purchaseTicket(BuildContext context, TicketType ticketType) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(context.l10n.purchaseButtons_confirmPurchaseTitle),
        content: Text(
          context.l10n.purchaseButtons_confirmPurchaseMessage(
            ticketType.price.toStringAsFixed(2),
            ticketType.typeName.displayName(context),
          ),
        ),
        actions: [
          TextButton(onPressed: () => context.pop(), child: Text(context.l10n.cancelButton)),
          ElevatedButton(
            onPressed: () {
              context.pop();
              context.read<TicketsCubit>().purchaseTicket(ticketType);
            },
            child: Text(
              context.l10n.confirmButton,
              style: context.theme.textTheme.labelLarge?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  String _getValidityText(TicketType ticketType, BuildContext context) {
    final validity = ticketType.validity;
    if (validity.inDays > 0) {
      return validity.inDays > 1
          ? context.l10n.purchaseButtons_validForDaysPlural(validity.inDays)
          : context.l10n.purchaseButtons_validForDays(validity.inDays);
    }
    if (validity.inHours > 0) {
      return validity.inHours > 1
          ? context.l10n.purchaseButtons_validForHoursPlural(validity.inHours)
          : context.l10n.purchaseButtons_validForHours(validity.inHours);
    }
    return context.l10n.purchaseButtons_validForMinutes(validity.inMinutes);
  }
}
