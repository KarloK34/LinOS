import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:qr_flutter/qr_flutter.dart';

class TicketsPage extends StatelessWidget {
  const TicketsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                context.l10n.ticketsPage_generatedTicketCodeTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: context.theme.colorScheme.outline, width: 1.0),
                ),
                child: Center(
                  child: QrImageView(data: '1234567890', version: QrVersions.auto, size: 200.0),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                context.l10n.ticketsPage_currentBalanceTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Container(
                padding: const EdgeInsets.all(12.0),
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: context.theme.colorScheme.outline, width: 1.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(context.l10n.ticketsPage_balanceLabel, style: TextStyle(fontSize: 12)),
                    Text('\$50.00', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              SizedBox(height: 16.0),
              Column(
                spacing: 12.0,
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FloatingActionButton(
                      onPressed: () {},
                      child: Text(context.l10n.ticketsPage_buyDigitalTicketButton),
                    ),
                  ),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: FloatingActionButton(
                      onPressed: () {},
                      child: Text(context.l10n.ticketsPage_topUpBalanceButton),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              Text(
                context.l10n.ticketsPage_purchasedTicketsTitle,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                context.l10n.ticketsPage_purchasedTicketsSubtitle,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              SizedBox(height: 16.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FloatingActionButton(
                  onPressed: () {},
                  child: Text(context.l10n.ticketsPage_viewTicketHistoryButton),
                ),
              ),
              SizedBox(height: 16.0),
            ],
          ),
        ),
      ),
    );
  }
}
