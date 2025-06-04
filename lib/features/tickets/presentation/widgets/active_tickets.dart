import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/core/widgets/dots_indicator.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_state.dart';
import 'package:linos/features/tickets/presentation/widgets/active_ticket_card.dart';

class ActiveTickets extends StatefulWidget {
  const ActiveTickets({super.key});

  @override
  State<ActiveTickets> createState() => _ActiveTicketsState();
}

class _ActiveTicketsState extends State<ActiveTickets> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TicketsCubit, TicketsState>(
      builder: (context, state) {
        if (state is TicketsLoaded) {
          final activeTickets = state.activeTickets;

          if (activeTickets.isEmpty) {
            return _NoActiveTicketsCard();
          }

          return Column(
            children: [
              SizedBox(
                height: 200,
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                  itemCount: activeTickets.length,
                  itemBuilder: (context, index) {
                    return ActiveTicketCard(ticket: activeTickets[index]);
                  },
                ),
              ),

              if (activeTickets.length > 1) ...[
                SizedBox(height: 12),
                DotsIndicator(
                  itemCount: activeTickets.length,
                  currentIndex: _currentIndex,
                  onDotTapped: (index) {
                    _pageController.animateToPage(
                      index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ],
            ],
          );
        }

        if (state is TicketsError) {
          return _ErrorCard(message: state.message);
        }

        return SizedBox(height: 120, child: Center(child: CircularProgressIndicator()));
      },
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({this.message = ''});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 8),
              Text(
                context.l10n.error_loadingTickets,
                style: context.theme.textTheme.titleMedium?.copyWith(color: Colors.red),
              ),
              Text(message, style: TextStyle(color: Colors.red, fontSize: 12)),
              SizedBox(height: 8),
              BlocBuilder<TicketsCubit, TicketsState>(
                builder: (context, state) {
                  if (state is TicketsLoading) {
                    return CircularProgressIndicator();
                  }
                  return ElevatedButton(
                    onPressed: () => context.read<TicketsCubit>().loadUserData(),
                    child: Text(
                      context.l10n.button_retry,
                      style: context.theme.textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoActiveTicketsCard extends StatelessWidget {
  const _NoActiveTicketsCard();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              Icon(Icons.confirmation_number_outlined, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                context.l10n.ticketsPage_noActiveTickets,
                style: context.theme.textTheme.titleMedium?.copyWith(color: Colors.grey),
              ),
              Text(
                context.l10n.ticketsPage_purchasePrompt,
                style: context.theme.textTheme.bodyMedium?.copyWith(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
