// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:lottie/lottie.dart';
// import 'package:orderly_ecom/Screens/FleetManager/offers/data/offer_repository.dart';
// import 'package:orderly_ecom/Screens/FleetManager/offers/screens/cubit/offer_cubit.dart';
// import 'package:orderly_ecom/Screens/FleetManager/offers/screens/cubit/offer_state.dart';
// import 'package:orderly_ecom/Screens/FleetManager/offers/prod_offers.dart';
// import 'package:orderly_ecom/Screens/FleetManager/offers/screens/customer/offer_list.dart';
// import 'package:orderly_ecom/config/image.dart';
// import 'package:orderly_ecom/config/theme.dart';
// import 'package:orderly_ecom/services/di/get_it.dart';
// import 'package:orderly_ecom/services/dio/dio_client.dart';

// class OfferIndex extends StatelessWidget {
//   const OfferIndex({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return RepositoryProvider(
//       create: (context) => OfferRepository(dioClient: inject.get<DioClient>()),
//       child: BlocProvider(
//         create: (context) => OfferCubit(
//           offerInterface: context.read<OfferRepository>(),
//         ),
//         child: BlocBuilder<OfferCubit, OfferState>(
//           buildWhen: (_, newState) {
//             return newState is OfferCustomerProductInitialState;
//           },
//           builder: (context, state) {
//             return Scaffold(
//               appBar: AppBar(
//                 backgroundColor: Colors.white,
//                 centerTitle: false,
//                 title: const Text(
//                   'Apply Offers',
//                   style: TextStyle(
//                     color: AppTheme.blackColor,
//                   ),
//                 ),
//               ),
//               body: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Center(
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                               builder: (c) => BlocProvider.value(
//                                     value: context.read<OfferCubit>(),
//                                     child: const OfferList(),
//                                   )),
//                         );
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 30),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: const [
//                             BoxShadow(
//                               offset: Offset(0, 4),
//                               blurRadius: 2.0,
//                               spreadRadius: 2.0,
//                               color: AppTheme.kShadowColor,
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             LottieBuilder.asset(
//                               Images.customerOffer,
//                               height: 120,
//                             ),
//                             const SizedBox(height: 20),
//                             const Text('Apply Offers On Customers')
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 40),
//                   Center(
//                     child: InkWell(
//                       onTap: () {
//                         Navigator.of(context).push(
//                           MaterialPageRoute(
//                               builder: (context) => const ProductList()),
//                         );
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 30, vertical: 30),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(20),
//                           boxShadow: const [
//                             BoxShadow(
//                               offset: Offset(0, 4),
//                               blurRadius: 2.0,
//                               spreadRadius: 2.0,
//                               color: AppTheme.kShadowColor,
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           children: [
//                             LottieBuilder.asset(
//                               Images.productOffer,
//                               height: 120,
//                             ),
//                             const SizedBox(height: 20),
//                             const Text('  Apply Offers On Products  ')
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
