import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'localization/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en')
  ];

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @producer.
  ///
  /// In en, this message translates to:
  /// **'Producers'**
  String get producer;

  /// No description provided for @my_order.
  ///
  /// In en, this message translates to:
  /// **'My Orders'**
  String get my_order;

  /// No description provided for @orders.
  ///
  /// In en, this message translates to:
  /// **'Orders'**
  String get orders;

  /// No description provided for @inventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventory;

  /// No description provided for @claims.
  ///
  /// In en, this message translates to:
  /// **'Claims'**
  String get claims;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @refresh_cart.
  ///
  /// In en, this message translates to:
  /// **'Please refresh the cart'**
  String get refresh_cart;

  /// No description provided for @please_select_option.
  ///
  /// In en, this message translates to:
  /// **'Please select one option'**
  String get please_select_option;

  /// No description provided for @message.
  ///
  /// In en, this message translates to:
  /// **'Messages'**
  String get message;

  /// No description provided for @notification.
  ///
  /// In en, this message translates to:
  /// **'Notification'**
  String get notification;

  /// No description provided for @empty_notification.
  ///
  /// In en, this message translates to:
  /// **'No notifications yet'**
  String get empty_notification;

  /// No description provided for @account.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// No description provided for @started.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get started;

  /// No description provided for @first_name.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get first_name;

  /// No description provided for @input_first_name.
  ///
  /// In en, this message translates to:
  /// **'Input your First Name'**
  String get input_first_name;

  /// No description provided for @last_name.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get last_name;

  /// No description provided for @input_last_name.
  ///
  /// In en, this message translates to:
  /// **'Input your Last Name'**
  String get input_last_name;

  /// No description provided for @mobile.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobile;

  /// No description provided for @input_mobile.
  ///
  /// In en, this message translates to:
  /// **'Enter your Mobile Number'**
  String get input_mobile;

  /// No description provided for @dob.
  ///
  /// In en, this message translates to:
  /// **'Date Of Birth'**
  String get dob;

  /// No description provided for @input_dob.
  ///
  /// In en, this message translates to:
  /// **'Input your Date Of Birth'**
  String get input_dob;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Select Gender'**
  String get gender;

  /// No description provided for @zipcode.
  ///
  /// In en, this message translates to:
  /// **'Zipcode'**
  String get zipcode;

  /// No description provided for @input_zipcode.
  ///
  /// In en, this message translates to:
  /// **'Input your Zipcode'**
  String get input_zipcode;

  /// No description provided for @street.
  ///
  /// In en, this message translates to:
  /// **'Street'**
  String get street;

  /// No description provided for @input_Street.
  ///
  /// In en, this message translates to:
  /// **'Input your Street No.'**
  String get input_Street;

  /// No description provided for @flat.
  ///
  /// In en, this message translates to:
  /// **'House/Flat No.'**
  String get flat;

  /// No description provided for @input_flat.
  ///
  /// In en, this message translates to:
  /// **'Input your House/Flat No.'**
  String get input_flat;

  /// No description provided for @price.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get price;

  /// No description provided for @input_price.
  ///
  /// In en, this message translates to:
  /// **'Input your Price'**
  String get input_price;

  /// No description provided for @input_reason.
  ///
  /// In en, this message translates to:
  /// **'Enter Reason'**
  String get input_reason;

  /// No description provided for @upload_image.
  ///
  /// In en, this message translates to:
  /// **'Upload Picture'**
  String get upload_image;

  /// No description provided for @full_name.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get full_name;

  /// No description provided for @input_full_name.
  ///
  /// In en, this message translates to:
  /// **'Input your Full Name'**
  String get input_full_name;

  /// No description provided for @product_review.
  ///
  /// In en, this message translates to:
  /// **'Write a product Review'**
  String get product_review;

  /// No description provided for @writen_review.
  ///
  /// In en, this message translates to:
  /// **'Add a written review'**
  String get writen_review;

  /// No description provided for @hint_review.
  ///
  /// In en, this message translates to:
  /// **'What did you like or dislike?What are the areas  we need improvement?'**
  String get hint_review;

  /// No description provided for @return_replace.
  ///
  /// In en, this message translates to:
  /// **'Return Request or Replace item'**
  String get return_replace;

  /// No description provided for @track_order.
  ///
  /// In en, this message translates to:
  /// **'Track Order'**
  String get track_order;

  /// No description provided for @invoice.
  ///
  /// In en, this message translates to:
  /// **'Download Invoice'**
  String get invoice;

  /// No description provided for @performance.
  ///
  /// In en, this message translates to:
  /// **'Performance & Quality'**
  String get performance;

  /// No description provided for @damage.
  ///
  /// In en, this message translates to:
  /// **'Product Damage'**
  String get damage;

  /// No description provided for @item_arrived.
  ///
  /// In en, this message translates to:
  /// **'Item arrived too late'**
  String get item_arrived;

  /// No description provided for @wrong_item.
  ///
  /// In en, this message translates to:
  /// **'Wrong item sent'**
  String get wrong_item;

  /// No description provided for @extra_item.
  ///
  /// In en, this message translates to:
  /// **'Received extra item.I didn\'t buy'**
  String get extra_item;

  /// No description provided for @input_religion.
  ///
  /// In en, this message translates to:
  /// **'Input your religion'**
  String get input_religion;

  /// No description provided for @loc.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get loc;

  /// No description provided for @input_loc.
  ///
  /// In en, this message translates to:
  /// **'Input your Location'**
  String get input_loc;

  /// No description provided for @last30days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 days'**
  String get last30days;

  /// No description provided for @last60days.
  ///
  /// In en, this message translates to:
  /// **'Last 60 days'**
  String get last60days;

  /// No description provided for @year_2020.
  ///
  /// In en, this message translates to:
  /// **'2020'**
  String get year_2020;

  /// No description provided for @year_2021.
  ///
  /// In en, this message translates to:
  /// **'2021'**
  String get year_2021;

  /// No description provided for @older.
  ///
  /// In en, this message translates to:
  /// **'Older'**
  String get older;

  /// No description provided for @accepted.
  ///
  /// In en, this message translates to:
  /// **'Order Accepted'**
  String get accepted;

  /// No description provided for @notified.
  ///
  /// In en, this message translates to:
  /// **'Producer notified'**
  String get notified;

  /// No description provided for @reserved.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Reserved'**
  String get reserved;

  /// No description provided for @onItsWay.
  ///
  /// In en, this message translates to:
  /// **'Vehicle is on its way'**
  String get onItsWay;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Job Completed'**
  String get completed;

  /// No description provided for @chargeable_delivery.
  ///
  /// In en, this message translates to:
  /// **'Urgent Delivery - '**
  String get chargeable_delivery;

  /// No description provided for @free_delivery.
  ///
  /// In en, this message translates to:
  /// **'Planned Schedule of Service - '**
  String get free_delivery;

  /// No description provided for @choose_date.
  ///
  /// In en, this message translates to:
  /// **'Choose Delivery date'**
  String get choose_date;

  /// No description provided for @cont_facebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with facebook'**
  String get cont_facebook;

  /// No description provided for @cont_google.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get cont_google;

  /// No description provided for @cont_apple.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Apple'**
  String get cont_apple;

  /// No description provided for @login_phone.
  ///
  /// In en, this message translates to:
  /// **'Login with Phone Number'**
  String get login_phone;

  /// No description provided for @continue_guest.
  ///
  /// In en, this message translates to:
  /// **'Continue as Guest'**
  String get continue_guest;

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'By signing up, you confirm that you agree to our '**
  String get terms;

  /// No description provided for @terms_pro.
  ///
  /// In en, this message translates to:
  /// **'If you are not enrolled with OrderUp, email '**
  String get terms_pro;

  /// No description provided for @input_expectation.
  ///
  /// In en, this message translates to:
  /// **'Input your Expectation'**
  String get input_expectation;

  /// No description provided for @create_account.
  ///
  /// In en, this message translates to:
  /// **'Create Account To Continue'**
  String get create_account;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get help;

  /// No description provided for @faq.
  ///
  /// In en, this message translates to:
  /// **'FAQ'**
  String get faq;

  /// No description provided for @terms_of_use.
  ///
  /// In en, this message translates to:
  /// **'Terms Of Use'**
  String get terms_of_use;

  /// No description provided for @privacy_policy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacy_policy;

  /// No description provided for @delete_account.
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get delete_account;

  /// No description provided for @always_on.
  ///
  /// In en, this message translates to:
  /// **'Always On'**
  String get always_on;

  /// No description provided for @always_off.
  ///
  /// In en, this message translates to:
  /// **'Always Off'**
  String get always_off;

  /// No description provided for @about_us.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get about_us;

  /// No description provided for @app_exp.
  ///
  /// In en, this message translates to:
  /// **'App Experience'**
  String get app_exp;

  /// No description provided for @vehicle_quality.
  ///
  /// In en, this message translates to:
  /// **'Vehicle quality'**
  String get vehicle_quality;

  /// No description provided for @product_quality.
  ///
  /// In en, this message translates to:
  /// **'Product quality'**
  String get product_quality;

  /// No description provided for @drive_exp.
  ///
  /// In en, this message translates to:
  /// **'Drive Experience'**
  String get drive_exp;

  /// No description provided for @order_exp.
  ///
  /// In en, this message translates to:
  /// **'Order Experience'**
  String get order_exp;

  /// No description provided for @pay_exp.
  ///
  /// In en, this message translates to:
  /// **'Payment Experience'**
  String get pay_exp;

  /// No description provided for @overall.
  ///
  /// In en, this message translates to:
  /// **'Overall'**
  String get overall;

  /// No description provided for @pay_option.
  ///
  /// In en, this message translates to:
  /// **'Select Payment Option'**
  String get pay_option;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @country.
  ///
  /// In en, this message translates to:
  /// **'Country'**
  String get country;

  /// No description provided for @state.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get state;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search ...'**
  String get search;

  /// No description provided for @category_not_found.
  ///
  /// In en, this message translates to:
  /// **'Category not found'**
  String get category_not_found;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @change_password.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get change_password;

  /// No description provided for @input_your_password.
  ///
  /// In en, this message translates to:
  /// **'Input your password'**
  String get input_your_password;

  /// No description provided for @confirm_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirm_password;

  /// No description provided for @confirm_your_password.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get confirm_your_password;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @type_something.
  ///
  /// In en, this message translates to:
  /// **'Type Something...'**
  String get type_something;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @contact_us.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contact_us;

  /// No description provided for @send.
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @input_name.
  ///
  /// In en, this message translates to:
  /// **'Input your name'**
  String get input_name;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @input_email.
  ///
  /// In en, this message translates to:
  /// **'Input your email'**
  String get input_email;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @input_information.
  ///
  /// In en, this message translates to:
  /// **'Input your information'**
  String get input_information;

  /// No description provided for @value_not_empty.
  ///
  /// In en, this message translates to:
  /// **'Input should not be empty'**
  String get value_not_empty;

  /// No description provided for @value_not_valid_range.
  ///
  /// In en, this message translates to:
  /// **'Input not valid range'**
  String get value_not_valid_range;

  /// No description provided for @value_not_valid_email.
  ///
  /// In en, this message translates to:
  /// **'Input not valid email'**
  String get value_not_valid_email;

  /// No description provided for @value_not_valid_phone.
  ///
  /// In en, this message translates to:
  /// **'Input not valid phone'**
  String get value_not_valid_phone;

  /// No description provided for @value_not_valid_password.
  ///
  /// In en, this message translates to:
  /// **'Input not valid password'**
  String get value_not_valid_password;

  /// No description provided for @value_not_valid_id.
  ///
  /// In en, this message translates to:
  /// **'Input not valid ID'**
  String get value_not_valid_id;

  /// No description provided for @edit_profile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get edit_profile;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @input_address.
  ///
  /// In en, this message translates to:
  /// **'Input your address'**
  String get input_address;

  /// No description provided for @pincode.
  ///
  /// In en, this message translates to:
  /// **'Pincode'**
  String get pincode;

  /// No description provided for @input_pincode.
  ///
  /// In en, this message translates to:
  /// **'Input your Pincode'**
  String get input_pincode;

  /// No description provided for @website.
  ///
  /// In en, this message translates to:
  /// **'Website'**
  String get website;

  /// No description provided for @verify_number.
  ///
  /// In en, this message translates to:
  /// **'Verify Number'**
  String get verify_number;

  /// No description provided for @otp_verification.
  ///
  /// In en, this message translates to:
  /// **'Please enter the OTP shared on '**
  String get otp_verification;

  /// No description provided for @otp_verification_msg.
  ///
  /// In en, this message translates to:
  /// **'number'**
  String get otp_verification_msg;

  /// No description provided for @input_website.
  ///
  /// In en, this message translates to:
  /// **'Input your website'**
  String get input_website;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @replay.
  ///
  /// In en, this message translates to:
  /// **'Replay'**
  String get replay;

  /// No description provided for @tap_rate.
  ///
  /// In en, this message translates to:
  /// **'Tap a star to rate'**
  String get tap_rate;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @input_title.
  ///
  /// In en, this message translates to:
  /// **'Input your title'**
  String get input_title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @input_desc.
  ///
  /// In en, this message translates to:
  /// **'Input your description'**
  String get input_desc;

  /// No description provided for @input_rate.
  ///
  /// In en, this message translates to:
  /// **'Input your Rate'**
  String get input_rate;

  /// No description provided for @items.
  ///
  /// In en, this message translates to:
  /// **'No. of Items'**
  String get items;

  /// No description provided for @input_items.
  ///
  /// In en, this message translates to:
  /// **'Input your no.of items'**
  String get input_items;

  /// No description provided for @input_feedback.
  ///
  /// In en, this message translates to:
  /// **'Input your feedback'**
  String get input_feedback;

  /// No description provided for @filter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get filter;

  /// No description provided for @facilities.
  ///
  /// In en, this message translates to:
  /// **'Facilities'**
  String get facilities;

  /// No description provided for @area.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get area;

  /// No description provided for @select_location.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get select_location;

  /// No description provided for @select_image.
  ///
  /// In en, this message translates to:
  /// **'Please select an image.'**
  String get select_image;

  /// No description provided for @price_range.
  ///
  /// In en, this message translates to:
  /// **'Price Range'**
  String get price_range;

  /// No description provided for @avg_price.
  ///
  /// In en, this message translates to:
  /// **'AVG Price'**
  String get avg_price;

  /// No description provided for @business_color.
  ///
  /// In en, this message translates to:
  /// **'Business Color'**
  String get business_color;

  /// No description provided for @open_time.
  ///
  /// In en, this message translates to:
  /// **'Open Time'**
  String get open_time;

  /// No description provided for @start_time.
  ///
  /// In en, this message translates to:
  /// **'Start Time'**
  String get start_time;

  /// No description provided for @end_time.
  ///
  /// In en, this message translates to:
  /// **'End Time'**
  String get end_time;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @font.
  ///
  /// In en, this message translates to:
  /// **'Font'**
  String get font;

  /// No description provided for @forgot_password.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password'**
  String get forgot_password;

  /// No description provided for @reset_password.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get reset_password;

  /// No description provided for @search_location.
  ///
  /// In en, this message translates to:
  /// **'Search Business'**
  String get search_location;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get more;

  /// No description provided for @popular_location.
  ///
  /// In en, this message translates to:
  /// **'Popular Location'**
  String get popular_location;

  /// No description provided for @let_find_interesting.
  ///
  /// In en, this message translates to:
  /// **'Let find out what most interesting things'**
  String get let_find_interesting;

  /// No description provided for @recent_location.
  ///
  /// In en, this message translates to:
  /// **'Recent Location'**
  String get recent_location;

  /// No description provided for @what_happen.
  ///
  /// In en, this message translates to:
  /// **'What’s that could happen'**
  String get what_happen;

  /// No description provided for @business_list_out.
  ///
  /// In en, this message translates to:
  /// **'Business List out'**
  String get business_list_out;

  /// No description provided for @business_intro.
  ///
  /// In en, this message translates to:
  /// **'Enlist your business on the app and increase your customer outreach.'**
  String get business_intro;

  /// No description provided for @review_and_rating.
  ///
  /// In en, this message translates to:
  /// **'Review and rating'**
  String get review_and_rating;

  /// No description provided for @review_and_rating_intro.
  ///
  /// In en, this message translates to:
  /// **'Get authentic reviews and ratings for your business by customers to know your progress.'**
  String get review_and_rating_intro;

  /// No description provided for @location_.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location_;

  /// No description provided for @location_intro.
  ///
  /// In en, this message translates to:
  /// **'Your one-stop solution for the requirements business locality.'**
  String get location_intro;

  /// No description provided for @lasted_post.
  ///
  /// In en, this message translates to:
  /// **'Lasted Post'**
  String get lasted_post;

  /// No description provided for @oldest_post.
  ///
  /// In en, this message translates to:
  /// **'Oldest Post'**
  String get oldest_post;

  /// No description provided for @most_view.
  ///
  /// In en, this message translates to:
  /// **'Most Views'**
  String get most_view;

  /// No description provided for @review_rating.
  ///
  /// In en, this message translates to:
  /// **'Review Rating'**
  String get review_rating;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @image.
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get image;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @date_established.
  ///
  /// In en, this message translates to:
  /// **'Date Established'**
  String get date_established;

  /// No description provided for @featured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get featured;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @nearly.
  ///
  /// In en, this message translates to:
  /// **'Nearly'**
  String get nearly;

  /// No description provided for @related.
  ///
  /// In en, this message translates to:
  /// **'Related'**
  String get related;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @sign_in.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get sign_in;

  /// No description provided for @sign_out.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get sign_out;

  /// No description provided for @setting.
  ///
  /// In en, this message translates to:
  /// **'Setting'**
  String get setting;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Reviews'**
  String get review;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @out_of.
  ///
  /// In en, this message translates to:
  /// **'Out of'**
  String get out_of;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @search_title.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search_title;

  /// No description provided for @search_history.
  ///
  /// In en, this message translates to:
  /// **'Search History'**
  String get search_history;

  /// No description provided for @discover_more.
  ///
  /// In en, this message translates to:
  /// **'Discover More'**
  String get discover_more;

  /// No description provided for @recently_viewed.
  ///
  /// In en, this message translates to:
  /// **'Recently Viewed'**
  String get recently_viewed;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @post.
  ///
  /// In en, this message translates to:
  /// **'Post'**
  String get post;

  /// No description provided for @follower.
  ///
  /// In en, this message translates to:
  /// **'Follower'**
  String get follower;

  /// No description provided for @sign_up.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get sign_up;

  /// No description provided for @sign_up_account.
  ///
  /// In en, this message translates to:
  /// **'Dont have an Account ? '**
  String get sign_up_account;

  /// No description provided for @sign_up_as_vendor.
  ///
  /// In en, this message translates to:
  /// **'Sign Up As Vendor'**
  String get sign_up_as_vendor;

  /// No description provided for @sign_in_as_vendor.
  ///
  /// In en, this message translates to:
  /// **'Sign In As Vendor'**
  String get sign_in_as_vendor;

  /// No description provided for @input_id.
  ///
  /// In en, this message translates to:
  /// **'Input your username'**
  String get input_id;

  /// No description provided for @default_text.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get default_text;

  /// No description provided for @order_detail.
  ///
  /// In en, this message translates to:
  /// **'Order Detail'**
  String get order_detail;

  /// No description provided for @brown.
  ///
  /// In en, this message translates to:
  /// **'Brown'**
  String get brown;

  /// No description provided for @pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// No description provided for @orange.
  ///
  /// In en, this message translates to:
  /// **'Orange'**
  String get orange;

  /// No description provided for @green.
  ///
  /// In en, this message translates to:
  /// **'Green'**
  String get green;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @darkorange.
  ///
  /// In en, this message translates to:
  /// **'Dark Orange'**
  String get darkorange;

  /// No description provided for @darkgreen.
  ///
  /// In en, this message translates to:
  /// **'Dark Green'**
  String get darkgreen;

  /// No description provided for @darkblue.
  ///
  /// In en, this message translates to:
  /// **'Dark Blue'**
  String get darkblue;

  /// No description provided for @mon.
  ///
  /// In en, this message translates to:
  /// **'Monday'**
  String get mon;

  /// No description provided for @tue.
  ///
  /// In en, this message translates to:
  /// **'Tuesday'**
  String get tue;

  /// No description provided for @wed.
  ///
  /// In en, this message translates to:
  /// **'Wednesday'**
  String get wed;

  /// No description provided for @thu.
  ///
  /// In en, this message translates to:
  /// **'Thursday'**
  String get thu;

  /// No description provided for @fri.
  ///
  /// In en, this message translates to:
  /// **'Friday'**
  String get fri;

  /// No description provided for @sat.
  ///
  /// In en, this message translates to:
  /// **'Saturday'**
  String get sat;

  /// No description provided for @sun.
  ///
  /// In en, this message translates to:
  /// **'Sunday'**
  String get sun;

  /// No description provided for @day_off.
  ///
  /// In en, this message translates to:
  /// **'Day Off'**
  String get day_off;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @pull_down_refresh.
  ///
  /// In en, this message translates to:
  /// **'Pull down refresh'**
  String get pull_down_refresh;

  /// No description provided for @refreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing...'**
  String get refreshing;

  /// No description provided for @refresh_completed.
  ///
  /// In en, this message translates to:
  /// **'Refresh completed'**
  String get refresh_completed;

  /// No description provided for @release_to_refresh.
  ///
  /// In en, this message translates to:
  /// **'Release to refresh'**
  String get release_to_refresh;

  /// No description provided for @release_to_load_more.
  ///
  /// In en, this message translates to:
  /// **'Release to load more'**
  String get release_to_load_more;

  /// No description provided for @pull_to_load_more.
  ///
  /// In en, this message translates to:
  /// **'Pull up to load more'**
  String get pull_to_load_more;

  /// No description provided for @explore_product.
  ///
  /// In en, this message translates to:
  /// **'Explore Product'**
  String get explore_product;

  /// No description provided for @view_list.
  ///
  /// In en, this message translates to:
  /// **'View List'**
  String get view_list;

  /// No description provided for @list_is_empty.
  ///
  /// In en, this message translates to:
  /// **'List is Empty'**
  String get list_is_empty;

  /// No description provided for @cannot_connect_to_server.
  ///
  /// In en, this message translates to:
  /// **'Can\'t connect to server'**
  String get cannot_connect_to_server;

  /// No description provided for @reload.
  ///
  /// In en, this message translates to:
  /// **'Reload'**
  String get reload;

  /// No description provided for @payment_msg.
  ///
  /// In en, this message translates to:
  /// **'Please pay to obtain seamless service.'**
  String get payment_msg;

  /// No description provided for @change_password_success.
  ///
  /// In en, this message translates to:
  /// **'Change password success'**
  String get change_password_success;

  /// No description provided for @forgot_password_success.
  ///
  /// In en, this message translates to:
  /// **'We have sent password reset link to your email,please check your inbox/spam folder'**
  String get forgot_password_success;

  /// No description provided for @location_is_empty.
  ///
  /// In en, this message translates to:
  /// **'Location not found'**
  String get location_is_empty;

  /// No description provided for @review_not_found.
  ///
  /// In en, this message translates to:
  /// **'Review not found'**
  String get review_not_found;

  /// No description provided for @post_date_desc.
  ///
  /// In en, this message translates to:
  /// **'Lastest Post'**
  String get post_date_desc;

  /// No description provided for @post_date_asc.
  ///
  /// In en, this message translates to:
  /// **'Oldest Post'**
  String get post_date_asc;

  /// No description provided for @comment_count_desc.
  ///
  /// In en, this message translates to:
  /// **'Most Views'**
  String get comment_count_desc;

  /// No description provided for @auth_reset_password.
  ///
  /// In en, this message translates to:
  /// **'User not found. Please correct your email again'**
  String get auth_reset_password;

  /// No description provided for @incorrect_password.
  ///
  /// In en, this message translates to:
  /// **'The username or password is incorrect'**
  String get incorrect_password;

  /// No description provided for @auth_register_error.
  ///
  /// In en, this message translates to:
  /// **'Email already exists, Please use other email'**
  String get auth_register_error;

  /// No description provided for @register_success.
  ///
  /// In en, this message translates to:
  /// **'Register Successfully'**
  String get register_success;

  /// No description provided for @cannot_make_action.
  ///
  /// In en, this message translates to:
  /// **'Can\'t make action with data'**
  String get cannot_make_action;

  /// No description provided for @remove.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @listing.
  ///
  /// In en, this message translates to:
  /// **'Listing'**
  String get listing;

  /// No description provided for @value_not_match.
  ///
  /// In en, this message translates to:
  /// **'Confirm value not matching'**
  String get value_not_match;

  /// No description provided for @rate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get rate;

  /// No description provided for @error_update_wishlist.
  ///
  /// In en, this message translates to:
  /// **'Please login with user to add product to wishlist.'**
  String get error_update_wishlist;

  /// No description provided for @are_you_customer.
  ///
  /// In en, this message translates to:
  /// **'Are you a Customer or Store Manager?'**
  String get are_you_customer;

  /// No description provided for @choice_screen.
  ///
  /// In en, this message translates to:
  /// **'Continue As'**
  String get choice_screen;

  /// No description provided for @hi.
  ///
  /// In en, this message translates to:
  /// **'Hi!'**
  String get hi;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @manager.
  ///
  /// In en, this message translates to:
  /// **'Store Manager'**
  String get manager;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @log_out.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get log_out;

  /// No description provided for @otp_verify.
  ///
  /// In en, this message translates to:
  /// **'OTP Verification'**
  String get otp_verify;

  /// No description provided for @verify.
  ///
  /// In en, this message translates to:
  /// **'Verify'**
  String get verify;

  /// No description provided for @sub_total.
  ///
  /// In en, this message translates to:
  /// **'Sub Total'**
  String get sub_total;

  /// No description provided for @urgent_amount.
  ///
  /// In en, this message translates to:
  /// **'Urget Delivery Amount'**
  String get urgent_amount;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @mark_delivered.
  ///
  /// In en, this message translates to:
  /// **'Mark as Delivered'**
  String get mark_delivered;

  /// No description provided for @select_delivery_option.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Option *'**
  String get select_delivery_option;

  /// No description provided for @choose_delivery_option.
  ///
  /// In en, this message translates to:
  /// **'Choose Delivery Option'**
  String get choose_delivery_option;

  /// No description provided for @select_delivery_slot.
  ///
  /// In en, this message translates to:
  /// **'Select Delivery Slot'**
  String get select_delivery_slot;

  /// No description provided for @schedule_delivery_for.
  ///
  /// In en, this message translates to:
  /// **'Scheduled delivery for -'**
  String get schedule_delivery_for;

  /// No description provided for @choose_delivery_time.
  ///
  /// In en, this message translates to:
  /// **'Choose Delivery time'**
  String get choose_delivery_time;

  /// No description provided for @place_order.
  ///
  /// In en, this message translates to:
  /// **'Place Order'**
  String get place_order;

  /// No description provided for @proceed_pay.
  ///
  /// In en, this message translates to:
  /// **'Proceed to pay'**
  String get proceed_pay;

  /// No description provided for @morning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get morning;

  /// No description provided for @evening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get evening;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @cod.
  ///
  /// In en, this message translates to:
  /// **'Cash on Delivery'**
  String get cod;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @dest_add.
  ///
  /// In en, this message translates to:
  /// **'Destination Address'**
  String get dest_add;

  /// No description provided for @source_add.
  ///
  /// In en, this message translates to:
  /// **'Source Address'**
  String get source_add;

  /// No description provided for @no_data.
  ///
  /// In en, this message translates to:
  /// **'No Data Available'**
  String get no_data;

  /// No description provided for @continue_text.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continue_text;

  /// No description provided for @exit_app.
  ///
  /// In en, this message translates to:
  /// **'Do you want to exit this application?'**
  String get exit_app;

  /// No description provided for @order_success.
  ///
  /// In en, this message translates to:
  /// **'Order Placed Successfully'**
  String get order_success;

  /// No description provided for @add_to_cart.
  ///
  /// In en, this message translates to:
  /// **'Add to Cart'**
  String get add_to_cart;

  /// No description provided for @view_all.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get view_all;

  /// No description provided for @view_less.
  ///
  /// In en, this message translates to:
  /// **'View less'**
  String get view_less;

  /// No description provided for @all_producers.
  ///
  /// In en, this message translates to:
  /// **'All Producers'**
  String get all_producers;

  /// No description provided for @all_categories.
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get all_categories;

  /// No description provided for @quantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get quantity;

  /// No description provided for @con_fee.
  ///
  /// In en, this message translates to:
  /// **'Conveyance Fee'**
  String get con_fee;

  /// No description provided for @ready.
  ///
  /// In en, this message translates to:
  /// **'Ready'**
  String get ready;

  /// No description provided for @view_detail.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get view_detail;

  /// No description provided for @shipped.
  ///
  /// In en, this message translates to:
  /// **'Shipped'**
  String get shipped;

  /// No description provided for @delivered.
  ///
  /// In en, this message translates to:
  /// **'Delivered'**
  String get delivered;

  /// No description provided for @return_and_replace.
  ///
  /// In en, this message translates to:
  /// **'Return & Replace'**
  String get return_and_replace;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Cancelled'**
  String get cancelled;

  /// No description provided for @cancel_reason.
  ///
  /// In en, this message translates to:
  /// **'Cancel Reason'**
  String get cancel_reason;

  /// No description provided for @ship_here.
  ///
  /// In en, this message translates to:
  /// **'Your order will be delivered here'**
  String get ship_here;

  /// No description provided for @location_no_data.
  ///
  /// In en, this message translates to:
  /// **'We are not servicing this zip code at the moment.\nWe will soon expand our operations in your area.'**
  String get location_no_data;

  /// No description provided for @choose_location.
  ///
  /// In en, this message translates to:
  /// **'Choose your location'**
  String get choose_location;

  /// No description provided for @select_delivery_location.
  ///
  /// In en, this message translates to:
  /// **'Select a delivery location to see product availability and delivery options'**
  String get select_delivery_location;

  /// No description provided for @order_pending_status.
  ///
  /// In en, this message translates to:
  /// **'Order Pending'**
  String get order_pending_status;

  /// No description provided for @order_accepted_status.
  ///
  /// In en, this message translates to:
  /// **'Order Accepted'**
  String get order_accepted_status;

  /// No description provided for @order_shipped_status.
  ///
  /// In en, this message translates to:
  /// **'Order Shipped'**
  String get order_shipped_status;

  /// No description provided for @order_delivered_status.
  ///
  /// In en, this message translates to:
  /// **'Order Delivered'**
  String get order_delivered_status;

  /// No description provided for @order_cancelled_status.
  ///
  /// In en, this message translates to:
  /// **'Order Cancelled'**
  String get order_cancelled_status;

  /// No description provided for @return_pending_status.
  ///
  /// In en, this message translates to:
  /// **'Return Order Pending'**
  String get return_pending_status;

  /// No description provided for @return_confirmed_status.
  ///
  /// In en, this message translates to:
  /// **'Return Order Confirmed'**
  String get return_confirmed_status;

  /// No description provided for @return_shipped_status.
  ///
  /// In en, this message translates to:
  /// **'Return Order Shipped'**
  String get return_shipped_status;

  /// No description provided for @return_delivered_status.
  ///
  /// In en, this message translates to:
  /// **'Return Order Delivered'**
  String get return_delivered_status;

  /// No description provided for @return_cancelled_status.
  ///
  /// In en, this message translates to:
  /// **'Return Order Cancelled'**
  String get return_cancelled_status;

  /// No description provided for @replace_pending_status.
  ///
  /// In en, this message translates to:
  /// **'Replace Order Pending'**
  String get replace_pending_status;

  /// No description provided for @replace_confirmed_status.
  ///
  /// In en, this message translates to:
  /// **'Replace Order Confirmed'**
  String get replace_confirmed_status;

  /// No description provided for @replace_shipped_status.
  ///
  /// In en, this message translates to:
  /// **'Replace Order Shipped'**
  String get replace_shipped_status;

  /// No description provided for @replace_delivered_status.
  ///
  /// In en, this message translates to:
  /// **'Replace Order Delivered'**
  String get replace_delivered_status;

  /// No description provided for @replace_cancelled_status.
  ///
  /// In en, this message translates to:
  /// **'Replace Order Cancelled'**
  String get replace_cancelled_status;

  /// No description provided for @return_support_text.
  ///
  /// In en, this message translates to:
  /// **'While we are working on supporting return and replacement of the order, this facility is currently not available. We encourage you to contact us on email. We request you to contact us via email help@order-up.in'**
  String get return_support_text;

  /// No description provided for @help_center_wip.
  ///
  /// In en, this message translates to:
  /// **'Contact us for any help or report a bug. We encourage you to contact us on email : '**
  String get help_center_wip;

  /// No description provided for @cart_address_error.
  ///
  /// In en, this message translates to:
  /// **'Not Available on your address.'**
  String get cart_address_error;

  /// No description provided for @new_text.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get new_text;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
