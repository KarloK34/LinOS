import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/utils/app_error_handler.dart';
import 'package:linos/core/widgets/app_bar_back_button.dart';
import 'package:linos/core/widgets/error_state.dart';
import 'package:linos/features/tickets/data/enums/filter_type.dart';
import 'package:linos/features/tickets/data/enums/sort_type.dart';
import 'package:linos/features/tickets/data/models/ticket.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_state.dart';

class TicketHistoryPage extends StatefulWidget {
  const TicketHistoryPage({super.key});

  @override
  State<TicketHistoryPage> createState() => _TicketHistoryPageState();
}

class _TicketHistoryPageState extends State<TicketHistoryPage> {
  FilterType _filterType = FilterType.all;
  SortType _sortBy = SortType.newest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.ticketHistoryPage_title),
        centerTitle: true,
        leading: AppBarBackButton(),
        actions: [
          PopupMenuButton<String>(
            icon: Icon(Icons.sort),
            onSelected: (value) => setState(
              () => _sortBy = SortType.values.firstWhere(
                (type) => type.camelCaseName(context) == value,
                orElse: () => SortType.newest,
              ),
            ),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: SortType.newest.camelCaseName(context),
                child: Text(context.l10n.ticketHistoryPage_sortNewest),
              ),
              PopupMenuItem(
                value: SortType.oldest.camelCaseName(context),
                child: Text(context.l10n.ticketHistoryPage_sortOldest),
              ),
              PopupMenuItem(
                value: SortType.priceHigh.camelCaseName(context),
                child: Text(context.l10n.ticketHistoryPage_sortPriceHigh),
              ),
              PopupMenuItem(
                value: SortType.priceLow.camelCaseName(context),
                child: Text(context.l10n.ticketHistoryPage_sortPriceLow),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<TicketsCubit, TicketsState>(
        builder: (context, state) {
          if (state is TicketsInitial || state is TicketsLoading) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator(), SizedBox(height: 16), Text(context.l10n.ticketHistory_loading)],
              ),
            );
          }

          if (state is TicketsError) {
            return ErrorState(
              title: context.l10n.ticketHistory_errorLoadingHistory,
              message: AppErrorHandler.getLocalizedMessage(context, state.errorKey),
            );
          }

          if (state is TicketsLoaded) {
            final tickets = state.allTickets;

            if (tickets.isEmpty) {
              return _buildEmptyState();
            }

            final filteredTickets = _getFilteredAndSortedTickets(tickets);

            return Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: Row(
                    children: [
                      Text(context.l10n.ticketHistoryPage_filterLabel, style: context.theme.textTheme.titleSmall),
                      SizedBox(width: 12.0),
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children:
                                [
                                      context.l10n.all,
                                      context.l10n.singleRide,
                                      context.l10n.dailyPass,
                                      context.l10n.weeklyPass,
                                      context.l10n.monthlyPass,
                                    ]
                                    .map(
                                      (filter) => Padding(
                                        padding: EdgeInsets.only(right: 8),
                                        child: FilterChip(
                                          label: Text(filter),
                                          selected: _filterType.camelCaseName(context) == filter,
                                          onSelected: (selected) {
                                            setState(
                                              () => _filterType = FilterType.values.firstWhere(
                                                (type) => type.camelCaseName(context) == filter,
                                                orElse: () => FilterType.all,
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                    .toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Text(
                        '${context.l10n.ticketHistoryPage_ticketsCount} ${filteredTickets.length}',
                        style: context.theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
                      ),
                      Spacer(),
                      Text(
                        context.l10n.ticketHistoryPage_totalSpent(
                          _calculateTotalSpent(filteredTickets).toStringAsFixed(2),
                        ),
                        style: context.theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: context.theme.colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 16),
                Expanded(
                  child: filteredTickets.isEmpty
                      ? _buildEmptyFilteredState()
                      : ListView.builder(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filteredTickets.length,
                          itemBuilder: (context, index) {
                            final ticket = filteredTickets[index];
                            return _HistoryTicketCard(ticket: ticket, showDetailedInfo: true);
                          },
                        ),
                ),
              ],
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            context.l10n.ticketHistory_noTicketHistory,
            style: context.theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
        ],
      ),
    );
  }

  List<Ticket> _getFilteredAndSortedTickets(List<Ticket> tickets) {
    List<Ticket> filtered = tickets;

    if (_filterType != FilterType.all) {
      filtered = filtered
          .where((ticket) => ticket.type.typeName.displayName(context) == _filterType.camelCaseName(context))
          .toList();
    }

    switch (_sortBy) {
      case SortType.newest:
        filtered.sort((a, b) => b.purchaseDate.compareTo(a.purchaseDate));
        break;
      case SortType.oldest:
        filtered.sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));
        break;
      case SortType.priceHigh:
        filtered.sort((a, b) => b.pricePaid.compareTo(a.pricePaid));
        break;
      case SortType.priceLow:
        filtered.sort((a, b) => a.pricePaid.compareTo(b.pricePaid));
        break;
    }

    return filtered;
  }

  double _calculateTotalSpent(List<Ticket> tickets) {
    return tickets.fold(0.0, (sum, ticket) => sum + ticket.pricePaid);
  }

  Widget _buildEmptyFilteredState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.filter_list_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            context.l10n.ticketHistoryPage_noTicketsFound,
            style: context.theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
          ),
          Text(
            context.l10n.ticketHistoryPage_adjustFilters,
            style: context.theme.textTheme.bodyMedium?.copyWith(color: Colors.grey),
          ),
          SizedBox(height: 16),
          TextButton(
            onPressed: () => setState(() => _filterType = FilterType.all),
            child: Text(context.l10n.ticketHistoryPage_clearFilters),
          ),
        ],
      ),
    );
  }
}

class _HistoryTicketCard extends StatelessWidget {
  final Ticket ticket;
  final bool showDetailedInfo;

  const _HistoryTicketCard({required this.ticket, this.showDetailedInfo = false});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final isExpired = ticket.isExpired;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.confirmation_number_outlined, color: isExpired ? Colors.grey : theme.colorScheme.primary),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ticket.type.typeName.displayName(context),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isExpired ? Colors.grey : null,
                        ),
                      ),
                      Text(
                        'ID: ${ticket.id.substring(0, 8).toUpperCase()}',
                        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${ticket.pricePaid.toStringAsFixed(2)} €',
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: isExpired ? Colors.grey : Colors.red,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        isExpired ? context.l10n.activeTicketCard_expired : context.l10n.ticketHistoryPage_used,
                        style: TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (showDetailedInfo) ...[
              SizedBox(height: 12),
              Divider(height: 1),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(context.l10n.ticketHistoryPage_purchased, _formatDate(ticket.purchaseDate)),
                  ),
                  Expanded(
                    child: _buildDetailItem(context.l10n.ticketHistoryPage_validUntil, _formatDate(ticket.validUntil)),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailItem(
                      context.l10n.ticketHistoryPage_duration,
                      _formatDuration(ticket.validUntil.difference(ticket.validFrom), context),
                    ),
                  ),
                  Expanded(
                    child: _buildDetailItem(
                      context.l10n.ticketHistoryPage_status,
                      isExpired ? context.l10n.activeTicketCard_expired : context.l10n.ticketHistoryPage_used,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _formatDuration(Duration duration, BuildContext context) {
    if (duration.inDays > 0) {
      return duration.inDays > 1
          ? context.l10n.timeFormat_daysPlural(duration.inDays)
          : context.l10n.timeFormat_daysSingle(duration.inDays);
    }
    if (duration.inHours > 0) {
      return duration.inHours > 1
          ? context.l10n.timeFormat_hoursPlural(duration.inHours)
          : context.l10n.timeFormat_hoursSingle(duration.inHours);
    }
    return context.l10n.timeFormat_minutes(duration.inMinutes);
  }
}
