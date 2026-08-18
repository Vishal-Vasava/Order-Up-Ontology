enum OrderTab {
  shipped,
  pending,
  delivered,
  returned,
  replace,
}

extension OrderTabName on String {
  String get orderTabName {
    switch (this) {
      case 'shipped':
        return 'shipped';
      case 'pending':
        return 'ready';
      case 'delivered':
        return 'delivered';
      case 'returned':
        return 'returned';
      case 'replace':
        return 'replaced';
      default:
        return '';
    }
  }
}

List<String> orderTab = [
  OrderTab.shipped.name,
  OrderTab.pending.name,
  OrderTab.delivered.name,
  OrderTab.returned.name,
  OrderTab.replace.name,
];
