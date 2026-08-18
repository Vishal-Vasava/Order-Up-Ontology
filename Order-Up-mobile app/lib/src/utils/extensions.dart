import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

/// A simple placeholder that can be used to search all the hardcoded strings
/// in the code (useful to identify strings that need to be localized).
extension StringHardcoded on String {
  String get hardcoded => this;
}

extension TrimLastComma on String {
  String get trimLastComma {
    if (endsWith(',')) {
      return substring(0, length - 1).trim();
    }
    return '';
  }
}

extension ParseString on String {
  num get parsedString {
    if (trim().contains('.')) {
      return double.parse(this);
    } else {
      return int.parse(this);
    }
  }
}

// extension MultiplePayToString on List {
//   String get multiplePayment {
//     return fold(
//       '',
//       (previousValue, element) =>
//           '$previousValue${element.mopType!} :   ${StaticText.rupeeSymbol} ${element.totalCashIn!}\n',
//     );
//   }
// }

// extension OrderStatus on int {
//   String get toOrderStatus {
//     if (this == 0) {
//       return 'Order Pending';
//     } else if (this == 1) {
//       return 'Order Accepted';
//     } else if (this == 2) {
//       return 'Order Shipped';
//     } else if (this == 3) {
//       return 'Order Delivered';
//     } else if (this == 4) {
//       return 'Order Returned';
//     } else if (this == 5) {
//       return 'Order Replaced';
//     } else if (this == 6) {
//       return 'Order Cancelled';
//     } else if (this == 7) {
//       return 'Order Return Confirmed';
//     } else if (this == 8) {
//       return 'Order Return Rejected';
//     } else if (this == 9) {
//       return 'Order Return Shipped';
//     } else if (this == 10) {
//       return 'Order Return Delivered';
//     } else if (this == 11) {
//       return 'Order Replace Confirmed';
//     } else if (this == 12) {
//       return 'Order Replace Rejected';
//     } else if (this == 13) {
//       return 'Order Replace Shipped';
//     } else if (this == 14) {
//       return 'Order Replace Delivered';
//     } else {
//       return '';
//     }
//   }
// }

extension RemoveComma on String {
  String get removeComma {
    if (trim().endsWith(',')) {
      return trim().substring(0, length - 1);
    } else {
      return trim();
    }
  }
}

extension WebPageTitle on String {
  void titleOnWeb(BuildContext context) {
    SystemChrome.setApplicationSwitcherDescription(
        ApplicationSwitcherDescription(
      label: this,
      primaryColor: Theme.of(context).primaryColor.value,
    ));
  }
}

extension CurrencyLocale on String {
  String get getCurrencyPerLocale {
    var format = NumberFormat.simpleCurrency(locale: this);
    String currencySymbol = format.currencySymbol;
    return currencySymbol;
  }
}

extension StringExtension on String {
  String get normalize =>
      isEmpty ? this : this[0].toUpperCase() + substring(1, length);

  String get normalizeFirstLetter => isEmpty
      ? this
      : replaceAll(RegExp(' +'), ' ')
          .split(' ')
          .map((str) => str.normalize)
          .join(' ');
}

extension CubitExtension<T> on BuildContext {
  T get cubit {
    return read<T>();
  }
}
