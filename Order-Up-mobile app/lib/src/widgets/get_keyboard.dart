import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class GetKeyboard {
  GetKeyboard(this.context);

  final BuildContext context;
  String _firstDigit = '';
  String _secondDigit = '';
  String _thirdDigit = '';
  String _fourthDigit = '';
  String _fifthDigit = '';
  String _sixthDigit = '';

  int? _currentDigit;

  String otp = '';

  // Return "OTP" input field
  Row get getInputField {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        _otpTextField(_firstDigit),
        _otpTextField(_secondDigit),
        _otpTextField(_thirdDigit),
        _otpTextField(_fourthDigit),
        _otpTextField(_fifthDigit),
        _otpTextField(_sixthDigit),
      ],
    );
  }

  // Returns "Otp custom text field"
  Widget _otpTextField(String digit) {
    return Expanded(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40.0,
        margin: const EdgeInsets.all(4.0),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: digit.isEmpty
                ? const Color(0xFFFFD8BC)
                : Theme.of(context).primaryColor, // red as border color
          ),
          color: digit.isEmpty
              ? AppColor.accentColor.withOpacity(0.2)
              : Colors.white,
        ),
        child: Text(
          digit,
          style: const TextStyle(
            fontSize: 18.0,
            color: AppColor.textColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  get getOtpKeyboard {
    return Container(
      margin: const EdgeInsets.only(top: 5.0),
      height: MediaQuery.of(context).size.height * 0.4,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: '1',
                    onPressed: () {
                      _setCurrentDigit(1);
                    }),
                _otpKeyboardInputButton(
                    label: '2',
                    onPressed: () {
                      _setCurrentDigit(2);
                    }),
                _otpKeyboardInputButton(
                    label: '3',
                    onPressed: () {
                      _setCurrentDigit(3);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: '4',
                    onPressed: () {
                      _setCurrentDigit(4);
                    }),
                _otpKeyboardInputButton(
                    label: '5',
                    onPressed: () {
                      _setCurrentDigit(5);
                    }),
                _otpKeyboardInputButton(
                    label: '6',
                    onPressed: () {
                      _setCurrentDigit(6);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: '7',
                    onPressed: () {
                      _setCurrentDigit(7);
                    }),
                _otpKeyboardInputButton(
                    label: '8',
                    onPressed: () {
                      _setCurrentDigit(8);
                    }),
                _otpKeyboardInputButton(
                    label: '9',
                    onPressed: () {
                      _setCurrentDigit(9);
                    }),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _otpKeyboardInputButton(
                    label: '0',
                    onPressed: () {
                      _setCurrentDigit(0);
                    }),
                _otpKeyboardActionButton(
                    label: const Icon(
                      Icons.backspace,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      if (_sixthDigit.isNotEmpty) {
                        _sixthDigit = '';
                      } else if (_fifthDigit.isNotEmpty) {
                        _fifthDigit = '';
                      } else if (_fourthDigit.isNotEmpty) {
                        _fourthDigit = '';
                      } else if (_thirdDigit.isNotEmpty) {
                        _thirdDigit = '';
                      } else if (_secondDigit.isNotEmpty) {
                        _secondDigit = '';
                      } else {
                        _firstDigit = '';
                      }
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Returns "Otp keyboard input Button"
  Widget _otpKeyboardInputButton({String? label, VoidCallback? onPressed}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(40.0),
        child: Container(
          height: 80.0,
          width: 80.0,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              label!,
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Returns "Otp keyboard action Button"
  _otpKeyboardActionButton({Widget? label, VoidCallback? onPressed}) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(40.0),
      child: Container(
        height: 80.0,
        width: 80.0,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Center(
          child: label,
        ),
      ),
    );
  }

  // Current digit
  void _setCurrentDigit(int i) {
    _currentDigit = i;
    if (_firstDigit.isEmpty) {
      _firstDigit = _currentDigit!.toString();
    } else if (_secondDigit.isEmpty) {
      _secondDigit = _currentDigit!.toString();
    } else if (_thirdDigit.isEmpty) {
      _thirdDigit = _currentDigit!.toString();
    } else if (_fourthDigit.isEmpty) {
      _fourthDigit = _currentDigit!.toString();
    } else if (_fifthDigit.isEmpty) {
      _fifthDigit = _currentDigit!.toString();
    } else if (_sixthDigit.isEmpty) {
      _sixthDigit = _currentDigit!.toString();

      otp = _firstDigit.toString() +
          _secondDigit.toString() +
          _thirdDigit.toString() +
          _fourthDigit.toString() +
          _fifthDigit.toString() +
          _sixthDigit.toString();
    }
  }
}
