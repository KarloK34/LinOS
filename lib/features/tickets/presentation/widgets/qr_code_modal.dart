import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/tickets/data/models/ticket.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRCodeModal extends StatelessWidget {
  final Ticket ticket;

  const QRCodeModal({super.key, required this.ticket});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHandle(),
          const SizedBox(height: 20),
          _buildTitle(context),
          const SizedBox(height: 16),
          _buildQRCode(),
          const SizedBox(height: 16),
          _buildInstructions(context),
          const SizedBox(height: 8),
          _buildTicketInfo(context),
          const SizedBox(height: 20),
          _buildCloseButton(context),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      context.l10n.qrCodeModal_title,
      style: context.theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildQRCode() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: QrImageView(data: ticket.qrCode, version: QrVersions.auto, size: 250, backgroundColor: Colors.white),
    );
  }

  Widget _buildInstructions(BuildContext context) {
    return Text(
      context.l10n.qrCodeModal_instructions,
      style: const TextStyle(fontSize: 14, color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildTicketInfo(BuildContext context) {
    return Text(
      context.l10n.qrCodeModal_ticketIdPrefix + ticket.id.substring(0, 8).toUpperCase(),
      style: context.theme.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(onPressed: () => context.pop(), child: Text(context.l10n.button_close)),
    );
  }
}
