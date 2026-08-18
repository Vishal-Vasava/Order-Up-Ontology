import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/orders/domain/order.dart';
import 'package:orderly_ecom/src/features/orders/screens/components/order_rating_experience.dart';
import 'package:orderly_ecom/src/features/orders/screens/cubit/order_cubit.dart';
import 'package:orderly_ecom/src/features/orders/screens/widgets/product_card.dart';
import 'package:orderly_ecom/src/utils/snackbar.dart';
import 'package:orderly_ecom/src/utils/validations.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/widgets/app_button.dart';

class OrderProductReview extends StatefulWidget {
  const OrderProductReview({
    super.key,
    required this.orderId,
    required this.orderItemId,
  });
  final String orderId;
  final String orderItemId;
  @override
  State<OrderProductReview> createState() => _OrderProductReviewState();
}

class _OrderProductReviewState extends State<OrderProductReview> {
  late final ValueNotifier<Map<String, double>> reviewNotifier;

  late final TextEditingController reviewController;

  late Order modelData;
  late OrderItem orderItems;

  @override
  void initState() {
    super.initState();
    reviewController = TextEditingController();
  }

  void init() {
    final orderIndex = context
        .read<OrderCubit>()
        .orderList
        .indexWhere((element) => element.orderId!.toString() == widget.orderId);
    modelData = context.read<OrderCubit>().orderList[orderIndex];
    final index = modelData.orderItems!
        .indexWhere((element) => element.orderItemId == widget.orderItemId);
    orderItems = modelData.orderItems![index];
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    init();
  }

  void bindReviews() {
    reviewNotifier = ValueNotifier<Map<String, double>>({
      AppLocalizations.of(context)!.app_exp: 0,
      AppLocalizations.of(context)!.product_quality: 0,
      AppLocalizations.of(context)!.order_exp: 0,
      AppLocalizations.of(context)!.pay_exp: 0,
      AppLocalizations.of(context)!.overall: 0,
    });
  }

  @override
  void dispose() {
    reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bindReviews();
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.product_review,
      ),
      body: ListView(
        padding: const EdgeInsets.all(kDefaultPadding),
        physics: const BouncingScrollPhysics(),
        children: [
          ...List.generate(
            5,
            (index) => ValueListenableBuilder(
              valueListenable: reviewNotifier,
              builder: (BuildContext context, Map<String, double> value,
                  Widget? child) {
                return RatingExperience(
                  title: value.keys.elementAt(index),
                  rate: value.values.elementAt(index),
                  ratingChangeCallback: (double rating) {
                    reviewNotifier.value
                        .update(value.keys.elementAt(index), (value) => rating);
                    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                    reviewNotifier.notifyListeners();
                  },
                );
              },
            ),
          ),
          gapH12,
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ProductCard(
                    modelData: modelData,
                    orderItems: orderItems,
                  ),
                  Text(
                    AppLocalizations.of(context)!.writen_review,
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: reviewController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: Validator.validateRequired,
                    focusNode: FocusNode(),
                    keyboardType: TextInputType.text,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: AppLocalizations.of(context)!.hint_review,
                      labelText: AppLocalizations.of(context)!.input_feedback,
                      hintStyle: Theme.of(context).textTheme.bodySmall,
                      border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  BlocConsumer<OrderCubit, OrderState>(
                    listenWhen: (_, newState) {
                      return newState is OrderAddReviewFailedState ||
                          newState is OrderAddReviewSuccessState;
                    },
                    buildWhen: (_, newState) {
                      return newState is OrderAddReviewFailedState ||
                          newState is OrderAddReviewSuccessState ||
                          newState is OrderAddReviewLoadingState;
                    },
                    listener: (context, state) {
                      if (state is OrderAddReviewFailedState) {
                        showSnackBar(
                          context: context,
                          title: 'Oops!',
                          message: state.message,
                          snackbarType: SnackbarType.error,
                        );
                      }
                      if (state is OrderAddReviewSuccessState) {
                        context.pop();
                        showSnackBar(
                          context: context,
                          title: 'Review Rated Successfully',
                          message: 'Thank you for rating our service.',
                          snackbarType: SnackbarType.error,
                        );
                      }
                    },
                    builder: (context, state) {
                      return Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: AppButton(
                            isLoading: state is OrderAddReviewLoadingState,
                            buttonText: AppLocalizations.of(context)!.submit,
                            onPressed: () async {
                              await context.read<OrderCubit>().addReview(
                                    orderDetailId: widget.orderItemId,
                                    appRating: reviewNotifier.value.values
                                        .elementAt(0)
                                        .toInt()
                                        .toString(),
                                    productRating: reviewNotifier.value.values
                                        .elementAt(1)
                                        .toInt()
                                        .toString(),
                                    orderRating: reviewNotifier.value.values
                                        .elementAt(2)
                                        .toInt()
                                        .toString(),
                                    paymentRaing: reviewNotifier.value.values
                                        .elementAt(3)
                                        .toInt()
                                        .toString(),
                                    overall: reviewNotifier.value.values
                                        .elementAt(4)
                                        .toInt()
                                        .toString(),
                                    comment: reviewController.text.trim(),
                                  );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
