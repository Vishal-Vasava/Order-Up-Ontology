import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:orderly_ecom/src/constants/sizes.dart';
import 'package:orderly_ecom/src/constants/static_text.dart';
import 'package:orderly_ecom/src/features/orders/screens/order_track_screen.dart';
import 'package:orderly_ecom/src/theme/colors.dart';

class TimeLineWidget extends StatefulWidget {
  const TimeLineWidget({
    super.key,
    required this.trackOrderList,
  });
  final List<TrackOrderList> trackOrderList;

  @override
  createState() {
    return TimeLineState();
  }
}

class TimeLineState extends State<TimeLineWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget setHighlightedSimpleTrackLineCircle(
      List<TrackOrderList> trackOrderList, int index) {
    return Stack(
      children: <Widget>[
        trackOrderList[index].isActiveColor == true &&
                (index != widget.trackOrderList.length - 1)
            ? Container(
                margin: const EdgeInsets.only(left: 10),
                height: double.infinity,
                width: 0,
                decoration: const BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: AppColor.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              )
            : Container(
                margin: const EdgeInsets.only(left: 10),
                height: double.infinity,
                width: 0,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                      color: index == widget.trackOrderList.length - 1
                          ? Colors.transparent
                          : Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
              ),
        Container(
          margin: const EdgeInsets.only(left: 1),
          height: 15.0,
          width: 15.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(7),
            border: Border.all(
              color: AppColor.primaryColor,
              width: 2.5,
            ),
            color: widget.trackOrderList[index].isActiveColor == true
                ? AppColor.primaryColor
                : Colors.white,
          ),
        ),
      ],
    );
  }

  //updated code on 2/02/2022 for dashed line and hollow circle
  Widget setDashedLineHollowCircle(
      List<TrackOrderList> trackOrderList, int index) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 1),
          height: 16.0,
          width: 16.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: AppColor.primaryColor,
              width: 2.5,
            ),
            color: widget.trackOrderList[index].isActiveColor == true
                ? AppColor.primaryColor
                : Colors.white,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.trackOrderList.length,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      primary: false,
      itemBuilder: (_, index) {
        return Container(
          margin: EdgeInsets.only(top: index == 0 ? 10 : 0),
          child: Column(
            children: <Widget>[
              IntrinsicHeight(
                child: Row(
                  children: [
                    setDashedLineHollowCircle(widget.trackOrderList, index),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                Text(
                                  widget.trackOrderList[index].trackStatusName!,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: widget.trackOrderList[index]
                                                .isActiveColor ==
                                            true
                                        ? AppColor.primaryColor
                                        : Colors.black26,
                                  ),
                                ),
                                Text(
                                  widget.trackOrderList[index].date != null
                                      ? DateFormat(StaticText.dateFormat)
                                          .format(widget
                                              .trackOrderList[index].date!)
                                      : '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 14.0,
                                    color: widget.trackOrderList[index]
                                                .isActiveColor ==
                                            true
                                        ? AppColor.primaryColor
                                        : Colors.black26,
                                  ),
                                ),
                                if (widget
                                    .trackOrderList[index].trackStatusName!
                                    .toLowerCase()
                                    .contains('cancelled'))
                                  Text(
                                    'Reason : ${widget.trackOrderList[index].cancelReason}',
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                gapH32,
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
