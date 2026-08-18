import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:orderly_ecom/src/constants/static_text.dart';
import 'package:orderly_ecom/src/features/address/screens/address_screen.dart';
import 'package:orderly_ecom/src/features/address/screens/components/add_address_form.dart';
import 'package:orderly_ecom/src/features/address/screens/components/edit_address_form.dart';
import 'package:orderly_ecom/src/features/address/screens/destination_address_screen.dart';
import 'package:orderly_ecom/src/features/authentication/domain/auth_role_enum.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/features/authentication/screens/delete_account_screen.dart';
import 'package:orderly_ecom/src/features/authentication/screens/new_choice_screen.dart';
import 'package:orderly_ecom/src/features/authentication/screens/new_sign_in_screen.dart';
import 'package:orderly_ecom/src/features/authentication/screens/otp_screen.dart';
import 'package:orderly_ecom/src/features/authentication/screens/sign_up_screen.dart';
import 'package:orderly_ecom/src/features/authentication/screens/splash_screen.dart';
import 'package:orderly_ecom/src/features/authentication/screens/verify_phone_screen.dart';
import 'package:orderly_ecom/src/features/cart/screens/cart_screen.dart';
import 'package:orderly_ecom/src/features/customer/customer_screen.dart';
import 'package:orderly_ecom/src/features/delivery/screens/cubit/delivery_cubit.dart';
import 'package:orderly_ecom/src/features/delivery/screens/delivery_order_detail_screen.dart';
import 'package:orderly_ecom/src/features/delivery/screens/delivery_user_screen.dart';
import 'package:orderly_ecom/src/features/location/screens/location_screen.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/inventory.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/sku_gallery.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/components/inventory_add_form.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/sku/sku_screen.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/customer/create_offers.dart';
import 'package:orderly_ecom/src/features/manager/features/offers/screens/customer/edit_offer.dart';
import 'package:orderly_ecom/src/features/manager/features/orders/screens/components/order_detail_page.dart';
import 'package:orderly_ecom/src/features/manager/manager_screen.dart';
import 'package:orderly_ecom/src/features/navigation_bar/screens/cubit/navigation_cubit.dart';
import 'package:orderly_ecom/src/features/notifications/screens/notification_screen.dart';
import 'package:orderly_ecom/src/features/orders/screens/order_filter_screen.dart';
import 'package:orderly_ecom/src/features/orders/screens/order_product_review.dart';
import 'package:orderly_ecom/src/features/orders/screens/order_return_replace_screen.dart';
import 'package:orderly_ecom/src/features/orders/screens/order_track_screen.dart';
import 'package:orderly_ecom/src/features/other/screens/faq_screen.dart';
import 'package:orderly_ecom/src/features/other/screens/help_screen.dart';
import 'package:orderly_ecom/src/features/other/screens/privacy_policy_screen.dart';
import 'package:orderly_ecom/src/features/other/screens/terms_of_use.dart';
import 'package:orderly_ecom/src/features/payment/screens/payment_screen.dart';
import 'package:orderly_ecom/src/features/payment/screens/thankyou_screen.dart';
import 'package:orderly_ecom/src/features/product/screens/components/product_search_list.dart';
import 'package:orderly_ecom/src/features/product/screens/product_single_list.dart';
import 'package:orderly_ecom/src/features/profile/screens/profile_edit_form.dart';
import 'package:orderly_ecom/src/features/profile/screens/profile_screen.dart';
import 'package:orderly_ecom/src/routes/not_found_screen.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/components/inventory_edit_form.dart';
import 'package:orderly_ecom/src/features/product/screens/product_detail_screen.dart';

import 'package:orderly_ecom/src/features/manager/features/offers/screens/customer/offer_list.dart';
import 'package:orderly_ecom/src/widgets/padding_widget.dart';

enum AppRoute {
  error,
  location,
  choiceScreen,
  signIn,
  verifyPhone,
  otpScreen,
  signUp,
  notificationScreen,
  home,
  deliveryHome,
  deliveryDetailPage,
  managerOrderDetailPage,
  privacyPolicy,
  termsOfUse,
  faqScreen,
  profile,
  editProfile,
  help,
  address,
  addAddress,
  editAddress,
  destinationAddress,
  productAll,
  productDetail,
  search,
  paymentPage,
  orderFilter,
  orderReturnReplace,
  orderReview,
  orderTrack,
  cart,
  deleteAccount,
  inventoryAdd,
  inventoryEdit,
  skuinventory,
  thankYou,
  cancelUrl,
  offerPage,
  addOffer,
  editOffer,
}

extension AppPRouteExtension on AppRoute {
  String get toPath {
    switch (this) {
      case AppRoute.error:
        return '/error';

      case AppRoute.home:
        return '/';
      case AppRoute.choiceScreen:
        return 'store_n_delivery';
      case AppRoute.location:
        return 'location';
      case AppRoute.notificationScreen:
        return 'notifications';

      case AppRoute.signIn:
        return 'signIn';
      case AppRoute.signUp:
        return 'signUp';
      case AppRoute.verifyPhone:
        return 'verifyPhone';
      case AppRoute.otpScreen:
        return 'otpScreen';
      case AppRoute.deliveryHome:
        return '/deliveryHome';
      case AppRoute.deliveryDetailPage:
        return 'detailPage';

      case AppRoute.managerOrderDetailPage:
        return 'orderDetailPage';

      case AppRoute.profile:
        return 'profile';

      case AppRoute.inventoryAdd:
        return 'inventoryAdd';
      case AppRoute.inventoryEdit:
        return 'inventoryEdit';
      case AppRoute.skuinventory:
        return 'skuinventory';

      case AppRoute.productAll:
        return 'productVendor';

      case AppRoute.search:
        return 'search';

      case AppRoute.productDetail:
        return 'productDetail';

      case AppRoute.paymentPage:
        return 'payment';

      case AppRoute.thankYou:
        return 'thankYou';

      case AppRoute.cancelUrl:
        return 'cancel';

      case AppRoute.cart:
        return 'cart';

      case AppRoute.orderFilter:
        return 'orderFilter';

      case AppRoute.editProfile:
        return 'editProfile';

      case AppRoute.deleteAccount:
        return '/deleteAccount';
      case AppRoute.privacyPolicy:
        return '/privacyPolicy';
      case AppRoute.termsOfUse:
        return '/termsOfUse';
      case AppRoute.faqScreen:
        return '/faq';
      case AppRoute.help:
        return '/help';

      case AppRoute.address:
        return '/address';
      case AppRoute.addAddress:
        return 'addAddress';
      case AppRoute.editAddress:
        return 'updateAddress';
      case AppRoute.destinationAddress:
        return 'destinationAddress';

      case AppRoute.orderReturnReplace:
        return 'orderReturnReplace';
      case AppRoute.orderReview:
        return 'orderProductReview';
      case AppRoute.orderTrack:
        return 'trackOrder';

      case AppRoute.offerPage:
        return '/offers';
      case AppRoute.editOffer:
        return 'editOffer';
      case AppRoute.addOffer:
        return 'addOffer';

      default:
        return '/';
    }
  }

  /// NAME SHOULD NOT CONTAIN SPACE
  /// AND CANNOT BE SAME AND PATH NAME
  String get toName {
    switch (this) {
      case AppRoute.error:
        return 'ERROR';
      case AppRoute.choiceScreen:
        return 'CHOICESCREEN';
      case AppRoute.location:
        return 'LOCATION';
      case AppRoute.signIn:
        return 'SIGNIN';
      case AppRoute.signUp:
        return 'SIGNUP';
      case AppRoute.verifyPhone:
        return 'VERIFYPHONE';
      case AppRoute.otpScreen:
        return 'OTPSCREEN';
      case AppRoute.home:
        return 'HOME';
      case AppRoute.deliveryHome:
        return 'DELIVERYHOME';
      case AppRoute.deliveryDetailPage:
        return 'DELIVERYDETAILPAGE';
      case AppRoute.managerOrderDetailPage:
        return 'ManagerDETAILPAGE';
      case AppRoute.profile:
        return 'PROFILE';
      case AppRoute.notificationScreen:
        return 'NOTIFICATIONSCREEN';

      case AppRoute.privacyPolicy:
        return 'PrivacyPolicy';
      case AppRoute.termsOfUse:
        return 'TERMSOFUSER';
      case AppRoute.faqScreen:
        return 'FAQ';
      case AppRoute.help:
        return 'HELP';

      case AppRoute.cart:
        return 'CART';
      case AppRoute.orderFilter:
        return 'orderFilter';

      case AppRoute.address:
        return 'address';
      case AppRoute.addAddress:
        return 'addAddress';
      case AppRoute.editAddress:
        return 'editAddress';
      case AppRoute.destinationAddress:
        return 'destinationAddress';

      case AppRoute.productAll:
        return 'PRODUCTVENDOR';

      case AppRoute.search:
        return 'SEARCh';

      case AppRoute.productDetail:
        return 'PRODUCTDETAIL';

      case AppRoute.paymentPage:
        return 'paymentPage';

      case AppRoute.thankYou:
        return 'THANKYOU';

      case AppRoute.cancelUrl:
        return 'CANCEL';

      case AppRoute.inventoryAdd:
        return 'INVENTORYADD';
      case AppRoute.inventoryEdit:
        return 'INVENTORYEDIT';
      case AppRoute.skuinventory:
        return 'SKUINVENTORY';

      case AppRoute.editProfile:
        return 'EDITPROFILE';
      case AppRoute.deleteAccount:
        return 'DELETEACCOUNT';

      case AppRoute.orderReturnReplace:
        return 'ORDERRETURNREPLACE';
      case AppRoute.orderReview:
        return 'OrderProductReview';
      case AppRoute.orderTrack:
        return 'TRACKORDER';

      case AppRoute.offerPage:
        return 'OfferPage';
      case AppRoute.editOffer:
        return 'EDITOFFER';
      case AppRoute.addOffer:
        return 'AddOffer';

      default:
        return 'HOME';
    }
  }

  String get toTitle {
    switch (this) {
      case AppRoute.choiceScreen:
        return '${StaticText.appName} | Choice Screen';
      case AppRoute.location:
        return '${StaticText.appName} | Location Screen';
      case AppRoute.signIn:
        return '${StaticText.appName} | Log In';
      case AppRoute.home:
        return StaticText.appName;
      case AppRoute.verifyPhone:
        return '${StaticText.appName} | Verify Phone';
      case AppRoute.otpScreen:
        return '${StaticText.appName} | OTP Screen';
      case AppRoute.privacyPolicy:
        return '${StaticText.appName} | Privay Policy';
      case AppRoute.signUp:
        return '${StaticText.appName} | Sign Up';
      case AppRoute.deliveryHome:
        return '${StaticText.appName} | Delivery Dashboard';
      case AppRoute.deliveryDetailPage:
        return '${StaticText.appName} | Delivery Detail';
      case AppRoute.managerOrderDetailPage:
        return '${StaticText.appName} | Delivery Detail';
      case AppRoute.notificationScreen:
        return '${StaticText.appName} | Notifications';

      case AppRoute.inventoryAdd:
        return '${StaticText.appName} | Add Inventory';
      case AppRoute.inventoryEdit:
        return '${StaticText.appName} | Edit Inventory';
      case AppRoute.skuinventory:
        return '${StaticText.appName} | SKU Inventory';

      case AppRoute.editProfile:
        return '${StaticText.appName} | Edit Profile';
      case AppRoute.profile:
        return '${StaticText.appName} | Profile';

      case AppRoute.termsOfUse:
        return '${StaticText.appName} | Terms of User';

      case AppRoute.productAll:
        return '${StaticText.appName} | Product Vendor List';

      case AppRoute.search:
        return '${StaticText.appName} | Product Search';

      case AppRoute.productDetail:
        return '${StaticText.appName} | Product Detail';

      case AppRoute.faqScreen:
        return '${StaticText.appName} | FAQ';

      case AppRoute.cart:
        return '${StaticText.appName} | Cart';

      case AppRoute.help:
        return '${StaticText.appName} | Help';

      case AppRoute.address:
        return '${StaticText.appName} | Address';

      case AppRoute.addAddress:
        return '${StaticText.appName} | Add Address';

      case AppRoute.editAddress:
        return '${StaticText.appName} | Update Address';

      case AppRoute.destinationAddress:
        return '${StaticText.appName} | Destination Address';

      case AppRoute.paymentPage:
        return '${StaticText.appName} | Payment Page';

      case AppRoute.thankYou:
        return '${StaticText.appName} | Thank you for shopping.';

      case AppRoute.cancelUrl:
        return '${StaticText.appName} | Payment Cancelled.';

      case AppRoute.orderFilter:
        return '${StaticText.appName} | Orders Filter';
      case AppRoute.orderReturnReplace:
        return '${StaticText.appName} | Order Return Replace';
      case AppRoute.orderReview:
        return '${StaticText.appName} | Order Review';
      case AppRoute.orderTrack:
        return '${StaticText.appName} | Track Order';
      case AppRoute.deleteAccount:
        return '${StaticText.appName} | Delete Account';
      case AppRoute.offerPage:
        return '${StaticText.appName} | Offers';
      case AppRoute.addOffer:
        return '${StaticText.appName} | Add Offer';
      case AppRoute.editOffer:
        return '${StaticText.appName} | Edit Offers';

      case AppRoute.error:
        return '${StaticText.appName} | Error';
      default:
        return StaticText.appName;
    }
  }
}

final GoRouter goRouter = GoRouter(
  errorBuilder: (context, state) => const NotFoundScreen(),
  initialLocation: AppRoute.home.toPath,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoute.home.toPath,
      name: AppRoute.home.toName,
      builder: (context, state) {
        return BlocConsumer<AuthCubit, AuthState>(
          listenWhen: (oldState, newState) {
            return newState is AuthLoggedOutState ||
                newState is AuthCheckLoadingState ||
                newState is AuthLocationCheckState;
          },
          listener: (context, state) {
            if (state is AuthLoggedOutState) {
              context.read<NavigationCubit>().changeIndex(index: 0);
              context.goNamed(AppRoute.signIn.toPath, params: {
                'role': 'consumer',
              });
            } else if (state is AuthLocationCheckState) {
              context.goNamed(AppRoute.location.toPath);
            }
          },
          builder: (context, authState) {
            if (kIsWeb) {
              // Define MetaSEO object
              MetaSEO meta = MetaSEO();
              // add meta seo data for web app as you want
              meta.seoOGTitle(
                AppRoute.home.toTitle,
              );
              meta.seoDescription('Some large description for Order-Up');
              meta.seoKeywords('Keywords for Order-Up');
            }

            if (authState is AuthLoggedInState) {
              if (authState.user.userType == AuthRole.agent.name ||
                  authState.user.userType == '2') {
                return const PaddingWebWidget(child: DeliveryUserScreen());
              }
              if (authState.user.userType == AuthRole.producer.name ||
                  authState.user.userType == '1') {
                return const ManagerScreen();
              }
              if (authState.user.userType == AuthRole.consumer.name ||
                  authState.user.userType == '0') {
                bool isGuest = false;
                if (state.extra != null) {
                  isGuest = ((state.extra as Map)['isGuest'] as bool);
                }
                return PaddingWebWidget(
                    child: CustomerScreen(isGuest: isGuest));
              }
            }
            if (state is AuthCheckLoadingState) {
              return const PaddingWebWidget(child: SplashScreen());
            }
            return const PaddingWebWidget(child: SplashScreen());
          },
        );
      },
      routes: [
        GoRoute(
          path: AppRoute.location.toPath,
          name: AppRoute.location.toName,
          builder: (context, state) {
            AppRoute.location.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: LocationScreen());
          },
        ),
        GoRoute(
          path: AppRoute.choiceScreen.toPath,
          name: AppRoute.choiceScreen.toName,
          builder: (context, state) {
            AppRoute.choiceScreen.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: NewChoiceScreen());
          },
        ),
        GoRoute(
          path: '${AppRoute.signIn.toPath}/:role',
          name: AppRoute.signIn.toName,
          builder: (context, state) {
            // For Customer we are using flag '0'
            // For Manager we are using flag '1'
            // For Delivery we are using flag '2'
            final String userRole =
                state.params['role'] ?? AuthRole.consumer.name;
            bool isGuest = false;
            if (state.extra != null) {
              isGuest = ((state.extra as Map)['isGuest'] as bool);
            }
            AppRoute.signIn.toTitle.titleOnWeb(context);
            return PaddingWebWidget(
              child: NewSignInScreen(
                userRole: userRole,
                isGuest: isGuest,
              ),
            );
          },
          routes: [
            GoRoute(
              path: AppRoute.verifyPhone.toPath,
              name: AppRoute.verifyPhone.toName,
              builder: (context, state) {
                final String userRole =
                    state.params['role'] ?? AuthRole.consumer.name;
                '${AppRoute.verifyPhone.toTitle} - $userRole'
                    .titleOnWeb(context);
                bool isGuest = false;
                if (state.extra != null) {
                  isGuest = ((state.extra as Map)['isGuest'] as bool);
                }
                return PaddingWebWidget(
                  child: VerifyPhoneScreen(
                    userRole: userRole,
                    isGuest: isGuest,
                  ),
                );
              },
              routes: [
                GoRoute(
                  path: AppRoute.otpScreen.toPath,
                  name: AppRoute.otpScreen.toName,
                  builder: (context, state) {
                    final String userRole =
                        state.params['role'] ?? AuthRole.consumer.name;
                    final String countryCode =
                        state.queryParams['countryCode'] ?? '+91';
                    final String phoneNumber =
                        state.queryParams['phoneNumber'] ?? '0';
                    AppRoute.otpScreen.toTitle.titleOnWeb(context);
                    final bool isGuest =
                        ((state.extra as Map)['isGuest'] as bool);
                    return PaddingWebWidget(
                      child: OtpScreen(
                        userRole: userRole,
                        countryCode: countryCode,
                        phoneNumber: phoneNumber,
                        isGuest: isGuest,
                      ),
                    );
                  },
                ),
                GoRoute(
                  path: AppRoute.signUp.toPath,
                  name: AppRoute.signUp.toName,
                  redirect: (context, state) {
                    // The registration payload is intentionally kept in
                    // navigation state. A browser refresh cannot restore it,
                    // so return to customer login instead of force-casting a
                    // null value and showing Flutter's red error screen.
                    return state.extra is Map
                        ? null
                        : '/${AppRoute.signIn.toPath}/${AuthRole.consumer.name}';
                  },
                  builder: (context, state) {
                    final String userRole =
                        state.params['role'] ?? AuthRole.consumer.name;
                    '${AppRoute.signUp.toTitle} - $userRole'
                        .titleOnWeb(context);
                    final String phoneNumber =
                        (state.extra as Map)['phoneNumber'];
                    final String firebaseId =
                        (state.extra as Map)['firebaseId'] ?? '';
                    final bool isGuest =
                        ((state.extra as Map)['isGuest'] as bool);
                    return PaddingWebWidget(
                      child: SignUpScreen(
                        userRole: userRole,
                        firebaseId: firebaseId,
                        phoneNumber: phoneNumber,
                        isGuest: isGuest,
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        GoRoute(
          path: AppRoute.profile.toPath,
          name: AppRoute.profile.toName,
          builder: (context, state) {
            AppRoute.profile.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: ProfileScreen());
          },
          routes: [
            GoRoute(
              path: AppRoute.editProfile.toPath,
              name: AppRoute.editProfile.toName,
              builder: (context, state) {
                AppRoute.editProfile.toTitle.titleOnWeb(context);
                return const PaddingWebWidget(child: ProfileEditForm());
              },
            ),
          ],
        ),
        GoRoute(
          path: AppRoute.notificationScreen.toPath,
          name: AppRoute.notificationScreen.toName,
          builder: (context, state) {
            AppRoute.notificationScreen.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: NotificationScreen());
          },
        ),

        /// [Delivery User Order Detail Page]
        GoRoute(
          path: '${AppRoute.deliveryDetailPage.toPath}/:orderId',
          name: AppRoute.deliveryDetailPage.toName,
          builder: (context, state) {
            final String orderDetailId = state.params['orderId'] ?? '';
            '${AppRoute.deliveryDetailPage.toTitle} - $orderDetailId'
                .titleOnWeb(context);
            log(context.read<DeliveryCubit>().deliveryList[0].status!,
                name: 'STATUYS >>>>>>>>>>>>>>');
            return PaddingWebWidget(
              child: DeliveryOrderDetailScreen(
                orderDetailId: orderDetailId,
                orderStatus:
                    context.read<DeliveryCubit>().deliveryList[0].status!,
              ),
            );
          },
        ),

        /// [Manager User Order Detail Page]
        GoRoute(
          path:
              '${AppRoute.managerOrderDetailPage.toPath}/:orderNumber/:orderId/:orderStatus',
          name: AppRoute.managerOrderDetailPage.toName,
          builder: (context, state) {
            final String orderDetailId = state.params['orderId'] ?? '';
            final String orderStatus = state.params['orderStatus'] ?? '';
            final String orderNumber = state.params['orderNumber'] ?? '';
            '${AppRoute.managerOrderDetailPage.toTitle} - $orderNumber'
                .titleOnWeb(context);
            return OrderDetailPage(
              orderId: orderDetailId,
              orderNumber: orderNumber,
              orderStatus: orderStatus,
            );
          },
        ),
        GoRoute(
          path: AppRoute.inventoryAdd.toPath,
          name: AppRoute.inventoryAdd.toName,
          builder: (context, state) {
            final galleryList = (state.extra as SkuGalleryItem);
            AppRoute.inventoryAdd.toTitle.titleOnWeb(context);
            return InventoryAddForm(
              galleryList: galleryList,
              fromBack: false,
            );
          },
        ),
        GoRoute(
          path: AppRoute.inventoryEdit.toPath,
          name: AppRoute.inventoryEdit.toName,
          builder: (context, state) {
            AppRoute.inventoryEdit.toTitle.titleOnWeb(context);
            final inventory = (state.extra as InventoryItem);
            return InventoryEditForm(
              inventory: inventory,
            );
          },
        ),
        GoRoute(
          path: AppRoute.skuinventory.toPath,
          name: AppRoute.skuinventory.toName,
          builder: (context, state) {
            AppRoute.skuinventory.toTitle.titleOnWeb(context);
            return const SkuScreen();
          },
        ),
        GoRoute(
          path: '${AppRoute.productAll.toPath}/:index/:categoryId',
          name: AppRoute.productAll.toName,
          builder: (context, state) {
            AppRoute.productAll.toTitle.titleOnWeb(context);
            final String categoryId = state.params['categoryId'] ?? '1';
            final String index = state.params['index'] ?? '0';
            return PaddingWebWidget(
              child: ProductSingleList(
                categoryId: categoryId,
                index: index.parsedString.toInt(),
              ),
            );
          },
        ),
        GoRoute(
          path: '${AppRoute.productDetail.toPath}/:name/:id',
          name: AppRoute.productDetail.toName,
          builder: (context, state) {
            AppRoute.productDetail.toTitle.titleOnWeb(context);
            final String productName = state.params['name'] ?? '-';
            final String productId = state.params['id'] ?? '-';
            return PaddingWebWidget(
              child: ProductDetailScreen(
                productId: productId,
                productName: productName,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.search.toPath,
          name: AppRoute.search.toName,
          builder: (context, state) {
            AppRoute.search.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(
              child: ProductSearchList(),
            );
          },
        ),
        GoRoute(
          path: AppRoute.cart.toPath,
          name: AppRoute.cart.toName,
          builder: (context, state) {
            AppRoute.cart.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: CartScreen());
          },
        ),
        GoRoute(
          path: AppRoute.paymentPage.toPath,
          name: AppRoute.paymentPage.toName,
          builder: (context, state) {
            AppRoute.paymentPage.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: PaymentScreen());
          },
        ),
        GoRoute(
          path: AppRoute.thankYou.toPath,
          name: AppRoute.thankYou.toName,
          builder: (context, state) {
            AppRoute.thankYou.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: ThankyouScreen());
          },
        ),
        GoRoute(
          path: AppRoute.cancelUrl.toPath,
          name: AppRoute.cancelUrl.toName,
          builder: (context, state) {
            AppRoute.cancelUrl.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: PaymentScreen());
          },
        ),
        GoRoute(
          path: AppRoute.orderFilter.toPath,
          name: AppRoute.orderFilter.toName,
          builder: (context, state) {
            AppRoute.orderFilter.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: OrderFilterScreen());
          },
        ),
        GoRoute(
          path: AppRoute.orderReturnReplace.toPath,
          name: AppRoute.orderReturnReplace.toName,
          builder: (context, state) {
            AppRoute.orderReturnReplace.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: OrderReturnReplaceScreen());
          },
        ),
        GoRoute(
          path: '${AppRoute.orderReview.toPath}/:orderId/:orderItemId',
          name: AppRoute.orderReview.toName,
          builder: (context, state) {
            AppRoute.orderReview.toTitle.titleOnWeb(context);
            final String orderId = state.params['orderId'] ?? '-';
            final String orderItemId = state.params['orderItemId'] ?? '-';
            return PaddingWebWidget(
              child: OrderProductReview(
                orderId: orderId,
                orderItemId: orderItemId,
              ),
            );
          },
        ),
        GoRoute(
          path: '${AppRoute.orderTrack.toPath}/:orderId/:orderDetailId',
          name: AppRoute.orderTrack.toName,
          builder: (context, state) {
            AppRoute.orderTrack.toTitle.titleOnWeb(context);
            final String orderId = state.params['orderId'] ?? '-';
            final String orderDetailId = state.params['orderDetailId'] ?? '-';
            return PaddingWebWidget(
              child: OrderTrackScreen(
                orderId: orderId,
                orderDetailId: orderDetailId,
              ),
            );
          },
        ),
      ],
    ),
    // GoRoute(
    //   path: AppRoute.signIn.toPath,
    //   name: AppRoute.signIn.toName,
    //   builder: (context, state) {
    //     // For Customer we are using flag '0'
    //     // For Manager we are using flag '1'
    //     // For Delivery we are using flag '2'
    //     // final String userRole = state.params['role'] ?? AuthRole.consumer.name;
    //     bool isGuest = false;
    //     if (state.extra != null) {
    //       isGuest = ((state.extra as Map)['isGuest'] as bool);
    //     }
    //     AppRoute.signIn.toTitle.titleOnWeb(context);
    //     return PaddingWebWidget(
    //       child: SignInScreen(
    //         isGuest: isGuest,
    //       ),
    //     );
    //   },
    //   routes: [
    //     GoRoute(
    //       path: AppRoute.verifyPhone.toPath,
    //       name: AppRoute.verifyPhone.toName,
    //       builder: (context, state) {
    //         final String userRole =
    //             state.params['role'] ?? AuthRole.consumer.name;
    //         '${AppRoute.verifyPhone.toTitle} - $userRole'.titleOnWeb(context);
    //         bool isGuest = false;
    //         if (state.extra != null) {
    //           isGuest = ((state.extra as Map)['isGuest'] as bool);
    //         }
    //         return PaddingWebWidget(
    //           child: VerifyPhoneScreen(
    //             userRole: userRole,
    //             isGuest: isGuest,
    //           ),
    //         );
    //       },
    //       routes: [
    //         GoRoute(
    //           path: AppRoute.otpScreen.toPath,
    //           name: AppRoute.otpScreen.toName,
    //           builder: (context, state) {
    //             final String userRole =
    //                 state.params['role'] ?? AuthRole.consumer.name;
    //             final String countryCode =
    //                 state.queryParams['countryCode'] ?? '+91';
    //             final String phoneNumber =
    //                 state.queryParams['phoneNumber'] ?? '0';
    //             AppRoute.otpScreen.toTitle.titleOnWeb(context);
    //             final bool isGuest = ((state.extra as Map)['isGuest'] as bool);
    //             return PaddingWebWidget(
    //               child: OtpScreen(
    //                 userRole: userRole,
    //                 countryCode: countryCode,
    //                 phoneNumber: phoneNumber,
    //                 isGuest: isGuest,
    //               ),
    //             );
    //           },
    //         ),
    //         GoRoute(
    //           path: AppRoute.signUp.toPath,
    //           name: AppRoute.signUp.toName,
    //           builder: (context, state) {
    //             final String userRole =
    //                 state.params['role'] ?? AuthRole.consumer.name;
    //             '${AppRoute.signUp.toTitle} - $userRole'.titleOnWeb(context);
    //             final String phoneNumber = (state.extra as Map)['phoneNumber'];
    //             final String firebaseId =
    //                 (state.extra as Map)['firebaseId'] ?? '';
    //             final bool isGuest = ((state.extra as Map)['isGuest'] as bool);
    //             return PaddingWebWidget(
    //               child: SignUpScreen(
    //                 userRole: userRole,
    //                 firebaseId: firebaseId,
    //                 phoneNumber: phoneNumber,
    //                 isGuest: isGuest,
    //               ),
    //             );
    //           },
    //         ),
    //       ],
    //     ),
    //   ],
    // ),
    GoRoute(
      path: AppRoute.privacyPolicy.toPath,
      name: AppRoute.privacyPolicy.toName,
      builder: (context, state) {
        AppRoute.privacyPolicy.toTitle.titleOnWeb(context);
        return const PaddingWebWidget(child: PrivacyPolicyScreen());
      },
    ),
    GoRoute(
      path: AppRoute.deleteAccount.toPath,
      name: AppRoute.deleteAccount.toName,
      builder: (context, state) {
        AppRoute.deleteAccount.toTitle.titleOnWeb(context);
        return const PaddingWebWidget(child: DeleteAccountScreen());
      },
    ),
    GoRoute(
      path: AppRoute.address.toPath,
      name: AppRoute.address.toName,
      builder: (context, state) {
        AppRoute.address.toTitle.titleOnWeb(context);
        return const PaddingWebWidget(child: AddressScreen());
      },
      routes: [
        GoRoute(
          path: AppRoute.addAddress.toPath,
          name: AppRoute.addAddress.toName,
          builder: (context, state) {
            AppRoute.addAddress.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: AddAddressForm());
          },
        ),
        GoRoute(
          path: '${AppRoute.editAddress.toPath}/:addressId',
          name: AppRoute.editAddress.toName,
          builder: (context, state) {
            final String addressId = state.params['addressId'] ?? '';
            AppRoute.editAddress.toTitle.titleOnWeb(context);
            return PaddingWebWidget(
              child: EditAddressForm(
                addressId: addressId,
              ),
            );
          },
        ),
        GoRoute(
          path: AppRoute.destinationAddress.toPath,
          name: AppRoute.destinationAddress.toName,
          builder: (context, state) {
            AppRoute.destinationAddress.toTitle.titleOnWeb(context);
            return const PaddingWebWidget(child: DestinationAddressScreen());
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoute.help.toPath,
      name: AppRoute.help.toName,
      builder: (context, state) {
        AppRoute.help.toTitle.titleOnWeb(context);
        return const PaddingWebWidget(child: HelpScreen());
      },
    ),
    GoRoute(
      path: AppRoute.offerPage.toPath,
      name: AppRoute.offerPage.toName,
      builder: (context, state) {
        AppRoute.offerPage.toTitle.titleOnWeb(context);
        return const OfferList();
      },
      routes: [
        GoRoute(
          path: AppRoute.addOffer.toPath,
          name: AppRoute.addOffer.toName,
          builder: (context, state) {
            AppRoute.addOffer.toTitle.titleOnWeb(context);
            return const CreateOffers();
          },
        ),
        GoRoute(
          path: '${AppRoute.editOffer.toPath}/:offerId',
          name: AppRoute.editOffer.toName,
          builder: (context, state) {
            AppRoute.editOffer.toTitle.titleOnWeb(context);
            final String offerId = state.params['offerId'] ?? '';
            return EditOffers(
              id: offerId,
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: AppRoute.termsOfUse.toPath,
      name: AppRoute.termsOfUse.toName,
      builder: (context, state) {
        AppRoute.termsOfUse.toTitle.titleOnWeb(context);
        return const PaddingWebWidget(child: TermsOfUseScreen());
      },
    ),
    GoRoute(
      path: AppRoute.faqScreen.toPath,
      name: AppRoute.faqScreen.toName,
      builder: (context, state) {
        AppRoute.faqScreen.toTitle.titleOnWeb(context);
        return PaddingWebWidget(child: FaqScreen());
      },
    ),
    GoRoute(
      path: AppRoute.error.toPath,
      name: AppRoute.error.toName,
      builder: (context, state) {
        '${StaticText.appName} - 404'.titleOnWeb(context);
        return const PaddingWebWidget(child: NotFoundScreen());
      },
    ),
  ],
);

void setTitle() {}
