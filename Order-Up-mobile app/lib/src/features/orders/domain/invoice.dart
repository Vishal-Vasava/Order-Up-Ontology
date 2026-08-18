import 'package:orderly_ecom/src/features/orders/domain/invoice_model.dart';

class Invoice {
  const Invoice({
    required this.info,
    required this.supplier,
    required this.customer,
    required this.items,
  });
  final InvoiceInfo info;
  final Supplier supplier;
  final Customer customer;
  final List<InvoiceData> items;
}

class Customer {
  const Customer({
    required this.name,
    required this.address,
  });
  final String name;
  final String address;
}

class InvoiceInfo {
  const InvoiceInfo({
    required this.description,
    required this.number,
    required this.date,
    required this.dueDate,
    required this.totalAmt,
    required this.conveyanceFee,
    required this.deliveryCharges,
  });
  final String description;
  final String number;
  final String date;
  final DateTime dueDate;
  final String totalAmt;
  final String conveyanceFee;
  final String deliveryCharges;
}

class Supplier {
  const Supplier({
    required this.name,
    required this.address,
    required this.paymentInfo,
  });
  final String name;
  final String address;
  final String paymentInfo;
}
