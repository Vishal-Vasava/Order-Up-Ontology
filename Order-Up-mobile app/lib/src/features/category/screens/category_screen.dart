import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:orderly_ecom/src/features/category/screens/components/category_list.dart';
import 'package:orderly_ecom/src/features/category/screens/cubit/category_cubit.dart';
import 'package:orderly_ecom/src/features/customer/widgets/customer_app_bar.dart';
import 'package:orderly_ecom/src/features/location/data/location_local_repository.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final latitude = inject.get<LocationLocalRepository>().latitude;
      final longitude = inject.get<LocationLocalRepository>().longitude;
      await context.read<CategoryCubit>().getCategoryList(
            custLat: latitude,
            custLong: longitude,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomerAppBar(
        title: AppLocalizations.of(context)!.category,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          final latitude = inject.get<LocationLocalRepository>().latitude;
          final longitude = inject.get<LocationLocalRepository>().longitude;
          await context.read<CategoryCubit>().getCategoryList(
                custLat: latitude,
                custLong: longitude,
                isRefresh: true,
              );
        },
        child: const CategoryList(),
      ),
    );
  }
}
