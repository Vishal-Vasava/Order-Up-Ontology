import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:orderly_ecom/src/features/address/screens/components/address_list.dart';
import 'package:orderly_ecom/src/features/address/screens/cubit/address_cubit.dart';
import 'package:orderly_ecom/src/routes/app_router.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await context.read<AddressCubit>().getAddressList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: AppLocalizations.of(context)!.address,
        centerTitle: false,
      ),
      floatingActionButton: BlocBuilder<AddressCubit, AddressState>(
        buildWhen: (oldState, newState) {
          return newState is AddressLoadedState;
        },
        builder: (context, state) {
          return FloatingActionButton(
            elevation: 0.0,
            mini: true,
            backgroundColor: Theme.of(context).primaryColor,
            onPressed: () async {
              context.pushNamed(AppRoute.addAddress.toName);
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
              size: 25.0,
            ),
          );
        },
      ),
      body: const AddressList(),
    );
  }
}
