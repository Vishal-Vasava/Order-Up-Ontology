import 'dart:io';

import 'package:orderly_ecom/src/features/orders/data/order_pdf_api.dart';
import 'package:orderly_ecom/src/features/orders/domain/invoice.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

class PdfInvoiceApi {
  static Future<File> generate(Invoice invoice) async {
    final pdf = pw.Document();
    pdf.addPage(MultiPage(
      build: (context) => [
        buildHeader(invoice),
        SizedBox(height: 3 * PdfPageFormat.cm),
        // buildTitle(invoice),
        buildInvoice(invoice),
        Divider(),
        buildTotal(invoice),
        Spacer(),
        RichText(
          text: TextSpan(
            text: 'Note : ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text:
                    'Orders which are cancelled for any of the reasons. Those amount will refund back to you withing 3-5 working days.',
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ],
      // footer: (context) => buildFooter(invoice),
    ));

    return PdfApi.saveDocument(name: 'order-up_invoice.pdf', pdf: pdf);
    // return PdfApi.download(name: 'my_invoice.pdf', pdf: pdf);
  }

  static Widget buildHeader(Invoice invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // buildSupplierAddress(invoice.supplier),
              Container(),
              SizedBox(
                height: 50,
                width: 50,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: invoice.info.number,
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.address),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    // final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Invoice Number:',
      'Invoice Date:',
      // 'Payment Terms:',
      // 'Due Date:'
    ];
    final data = <String>[
      info.number,
      // Utils.formatDate(info.date),
      info.date,
      // DateFormat('EEEE, d MMM, yyyy').format(DateTime.parse(info.date))
      // paymentTerms,
      // Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Supplier supplier) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(supplier.name, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 1 * PdfPageFormat.mm),
          Text(supplier.address),
        ],
      );
  //
  // static Widget buildTitle(Invoice invoice) => Column(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
  //     Text(
  //       'INVOICE',
  //       style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
  //     ),
  //     SizedBox(height: 0.8 * PdfPageFormat.cm),
  //     Text(invoice.info.description),
  //     SizedBox(height: 0.8 * PdfPageFormat.cm),
  //   ],
  // );
  //
  static Widget buildInvoice(Invoice invoice) {
    final headers = [
      'Product Name',
      'Date',
      'Quantity',
      'Unit Price',
      'Total',
      'Status'
    ];
    final data = invoice.items.map((item) {
      // final total = item.un * item.quantity * (1 + item.vat);
      // DateFormat formatter = new DateFormat("EEE MMM dd HH:mm:ss zzzz yyyy");
      // try {
      //   String temp = "Thu Dec 17 15:37:43 GMT+05:30 2015";
      //   DateTime expiry = formatter.parse(temp);
      //   debugPrint(expiry.toString());
      // } catch (e) {
      // e.printStackTrace();
      // }
      return [
        item.productName,
        invoice.info.date,
        // Utils.formatDate(item.orderDate),
        '${item.qty}',
        '${item.price}',
        // '${item.vat} %',
        '${item.orderItemTotal}',
        (item.status!.normalize),
      ];
    }).toList();

    return TableHelper.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: const BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.center,
        1: Alignment.center,
        2: Alignment.center,
        3: Alignment.center,
        4: Alignment.center,
        // 5: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Invoice invoice) {
    // final netTotal = invoice.items
    //     .map((item) => item.unitPrice * item.qty)
    //     .reduce((item1, item2) => item1 + item2);
    // final vatPercent = invoice.items.first.vat;
    // final vat = netTotal * vatPercent;
    // final total = netTotal + vat;

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 5),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildText(
                  title: 'Conveyance Fee :',
                  value: double.parse(invoice.info.conveyanceFee)
                      .toStringAsFixed(2),
                  unite: false,
                ),
                buildText(
                  title: 'Delivery Charges :',
                  value: double.parse(invoice.info.deliveryCharges)
                      .toStringAsFixed(2),
                  unite: true,
                ),
                buildText(
                  title: 'Net total :',
                  value: (double.parse(invoice.info.totalAmt) +
                          double.parse(invoice.info.deliveryCharges) +
                          double.parse(invoice.info.conveyanceFee))
                      .toStringAsFixed(2),
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static buildSimpleText({
    required String title,
    required String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    required String title,
    required String value,
    double width = double.infinity,
    bool unite = false,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return SizedBox(
      width: width,
      child: Row(
        children: [
          Text(title, style: style),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
