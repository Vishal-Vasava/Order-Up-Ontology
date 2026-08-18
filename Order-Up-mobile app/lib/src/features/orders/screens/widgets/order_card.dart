// ignore_for_file: use_build_context_synchronously

import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:orderly_ecom/src/features/orders/data/order_pdf_api.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/features/orders/screens/components/order_invoice_pdf.dart';
import 'package:orderly_ecom/src/features/orders/screens/cubit/order_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';

class OrderCard extends StatelessWidget {
  const OrderCard({super.key, required this.modelData});
  final Order modelData;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: modelData.orderItems!.length,
      primary: false,
      shrinkWrap: true,
      itemBuilder: (c, i) {
        return InkWell(
          onTap: () {
            context.goNamed(AppRoute.orderTrack.toName, params: {
              'orderId': modelData.orderId!.toString(),
              'orderDetailId': modelData.orderItems![i].id!,
            });
            // Navigator.push(
            //   context,
            //   MaterialPageRoute(
            //     builder: (c) => BlocProvider.value(
            //       value: context.read<OrderCubit>(),
            //       child: TrackOrderPage(
            //         modelData: orderModel,
            //         image: orderModel.items![i]!.imgPath!,
            //         productName: orderModel.items![i]!.productName!,
            //         productQty: orderModel.items![i]!.qty!,
            //         orderNumber: orderModel.items![i]!.orderDetailsId!,
            //         fees: orderModel.convinienceFee.toString(),
            //         price: orderModel.items![i]!.productRate.toString(),
            //       ),
            //     ),
            //   ),
            // );
          },
          child: Container(
            margin: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black26,
              ),
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 17),
                  blurRadius: 20,
                  spreadRadius: -10,
                  color: AppColor.kShadowColor,
                )
              ],
            ),
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 10.0, top: 10.0, bottom: 5.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        modelData.orderItems![i].status!.normalize,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14.0,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        "On ${DateFormat('EEEE, d MMM, yyyy').format(modelData.createdAt!)}",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ImageBuilder(
                          //   imageUrl:
                          //       modelData.orderItems![i].productImageUrl ?? '',
                          //   height: 80.0,
                          //   fitType: BoxFit.cover,
                          // ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  modelData.orderItems![i].productName ?? '',
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Convinience Fee - ',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                    children: [
                                      TextSpan(
                                        text:
                                            ' ${modelData.currency?.locale!.getCurrencyPerLocale} ${modelData.conveyanceCharge}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: AppColor.accentColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'Item Price -  ',
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                    children: [
                                      TextSpan(
                                        text:
                                            '${modelData.currency?.locale!.getCurrencyPerLocale} ${modelData.orderItems![i].price!}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall!
                                            .copyWith(
                                              color: AppColor.accentColor,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text:
                                        AppLocalizations.of(context)!.quantity,
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                    children: [
                                      TextSpan(
                                        text:
                                            ' - ${modelData.orderItems![i].qty}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (modelData.orderItems![i].status != 'rejected' &&
                        modelData.orderItems![i].status != 'rejected' &&
                        modelData.orderItems![i].status != 'rejected')
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Divider(
                            height: 1.0,
                            color: Colors.grey,
                          ),
                          //product review
                          if ((modelData.orderItems![i].status == 'delivered' ||
                                  modelData.orderItems![i].status ==
                                      'returned' ||
                                  modelData.orderItems![i].status ==
                                      'refunded') &&
                              modelData.orderItems![i].showReviewForm!)
                            Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  visualDensity: VisualDensity.compact,
                                  onTap: () {
                                    context.goNamed(
                                      AppRoute.orderReview.toName,
                                      params: {
                                        'orderId':
                                            modelData.orderId!.toString(),
                                        'orderItemId': modelData
                                            .orderItems![i].orderItemId!,
                                      },
                                    );
                                  },
                                  title: Text(
                                    AppLocalizations.of(context)!
                                        .product_review,
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  trailing: const Icon(
                                    kIsWeb
                                        ? Icons.arrow_circle_right_outlined
                                        : Iconsax.arrow_right,
                                  ),
                                ),
                                const Divider(
                                  height: 1.0,
                                  color: Colors.grey,
                                ),
                              ],
                            ),

                          /// [Track order]
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                            title: Text(
                              AppLocalizations.of(context)!.track_order,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall!
                                  .copyWith(
                                    color: AppColor.accentColor,
                                  ),
                            ),
                            trailing: const Icon(
                              kIsWeb
                                  ? Icons.arrow_circle_right_outlined
                                  : Iconsax.arrow_right,
                            ),
                            onTap: () {
                              context
                                  .goNamed(AppRoute.orderTrack.toName, params: {
                                'orderId': modelData.orderId!.toString(),
                                'orderDetailId':
                                    modelData.orderItems![i].orderItemId!,
                              });
                              // Navigator.push(
                              //   context,
                              //   MaterialPageRoute(
                              //     builder: (c) => BlocProvider.value(
                              //       value: context.read<OrderCubit>(),
                              //       child: TrackOrderPage(
                              //         modelData: orderModel,
                              //         image: orderModel.items![i]!.imgPath!,
                              //         productName:
                              //             orderModel.items![i]!.productName!,
                              //         productQty: orderModel.items![i]!.qty!,
                              //         orderNumber:
                              //             orderModel.items![i]!.orderDetailsId!,
                              //         fees:
                              //             orderModel.convinienceFee.toString(),
                              //         price: orderModel.items![i]!.productRate
                              //             .toString(),
                              //       ),
                              //     ),
                              //   ),
                              // );
                            },
                          ),
                          const Divider(
                            height: 1.0,
                            color: Colors.grey,
                          ),
                          if (modelData.orderItems![i].status == 'delivered' ||
                              modelData.orderItems![i].status == 'returned' ||
                              modelData.orderItems![i].status == 'refunded')
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              title: Text(
                                AppLocalizations.of(context)!.invoice,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              trailing: const Icon(
                                kIsWeb
                                    ? Icons.arrow_circle_right_outlined
                                    : Iconsax.arrow_right,
                              ),
                              onTap: () async {
                                try {
                                  final invoice = await context
                                      .read<OrderCubit>()
                                      .downloadInvoice(
                                          orderId:
                                              modelData.orderId.toString());
                                  if (invoice != null) {
                                    final pdfFile =
                                        await PdfInvoiceApi.generate(invoice);
                                    await PdfApi.openFile(pdfFile);
                                  } else {
                                    showSnackBar(
                                      context: context,
                                      title: 'Couldn\'t download invoice',
                                      message: 'Try Again!',
                                      snackbarType: SnackbarType.error,
                                    );
                                  }
                                } on PlatformException catch (e) {
                                  log(e.toString());
                                  showSnackBar(
                                    context: context,
                                    title: 'Couldn\'t download invoice',
                                    message: e.toString(),
                                    snackbarType: SnackbarType.error,
                                  );
                                } catch (e) {
                                  showSnackBar(
                                    context: context,
                                    title: 'Error: Couldn\'t download invoice',
                                    message: e.toString(),
                                    snackbarType: SnackbarType.error,
                                  );
                                }
                              },
                            ),
                          Visibility(
                            visible: modelData.orderItems![i].status ==
                                    'delivered' ||
                                modelData.orderItems![i].status == 'returned' ||
                                modelData.orderItems![i].status == 'refunded',
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: AppColor.primaryColor,
                                padding: const EdgeInsets.all(12.0),
                              ),
                              onPressed: () {
                                context.goNamed(
                                  AppRoute.orderTrack.toName,
                                  params: {
                                    'orderId': modelData.orderId!.toString(),
                                    'orderDetailId':
                                        modelData.orderItems![i].id!,
                                  },
                                );
                                // context.goNamed(
                                //     AppRoute.orderReturnReplace.toName);
                              },
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    AppLocalizations.of(context)!
                                        .return_replace,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall!
                                        .copyWith(
                                          color: AppColor.whiteColor,
                                        ),
                                  ),
                                  const Icon(
                                    kIsWeb
                                        ? Icons.arrow_circle_right_outlined
                                        : Iconsax.arrow_right,
                                    color: AppColor.whiteColor,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
