import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:orderly_ecom/src/constants/app_assets.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/domain/sku_gallery.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/components/inventory_add_form.dart';
import 'package:orderly_ecom/src/features/manager/features/inventory/screens/cubit/inventory_cubit.dart';
import 'package:orderly_ecom/src/theme/colors.dart';
import 'package:orderly_ecom/src/widgets/shimmer.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:orderly_ecom/src/localization/app_localizations.dart';

class SkuScreen extends StatefulWidget {
  const SkuScreen({super.key});

  @override
  State<SkuScreen> createState() => _SkuScreenState();
}

class _SkuScreenState extends State<SkuScreen> {
  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController();
    searchController = TextEditingController();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (mounted) {
      context.read<InventoryCubit>().paginatedPage = 1;
      await context
          .read<InventoryCubit>()
          .getGalleryList(searchDish: '', pageNumber: 1);
    }
  }

  late TextEditingController searchController;
  ValueNotifier<String> searchNotifier = ValueNotifier<String>('');

  final ValueNotifier<int> _selectItem = ValueNotifier<int>(-1);

  static late RefreshController _refreshController;

  List<SkuGalleryItem> skuGalleryList = [];

  @override
  Widget build(BuildContext context) {
    _refreshController = RefreshController(initialRefresh: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SKU GALLERY',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18.0,
            color: AppColor.accentColor,
          ),
        ),
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: AppColor.textColor,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocBuilder<InventoryCubit, InventoryState>(
        buildWhen: (_, newState) {
          return newState is InventorySkuLoadingState ||
              newState is InventorySkuFailedState ||
              newState is InventorySkuLoadedState;
        },
        builder: (context, state) {
          return SmartRefresher(
            controller: _refreshController,
            enablePullDown: true,
            enablePullUp: true,
            header: const WaterDropHeader(
              waterDropColor: AppColor.primaryColor,
            ),
            onRefresh: () async {
              skuGalleryList.clear();
              searchController.clear();
              // searchNotifier.value = '';
              context.read<InventoryCubit>().resetPagination();
              await context
                  .read<InventoryCubit>()
                  .getGalleryList(searchDish: '', pageNumber: 1);
              _refreshController.refreshCompleted();
              searchController.clear();
            },
            footer: const ClassicFooter(
              noDataText: 'Empty',
              canLoadingText: '',
              idleText: '',
              idleIcon: Center(),
              failedText: '',
            ),
            physics: const BouncingScrollPhysics(),
            onLoading: () async {
              if (context.read<InventoryCubit>().paginatedPage > 1) {
                await context.read<InventoryCubit>().getGalleryList(
                    searchDish: searchController.text,
                    pageNumber: context.read<InventoryCubit>().paginatedPage);
              }
              _refreshController.loadComplete();
            },
            child: ListView(
              padding: const EdgeInsets.only(top: 20),
              children: [
                Container(
                  margin:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: TextFormField(
                    controller: searchController,
                    style: const TextStyle(
                      fontFamily: 'Poppins',
                      color: AppColor.textColor,
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                    ),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      hintText: AppLocalizations.of(context)!.search,
                      labelText: AppLocalizations.of(context)!.search,
                      prefixIcon: IconButton(
                        icon: const Image(
                          image: AssetImage(AppAssets.search),
                          width: 25.0,
                          height: 25.0,
                        ),
                        onPressed: () async {
                          if (searchController.text.isNotEmpty) {
                            await context.read<InventoryCubit>().getGalleryList(
                                searchDish: searchController.text,
                                pageNumber: 1);
                          }
                        },
                      ),
                      suffixIcon: ValueListenableBuilder<String>(
                        valueListenable: searchNotifier,
                        builder: (context, state, child) {
                          return AnimatedOpacity(
                            duration: const Duration(milliseconds: 300),
                            opacity: state.isEmpty ? 0.0 : 1.0,
                            child: IconButton(
                              onPressed: () async {
                                skuGalleryList.clear();
                                searchController.clear();
                                searchNotifier.value = '';
                                await context
                                    .read<InventoryCubit>()
                                    .getGalleryList(
                                        searchDish: searchController.text,
                                        pageNumber: 1);
                                FocusManager.instance.primaryFocus?.unfocus();
                              },
                              icon: const Icon(
                                Icons.cancel,
                                size: 25.0,
                                color: AppColor.accentColor,
                              ),
                            ),
                          );
                        },
                      ),
                      hintStyle: const TextStyle(
                        color: AppColor.textColor,
                      ),
                    ),
                    onChanged: (value) async {
                      searchNotifier.value = value;
                      if (searchController.text.isEmpty) {
                        await context.read<InventoryCubit>().getGalleryList(
                            searchDish: searchController.text, pageNumber: 1);
                      } else {
                        if (searchController.text.isNotEmpty) {
                          skuGalleryList.clear();
                          await context.read<InventoryCubit>().getGalleryList(
                              searchDish: searchController.text, pageNumber: 1);
                        }
                      }
                    },
                  ),
                ),
                BlocBuilder<InventoryCubit, InventoryState>(
                  buildWhen: (_, newState) {
                    return newState is InventorySkuLoadingState ||
                        newState is InventorySkuFailedState ||
                        newState is InventorySkuLoadedState;
                  },
                  builder: (context, state) {
                    if (state is InventorySkuLoadingState &&
                        state.isFirstLoading) {
                      if (isDesktop(context) || isTablet(context)) {
                        return AlignedGridView.count(
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          crossAxisCount: 4,
                          itemCount: 8,
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: AppShimmer(
                                height: 200.0,
                              ),
                            );
                          },
                        );
                      } else {
                        return AlignedGridView.count(
                          shrinkWrap: true,
                          primary: false,
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 10),
                          crossAxisCount: 2,
                          itemCount: 6,
                          itemBuilder: (context, index) {
                            return const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: AppShimmer(
                                height: 200.0,
                              ),
                            );
                          },
                        );
                      }
                    }
                    if (state is InventorySkuLoadingState) {
                      skuGalleryList = state.galleryList;
                    }
                    if (state is InventorySkuLoadedState) {
                      skuGalleryList = state.skuInventoryList;
                    }
                    if (state is InventorySkuFailedState) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(state.message),
                            ElevatedButton(
                              onPressed: () async {
                                await context
                                    .read<InventoryCubit>()
                                    .getGalleryList(
                                        searchDish: '', pageNumber: 1);
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }
                    if (isDesktop(context) || isTablet(context)) {
                      return AlignedGridView.count(
                        crossAxisCount: 4,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: skuGalleryList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              _selectItem.value = index;
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (c) => BlocProvider.value(
                                    value: context.read<InventoryCubit>(),
                                    child: InventoryAddForm(
                                      // isEdit: false,
                                      fromBack: true,
                                      galleryList: skuGalleryList[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: AppColor.accentColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Center(
                                      child: CachedNetworkImage(
                                        height: 110,
                                        imageUrl:
                                            skuGalleryList[index].imageUrl ??
                                                '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Name: ',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: skuGalleryList[index].title,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 2, top: 5, bottom: 5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Desc : ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            skuGalleryList[index].description ??
                                                '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: AppColor.primaryColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Add',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    } else {
                      return AlignedGridView.count(
                        crossAxisCount: 2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: skuGalleryList.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              _selectItem.value = index;
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).pop();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (c) => BlocProvider.value(
                                    value: context.read<InventoryCubit>(),
                                    child: InventoryAddForm(
                                      // isEdit: false,
                                      fromBack: true,
                                      galleryList: skuGalleryList[index],
                                    ),
                                  ),
                                ),
                              );
                            },
                            child: Container(
                              margin: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.white,
                                border: Border.all(
                                  width: 1,
                                  color: AppColor.accentColor,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                    ),
                                    child: Center(
                                      child: CachedNetworkImage(
                                        height: 110,
                                        imageUrl:
                                            skuGalleryList[index].imageUrl ??
                                                '',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 5.0),
                                    child: RichText(
                                      text: TextSpan(
                                        text: 'Name: ',
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: skuGalleryList[index].title,
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 5.0, right: 2, top: 3, bottom: 5),
                                    child: Row(
                                      children: [
                                        const Text(
                                          'Desc : ',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Expanded(
                                          child: Text(
                                            skuGalleryList[index].description ??
                                                '',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    height: 40,
                                    decoration: const BoxDecoration(
                                      color: AppColor.primaryColor,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'Add',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .copyWith(
                                              color: Colors.white,
                                            ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
