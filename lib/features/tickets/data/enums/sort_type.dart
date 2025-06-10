import 'package:flutter/material.dart';
import 'package:linos/core/utils/context_extensions.dart';

enum SortType {
  newest,
  oldest,
  priceHigh,
  priceLow;

  String camelCaseName(BuildContext context) {
    switch (this) {
      case SortType.newest:
        return context.l10n.ticketHistoryPage_sortNewest;
      case SortType.oldest:
        return context.l10n.ticketHistoryPage_sortOldest;
      case SortType.priceHigh:
        return context.l10n.ticketHistoryPage_sortPriceHigh;
      case SortType.priceLow:
        return context.l10n.ticketHistoryPage_sortPriceLow;
    }
  }
}
