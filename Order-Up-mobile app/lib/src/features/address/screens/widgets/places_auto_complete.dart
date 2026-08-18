// import 'dart:developer';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';
// import 'package:go_router/go_router.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:orderly_ecom/src/constants/app_keys.dart';
// import 'package:orderly_ecom/src/constants/sizes.dart';
// import 'package:orderly_ecom/src/theme/colors.dart';
// import 'package:orderly_ecom/src/widgets/app_button.dart';

// class PlacesAutoComplete extends StatefulWidget {
//   const PlacesAutoComplete({super.key, required this.address});
//   final String address;

//   @override
//   _PlacesAutoCompleteState createState() => _PlacesAutoCompleteState();
// }

// class _PlacesAutoCompleteState extends State<PlacesAutoComplete> {
//   final TextEditingController searchController = TextEditingController();

//   List<AutocompletePrediction> addressList = [];

//   AutocompletePrediction? autocompletePrediction;
//   @override
//   void initState() {
//     super.initState();
//     searchController.text = widget.address;
//   }

//   Future<void> callMapApi({required String search}) async {
//     final places = FlutterGooglePlacesSdk(AppKey.googlePlacesKey);
//     final predictions = await places.findAutocompletePredictions(search);
//     log('Result: $predictions');
//     addressList = predictions.predictions;
//     setState(() {});
//     // try {
//     //   final dioClient = inject.get<NetworkAdapter>().dio;

//     //   final url =
//     //       'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$search'
//     //       '&types=establishment&language=en&components=country:in&key=${AppKey.googlePlacesKey}&sessiontoken=19';
//     //   final response = await dioClient.get(url);
//     //   if (response.statusCode! >= 200 && response.statusCode! <= 299) {
//     //     log(response.data.toString(), name: 'Map Response');
//     //   }
//     // } on DioException catch (e) {
//     //   throw DioExceptions.fromDioError(e);
//     // }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: MediaQuery.of(context).size.height / 2,
//       width: MediaQuery.of(context).size.width / 2.5,
//       child: Padding(
//         padding: const EdgeInsets.all(6),
//         child: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.spaceAround,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     'Search for address.',
//                     style: TextStyle(
//                       fontWeight: FontWeight.w600,
//                       fontSize: 20.0,
//                       color: Theme.of(context).primaryColor,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: context.pop,
//                     icon: const Icon(
//                       kIsWeb ? Icons.close : Iconsax.close_square,
//                     ),
//                   ),
//                 ],
//               ),
//               TextFormField(
//                 controller: searchController,
//                 autofocus: true,
//                 style: Theme.of(context).textTheme.titleSmall!,
//                 decoration: InputDecoration(
//                   hintText: 'Search your location',
//                   suffixIcon: IconButton(
//                     onPressed: () {
//                       searchController.clear();
//                       autocompletePrediction = null;
//                     },
//                     icon: const Icon(
//                       Icons.clear,
//                     ),
//                   ),
//                 ),
//                 onChanged: (value) {
//                   callMapApi(search: value);
//                 },
//               ),
//               ...List.generate(
//                 addressList.length,
//                 (index) {
//                   var address = addressList[index];
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 12.0),
//                     child: InkWell(
//                       onTap: () {
//                         searchController.text = address.fullText;
//                         autocompletePrediction = address;
//                         setState(() {});
//                       },
//                       child: Column(
//                         children: [
//                           Row(
//                             children: [
//                               Container(
//                                   width: 25,
//                                   height: 25,
//                                   decoration: const BoxDecoration(
//                                     color: Colors.grey,
//                                   ),
//                                   child: const Center(
//                                       child: Icon(
//                                     CupertinoIcons.location_solid,
//                                     size: 14,
//                                     color: Colors.white,
//                                   ))),
//                               Flexible(
//                                 fit: FlexFit.tight,
//                                 child: Padding(
//                                   padding: const EdgeInsets.only(left: 12.0),
//                                   child: Text(
//                                     address.primaryText,
//                                     textAlign: TextAlign.left,
//                                   ),
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const Padding(
//                             padding: EdgeInsets.symmetric(vertical: 4.0),
//                             child: Divider(
//                               color: AppColor.accentColor,
//                             ),
//                           )
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               gapH12,
//               AppButton(
//                 isLoading: false,
//                 buttonText: 'Submit',
//                 onPressed: () {
//                   context.pop(autocompletePrediction);
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
