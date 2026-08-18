import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/authentication/screens/cubit/auth_cubit.dart';
import 'package:orderly_ecom/src/features/profile/screens/cubit/profile_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/utils/extensions.dart';

class ReasonList extends StatefulWidget {
  const ReasonList({super.key});

  @override
  State<ReasonList> createState() => _ReasonListState();
}

class _ReasonListState extends State<ReasonList> {
  ValueNotifier<String> reasonValue = ValueNotifier<String>('');
  TextEditingController otherReasonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchRemoveReasons();
  }

  @override
  void dispose() {
    otherReasonController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      buildWhen: (_, newState) {
        return newState is ProfileReasonListLoadingState ||
            newState is ProfileReasonListLoadedState ||
            newState is ProfileReasonListFailedState;
      },
      builder: (context, state) {
        if (state is ProfileReasonListLoadingState) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is ProfileReasonListFailedState) {
          return const SizedBox.shrink();
        }
        if (state is ProfileReasonListLoadedState) {
          return ValueListenableBuilder(
            valueListenable: reasonValue,
            builder: (BuildContext context, String value, Widget? child) {
              return Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    physics: const BouncingScrollPhysics(),
                    itemCount: state.reasons.length,
                    itemBuilder: (c, i) {
                      return RadioListTile(
                        groupValue: value,
                        contentPadding: EdgeInsets.zero,
                        value: state.reasons[i],
                        onChanged: (reason) {
                          reasonValue.value = reason!;
                          context.read<AuthCubit>().deleteReason = reason;
                          // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
                          reasonValue.notifyListeners();
                        },
                        title: Text(
                          state.reasons[i],
                          style:
                              Theme.of(context).textTheme.titleSmall!.copyWith(
                                    color: AppColor.primaryColor,
                                  ),
                        ),
                      );
                    },
                  ),
                  if (value == 'Other')
                    TextField(
                      textAlignVertical: TextAlignVertical.center,
                      controller: otherReasonController,
                      keyboardType: TextInputType.text,
                      maxLines: 2,
                      style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                      onChanged: (value) {
                        context.read<AuthCubit>().deleteReason = value;
                      },
                      decoration: InputDecoration(
                        counterText: '',
                        hintText: 'Tell us why you want to remove your account.'
                            .hardcoded,
                        labelText:
                            'Tell us why you want to remove your account.',
                        hintStyle: Theme.of(context).textTheme.bodySmall,
                        border: InputBorder.none,
                      ),
                    ),
                ],
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
