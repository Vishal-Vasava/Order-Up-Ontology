// import 'dart:developer';
// import 'package:flutter/material.dart';

// class Navigation {
//   /// Will push new page to Stack.
//   static void to(BuildContext context, Widget widget) {
//     log(widget.toString(), name: 'Going to Page');
//     Navigator.push(context, MaterialPageRoute(builder: (c) => widget));
//   }

//   /// Will remove current page from Stack.
//   /// To close snackbars, dialogs, bottomsheets or page.
//   static void back(BuildContext context) {
//     log(context.widget.toString(), name: 'Removed Page');
//     if (Navigator.canPop(context)) {
//       Navigator.pop(context);
//     }
//   }

//   /// To go to the next screen and no option to go back to the previous screen
//   /// (for use in SplashScreens, login screens, etc.)
//   /// Will remove current route and add new page to stack.
//   static void off(BuildContext context, Widget widget) {
//     log(widget.toString(), name: 'Jump to page');
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (c) => widget));
//   }

//   static void offAll(BuildContext context, Widget widget) {
//     log(context.widget.toString(), name: 'Off From Current Page');
//     log(widget.toString(), name: 'Off To =>');
//     Navigator.popUntil(context, (route) => route.isFirst);
//     Navigator.pushReplacement(
//         context, MaterialPageRoute(builder: (context) => widget));
//   }

//   static void offUntil(BuildContext context) {
//     log(context.widget.toString(), name: 'Off Until');
//     Navigator.popUntil(context, (route) => route.isFirst);
//   }

//   static void offToRoute(BuildContext context) {
//     Navigator.popUntil(context, ModalRoute.withName('/tableorderdetial'));
//   }
// }
