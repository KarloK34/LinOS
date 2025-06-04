import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:linos/core/utils/context_extensions.dart';
import 'package:linos/features/tickets/presentation/cubit/tickets_cubit.dart';
import 'package:linos/features/tickets/presentation/widgets/qr_code_modal.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:linos/features/tickets/data/models/ticket.dart';

class ActiveTicketCard extends StatefulWidget {
  final Ticket ticket;

  const ActiveTicketCard({super.key, required this.ticket});

  @override
  State<ActiveTicketCard> createState() => _ActiveTicketCardState();
}

class _ActiveTicketCardState extends State<ActiveTicketCard> {
  late Duration _timeRemaining;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _startCountdownTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _calculateTimeRemaining() {
    _timeRemaining = widget.ticket.validUntil.difference(DateTime.now());
  }

  void _startCountdownTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _calculateTimeRemaining();

      if (_timeRemaining.inSeconds <= 0) {
        timer.cancel();
        _updateTimeRemaining(Duration.zero);
        return;
      }

      _updateTimeRemaining(_timeRemaining);
    });
  }

  void _updateTimeRemaining(Duration newTimeRemaining) {
    if (mounted) {
      setState(() {
        _timeRemaining = newTimeRemaining;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_buildHeader(context), const SizedBox(height: 12), _buildContent(context)],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildTicketInfo(context)),
        const SizedBox(width: 8),
        _buildTimeRemainingBadge(context),
      ],
    );
  }

  Widget _buildTicketInfo(BuildContext context) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.ticket.type.typeName.displayName(context),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          '${widget.ticket.pricePaid.toStringAsFixed(2)} €',
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
        ),
      ],
    );
  }

  Widget _buildTimeRemainingBadge(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: _getTimeRemainingColor(), borderRadius: BorderRadius.circular(12)),
      child: Text(
        _formatTimeRemaining(context),
        style: context.theme.textTheme.labelMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _buildTicketDetails(context)),
        const SizedBox(width: 8),
        _buildQRCodePreview(),
      ],
    );
  }

  Widget _buildTicketDetails(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDetailRow(context, label: context.l10n.activeTicketCard_validUntilLabel, value: _formatValidUntilDate()),
        const SizedBox(height: 6),
        _buildDetailRow(context, label: context.l10n.activeTicketCard_ticketIdLabel, value: _formatTicketId()),
      ],
    );
  }

  Widget _buildDetailRow(BuildContext context, {required String label, required String value}) {
    final theme = context.theme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey[600])),
        Text(value, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildQRCodePreview() {
    return GestureDetector(
      onTap: () {
        context.read<TicketsCubit>().useTicket(widget.ticket.id);
        _showQRCodeModal(context);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.outline,
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 4, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            QrImageView(data: widget.ticket.qrCode, version: QrVersions.auto, size: 60),
            const SizedBox(height: 4),
            Text(
              context.l10n.activeTicketCard_tapToEnlarge,
              style: context.theme.textTheme.bodySmall?.copyWith(color: Colors.black, fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  void _showQRCodeModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => QRCodeModal(ticket: widget.ticket),
    );
  }

  Color _getTimeRemainingColor() {
    if (_timeRemaining.inMinutes > 30) return Colors.green;
    if (_timeRemaining.inMinutes > 5) return Colors.orange;
    if (_timeRemaining.inMinutes > 0) return Colors.red;
    return Colors.grey;
  }

  String _formatTimeRemaining(BuildContext context) {
    if (_timeRemaining.inDays > 0) {
      return '${_timeRemaining.inDays}d ${_timeRemaining.inHours % 24}h';
    }
    if (_timeRemaining.inHours > 0) {
      return '${_timeRemaining.inHours}h ${_timeRemaining.inMinutes % 60}m';
    }
    if (_timeRemaining.inMinutes > 0) {
      return '${_timeRemaining.inMinutes}m';
    }
    return context.l10n.activeTicketCard_expired;
  }

  String _formatValidUntilDate() {
    final validUntil = widget.ticket.validUntil;
    return '${validUntil.day}/${validUntil.month}/${validUntil.year} '
        '${validUntil.hour.toString().padLeft(2, '0')}:'
        '${validUntil.minute.toString().padLeft(2, '0')}';
  }

  String _formatTicketId() {
    return widget.ticket.id.substring(0, 8).toUpperCase();
  }
}
