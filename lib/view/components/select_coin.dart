import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:io_crypto/model/chart_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class SelectCoin extends StatefulWidget {
  var selectItem;
  SelectCoin({
    super.key,
    this.selectItem,
  });

  @override
  State<SelectCoin> createState() => _SelectCoinState();
}

class _SelectCoinState extends State<SelectCoin> {
  late TrackballBehavior trackballBehavior;

  @override
  void initState() {
    getChart();
    trackballBehavior = TrackballBehavior(
      enable: true,
      activationMode: ActivationMode.singleTap,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: myHeight,
          width: myWidth,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: myWidth * .05,
                  vertical: myHeight * .02,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                            height: myHeight * .08,
                            child: Image.network(
                                widget.selectItem.image)),
                        SizedBox(width: myWidth * .03),
                        Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          spacing: myHeight * .01,
                          children: [
                            Text(
                              widget.selectItem.id,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.selectItem.symbol,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.normal,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      spacing: myHeight * .01,
                      children: [
                        Text(
                          '\$' +
                              widget.selectItem.currentPrice
                                  .toString(),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          widget.selectItem
                                  .marketCapChangePercentage24H
                                  .toString() +
                              '%',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                            color: widget.selectItem
                                        .marketCapChangePercentage24H >=
                                    0
                                ? Colors.green
                                : Colors.red,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Divider(),
              Expanded(
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: myWidth * .05,
                        vertical: myHeight * .02,
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            spacing: myHeight * .01,
                            children: [
                              Text(
                                "Low",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '\$' +
                                    widget.selectItem.low24H
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            spacing: myHeight * .01,
                            children: [
                              Text(
                                "High",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '\$' +
                                    widget.selectItem.high24H
                                        .toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            spacing: myHeight * .01,
                            children: [
                              Text(
                                "Vol",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.grey,
                                ),
                              ),
                              Text(
                                '\$' +
                                    widget.selectItem.totalVolume
                                        .toString() +
                                    'M',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: myHeight * .015,
                    ),
                    Container(
                      height: myHeight * .4,
                      width: myWidth,
                      // color: Colors.amber,
                      child: isRefresh == true
                          ? Center(
                              child: CircularProgressIndicator(
                                color: Color(0xfffBC700),
                              ),
                            )
                          : SfCartesianChart(
                              trackballBehavior: trackballBehavior,
                              zoomPanBehavior: ZoomPanBehavior(
                                enablePanning: true,
                                zoomMode: ZoomMode.x,
                              ),
                              series: <CandleSeries>[
                                CandleSeries<ChartModel, int>(
                                  enableSolidCandles: true,
                                  enableTooltip: true,
                                  bullColor: Colors.green,
                                  bearColor: Colors.red,
                                  dataSource: itemChart,
                                  xValueMapper:
                                      (ChartModel sales, _) =>
                                          sales.time,
                                  lowValueMapper:
                                      (ChartModel sales, _) =>
                                          sales.low,
                                  highValueMapper:
                                      (ChartModel sales, _) =>
                                          sales.high,
                                  openValueMapper:
                                      (ChartModel sales, _) =>
                                          sales.open,
                                  closeValueMapper:
                                      (ChartModel sales, _) =>
                                          sales.close,
                                  animationDuration: 55,
                                )
                              ],
                            ),
                    ),
                    SizedBox(
                      height: myHeight * .01,
                    ),
                    Center(
                      child: Container(
                        height: myHeight * .04,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: text.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: myWidth * .02,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    textBool = [
                                      false,
                                      false,
                                      false,
                                      false,
                                      false,
                                      false
                                    ];
                                    textBool[index] = true;
                                  });
                                  setDays(text[index]);
                                  getChart();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: myWidth * .03,
                                    vertical: myHeight * .005,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(5),
                                    color: textBool[index] == true
                                        ? Color(0xfffBC700)
                                            .withOpacity(.3)
                                        : Colors.transparent,
                                  ),
                                  child: Text(
                                    text[index],
                                    style: TextStyle(fontSize: 18),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: myHeight * .01),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth * .06),
                      child: Text(
                        'News',
                        style: TextStyle(fontSize: 25),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth * .06,
                          vertical: myHeight * .01),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Suspendisse scelerisque turpis ac nisi tincidunt, vel ornare lacus suscipit.',
                              textAlign: TextAlign.justify,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ),
                          Container(
                            width: myWidth * .25,
                            child: CircleAvatar(
                              radius: myHeight * .04,
                              backgroundColor: Colors.blue,
                              backgroundImage:
                                  AssetImage('assets/image/11.PNG'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: myHeight * 0.1,
                width: myWidth,
                // color: Colors.amber,
                child: Column(
                  children: [
                    Divider(
                      thickness: 1,
                    ),
                    SizedBox(height: myHeight * .01),
                    Row(
                      children: [
                        SizedBox(width: myWidth * .07),
                        Expanded(
                          flex: 5,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: myHeight * .015,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Color(0xfffBC700),
                            ),
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add,
                                  size: myHeight * .02,
                                ),
                                Text(
                                  'Add to Portfolio',
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(width: myWidth * .05),
                        Expanded(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: myHeight * .012,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey.withOpacity(.2),
                            ),
                            child: Image.asset(
                              'assets/icons/3.1.png',
                              height: myHeight * .03,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(width: myWidth * .05),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> text = ['D', 'W', 'M', '3M', '6M', 'Y'];

  List<bool> textBool = [false, false, true, false, false, false];
  int days = 30;

  setDays(String txt) {
    if (txt == 'D') {
      setState(() {
        days = 1;
      });
    } else if (txt == 'W') {
      setState(() {
        days = 7;
      });
    } else if (txt == 'M') {
      setState(() {
        days = 30;
      });
    } else if (txt == '3M') {
      setState(() {
        days = 90;
      });
    } else if (txt == '6M') {
      setState(() {
        days = 180;
      });
    } else if (txt == 'Y') {
      setState(() {
        days = 365;
      });
    }
  }

  List<ChartModel>? itemChart;

  bool isRefresh = true;

  Future<void> getChart() async {
    String url = 'https://api.coingecko.com/api/v3/coins/' +
        widget.selectItem.id +
        '/ohlc?vs_currency=usd&days=' +
        days.toString();
    setState(() {
      isRefresh = true;
    });

    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefresh = false;
    });

    if (response.statusCode == 200) {
      Iterable x = json.decode(response.body);
      List<ChartModel> modelList =
          x.map((e) => ChartModel.fromJson(e)).toList();
      setState(() {
        itemChart = modelList;
      });
    } else {
      print(response.body);
    }
  }
}
