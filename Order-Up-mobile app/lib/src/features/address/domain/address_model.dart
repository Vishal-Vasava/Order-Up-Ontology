class AddressModel {
  AddressModel({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.emailId,
    required this.address,
    required this.zipcode,
    required this.city,
    required this.state,
    required this.country,
    required this.streetNo,
    required this.flatNo,
    required this.addLatitude,
    required this.addLongitude,
    required this.addressType,
    required this.isDefault,
  });

  final String firstName;
  final String lastName;
  final String mobile;
  final String emailId;
  final String address;
  final String zipcode;
  final String city;
  final String state;
  final String country;
  final String streetNo;
  final String flatNo;
  final String addLatitude;
  final String addLongitude;
  final String addressType;
  final bool isDefault;

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'email': emailId,
        'phone': mobile,
        'latitude': addLatitude,
        'longitude': addLongitude,
        'house_no': flatNo,
        'address': address,
        'street': streetNo,
        'zip_code': zipcode,
        'city': city,
        'state': state,
        'country': country,
        'type': addressType,
        'is_default': isDefault.toString(),
      };
}
