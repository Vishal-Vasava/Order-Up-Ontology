import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:orderly_ecom/src/api/endpoints.dart';
import 'package:orderly_ecom/src/features/other/domain/faq.dart';
import 'package:orderly_ecom/src/services/di/service_locator.dart';
import 'package:orderly_ecom/src/services/network/dio_exception.dart';
import 'package:orderly_ecom/src/services/network/network_adapter.dart';
import 'package:orderly_ecom/src/widgets/app_bar.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class FaqScreen extends StatelessWidget {
  FaqScreen({super.key});
  final _controller = RefreshController(initialRefresh: false);

  static Future<List<Faq>> fetchFAQ() async {
    try {
      final response =
          await inject.get<NetworkAdapter>().get(Endpoints.faqList);
      if (response.statusCode == 200) {
        if (response.data['statusCode'] == 200) {
          return (response.data['data'] as List)
              .map((e) => Faq.fromJson(e))
              .toList();
        }
        return [];
      } else {
        return [];
      }
    } on DioException catch (e) {
      throw DioExceptions.fromDioError(e).toString();
    }
  }

  ///On Refresh List
  Future<void> _onRefresh() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    await fetchFAQ();
    _controller.refreshCompleted();
  }

  Widget buildFaqList(int index, List<Faq> faqList) {
    if (faqList.isEmpty) {
      return ListView.builder(
        padding: const EdgeInsets.all(0),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Shimmer.fromColors(
              baseColor: Theme.of(context).hoverColor,
              highlightColor: Theme.of(context).highlightColor,
              child: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.white,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 10,
                      top: 5,
                      bottom: 5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 10,
                          width: 180,
                          color: Colors.white,
                        ),
                        const Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Container(
                          height: 10,
                          width: 150,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        itemCount: 6,
      );
    }
    return Card(
      elevation: 0.0,
      child: ExpansionTile(
        initiallyExpanded: true,
        title: Text(
          faqList[index].question!,
        ),
        children: <Widget>[
          ListTile(
            title: Text(
              faqList[index].answer!,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrderlyAppBar(
        title: 'FAQ',
      ),
      body: SafeArea(
        child: FutureBuilder<List<Faq>>(
          future: fetchFAQ(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  'No Data Available ${snapshot.error}',
                ),
              );
            } else if (!snapshot.hasData) {
              return const Center(
                child: Text(
                  'No Data Available ',
                ),
              );
            } else {
              return SmartRefresher(
                enablePullDown: true,
                onRefresh: _onRefresh,
                controller: _controller,
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  itemBuilder: (context, index) {
                    return buildFaqList(index, snapshot.data!);
                  },
                  itemCount: snapshot.data != null ? snapshot.data!.length : 6,
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
