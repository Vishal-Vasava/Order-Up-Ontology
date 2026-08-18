import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/features/location/screens/cubit/location_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class CountryPickerDialog extends StatelessWidget {
  const CountryPickerDialog({super.key});
  static final ValueNotifier<String> countryValue = ValueNotifier<String>('IN');
  static final _countryMap = {
    'IN': 'India',
    'US': 'US',
  };
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text(
          'Choose Country',
        ),
        Wrap(
          runSpacing: 20.0,
          children: List.generate(
            _countryMap.length,
            (i) {
              return ValueListenableBuilder(
                valueListenable: countryValue,
                builder: (context, value, _) {
                  return InkWell(
                    onTap: () {
                      countryValue.value = _countryMap.keys.elementAt(i);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(kDefaultPadding),
                      margin: const EdgeInsets.all(kBorderRadius),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.0),
                        border: value == _countryMap.keys.elementAt(i)
                            ? Border.all(
                                color: AppColor.accentColor,
                              )
                            : null,
                        boxShadow: const [
                          BoxShadow(
                            color: AppColor.scaleGreyColor,
                            spreadRadius: 4.5,
                            blurRadius: 4.5,
                            offset: Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Text(
                        _countryMap.values.elementAt(i),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        Row(
          children: [
            TextButton(
              onPressed: () async {
                await context.read<LocationCubit>().bindApiUrl(
                      countryCode: countryValue.value,
                    );
                await context.read<AuthCubit>().authCheck();
              },
              child: const Text(
                'Proceed',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
