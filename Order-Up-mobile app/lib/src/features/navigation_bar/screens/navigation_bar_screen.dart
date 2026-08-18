// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:orderly_ecom/src/features/navigation_bar/domain/navigation_bar.dart';
// import 'package:orderly_ecom/src/features/navigation_bar/screens/cubit/navigation_cubit.dart';
// import 'package:orderly_ecom/src/widgets/app_bar.dart';

// class NavigationBarScreen extends StatelessWidget {
//   const NavigationBarScreen({
//     super.key,
//     required this.navigationBarItem,
//     required this.title,
//     required this.pages,
//   });
//   final String title;
//   final List<Widget> pages;
//   final List<NavigationBarItem> navigationBarItem;
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: OrderlyAppBar(
//         title: title,
//         elevation: 1.0,
//         backgroundColor: Colors.white,
//         action: [
//           Row(
//             children: [
//               // BlocBuilder<NavigationCubit, NavigationState>(
//               //   builder: (context, state) {
//               //     if (state is NavigationInitial) {
//               //       if ((userType == '1' && state.activeIndex == 4) ||
//               //           (userType == '0' && state.activeIndex == 3)) {
//               //         return ValueListenableBuilder(
//               //           valueListenable:
//               //               inject.get<HiveService>().userBox.listenable(),
//               //           builder: (BuildContext context, Box<dynamic> value,
//               //               Widget? child) {
//               //             if (inject
//               //                 .get<HiveService>()
//               //                 .guestAccessToken
//               //                 .isNotEmpty) {
//               //               return const SizedBox.shrink();
//               //             }
//               //             return BlocProvider(
//               //               create: (context) => ProfileCubit(
//               //                 dioClient: inject.get<DioClient>(),
//               //               ),
//               //               child: BlocBuilder<ProfileCubit, ProfileState>(
//               //                 buildWhen: (oldState, _) {
//               //                   return oldState is ProfileInitialState;
//               //                 },
//               //                 builder: (context, state) {
//               //                   return InkWell(
//               //                     onTap: () {
//               //                       // Navigator.push(
//               //                       //   context,
//               //                       //   MaterialPageRoute(
//               //                       //     builder: (c) => BlocProvider.value(
//               //                       //       value: context.read<ProfileCubit>(),
//               //                       //       child: const EditProfile(),
//               //                       //     ),
//               //                       //   ),
//               //                       // );
//               //                     },
//               //                     child: Padding(
//               //                       padding: const EdgeInsets.all(15.0),
//               //                       child: Text(
//               //                         AppLocalizations.of(context)!.edit,
//               //                         style: TextStyle(
//               //                           fontWeight: FontWeight.w600,
//               //                           fontSize: 15.0,
//               //                           color: Theme.of(context).primaryColor,
//               //                         ),
//               //                       ),
//               //                     ),
//               //                   );
//               //                 },
//               //               ),
//               //             );
//               //           },
//               //         );
//               //       }
//               //       return BlocBuilder<NotificationCubit, NotificationState>(
//               //         buildWhen: (oldState, newState) {
//               //           return newState is NotificationLoadedState;
//               //         },
//               //         builder: (context, state) {
//               //           if (state is NotificationLoadedState) {
//               //             return InkWell(
//               //               onTap: () {
//               //                 // Navigator.push(
//               //                 //   context,
//               //                 //   MaterialPageRoute(
//               //                 //     builder: (c) => const NotificationPage(),
//               //                 //   ),
//               //                 // );
//               //               },
//               //               child: Padding(
//               //                 padding: const EdgeInsets.only(right: 8.0),
//               //                 child: Stack(
//               //                   children: [
//               //                     const Icon(
//               //                       Iconsax.notification,
//               //                       size: 26.0,
//               //                     ),
//               //                     Positioned(
//               //                       right: 0,
//               //                       bottom: 1,
//               //                       child: Container(
//               //                         height: 14.0,
//               //                         width: 14.0,
//               //                         decoration: BoxDecoration(
//               //                           color: AppColor.accentColor,
//               //                           borderRadius:
//               //                               BorderRadius.circular(8.5),
//               //                         ),
//               //                         alignment: Alignment.center,
//               //                         child: Text(
//               //                           () {
//               //                             if (state.notificationList != null) {
//               //                               return state.notificationList!
//               //                                   .notification.length
//               //                                   .toString();
//               //                             }
//               //                             return '0';
//               //                           }(),
//               //                           style: const TextStyle(
//               //                             color: Colors.white,
//               //                             fontSize: 10,
//               //                             fontWeight: FontWeight.w400,
//               //                           ),
//               //                           textAlign: TextAlign.center,
//               //                         ),
//               //                       ),
//               //                     ),
//               //                   ],
//               //                 ),
//               //               ),
//               //             );
//               //           }
//               //           return const Offstage();
//               //         },
//               //       );
//               //     }
//               //     return const Center();
//               //   },
//               // ),
//               Visibility(
//                 visible: true,
//                 child: InkWell(
//                   onTap: () async {
//                     // Navigator.push(
//                     //   context,
//                     //   MaterialPageRoute(
//                     //     builder: (c) => const CartPage(),
//                     //   ),
//                     // );
//                     // await context.read<CartCubit>().fetchCart(
//                     //       latitude: '',
//                     //       longitude: '',
//                     //     );
//                   },
//                   child: Padding(
//                     padding: const EdgeInsets.only(right: 8.0),
//                     child: Stack(
//                       children: const [
//                         Icon(
//                           Iconsax.shopping_bag,
//                           size: 26.0,
//                         ),
//                         // Positioned(
//                         //   right: 0,
//                         //   bottom: 0,
//                         //   child: Container(
//                         //     height: 14.0,
//                         //     width: 14.0,
//                         //     decoration: BoxDecoration(
//                         //       color: AppTheme.accentColor,
//                         //       borderRadius: BorderRadius.circular(8.5),
//                         //     ),
//                         //     alignment: Alignment.center,
//                         //     child: BlocBuilder<CartCubit, CartState>(
//                         //       buildWhen: (previous, current) {
//                         //         return current is CartLoadedState ||
//                         //             current is CartErrorState;
//                         //       },
//                         //       builder: (context, state) {
//                         //         return Text(
//                         //           '',
//                         //           // context
//                         //           //     .read<CartCubit>()
//                         //           //     .cartLength
//                         //           //     .toString(),
//                         //           style: const TextStyle(
//                         //             color: Colors.white,
//                         //             fontSize: 10,
//                         //             fontWeight: FontWeight.w400,
//                         //           ),
//                         //           textAlign: TextAlign.center,
//                         //         );
//                         //       },
//                         //     ),
//                         //   ),
//                         // ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//       extendBody: true,
//       body: BlocBuilder<NavigationCubit, NavigationState>(
//         builder: (context, state) {
//           if (state is NavigationInitialState) {
//             return pages[state.activeIndex];
//           }
//           return const SizedBox.shrink();
//         },
//       ),
//       bottomNavigationBar: ClipRRect(
//         child: BackdropFilter(
//           filter: ImageFilter.blur(
//             sigmaX: 10,
//             sigmaY: 10,
//           ),
//           child: Container(
//             decoration: BoxDecoration(
//               border: Border.all(color: const Color(0xff727c8e)),
//               borderRadius: BorderRadius.circular(35.0),
//             ),
//             child: ClipRRect(
//               borderRadius: BorderRadius.circular(35.0),
//               child: BlocBuilder<NavigationCubit, NavigationState>(
//                 buildWhen: (_, newState) {
//                   return newState is NavigationInitialState;
//                 },
//                 builder: (context, state) {
//                   if (state is NavigationInitialState) {
//                     return BottomNavigationBar(
//                       elevation: 0.0,
//                       backgroundColor: Colors.transparent,
//                       type: BottomNavigationBarType.fixed,
//                       unselectedItemColor:
//                           Theme.of(context).unselectedWidgetColor,
//                       selectedItemColor: Theme.of(context).primaryColor,
//                       showUnselectedLabels: true,
//                       currentIndex: state.activeIndex,
//                       items: navigationBarItem
//                           .map(
//                             (e) => BottomNavigationBarItem(
//                               icon: Icon(
//                                 e.icon,
//                               ),
//                               label: e.label,
//                             ),
//                           )
//                           .toList(),
//                       onTap: (index) {
//                         HapticFeedback.lightImpact();
//                         context
//                             .read<NavigationCubit>()
//                             .changeIndex(index: index);
//                       },
//                     );
//                   }
//                   return const SizedBox.shrink();
//                 },
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
