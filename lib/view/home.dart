import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:io_crypto/model/coin_model.dart';
import 'package:io_crypto/view/components/item.dart';
import 'package:io_crypto/view/components/item2.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    getCoinMarket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double myHeight = MediaQuery.of(context).size.height;
    double myWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: myHeight,
        width: myWidth,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 253, 225, 112),
              Color(0xfffBC700),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: myHeight * 0.03,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: myWidth * 0.02,
                        vertical: myHeight * 0.005,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        "Main Portfolio",
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    Text(
                      "Top 10 Coins",
                      style: TextStyle(fontSize: 15),
                    ),
                    Text(
                      "Experimental",
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "\$ 7,466.20",
                      style: TextStyle(fontSize: 35),
                    ),
                    Container(
                      padding: EdgeInsets.all(myWidth * .02),
                      height: myHeight * 0.04,
                      width: myWidth * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.5),
                        shape: BoxShape.circle,
                      ),
                      child: Image.asset(
                        'assets/icons/5.1.png',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: myWidth * 0.07),
                child: Row(
                  children: [
                    Text(
                      "+ 162% all time",
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: myHeight * .02),
              Container(
                height: myHeight * 0.7,
                width: myWidth,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      color: Colors.grey.shade200,
                      spreadRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Column(
                  children: [
                    SizedBox(height: myHeight * 0.02),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth * 0.08),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Assets',
                            style: TextStyle(fontSize: 20),
                          ),
                          Icon(Icons.add),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: myHeight * 0.02,
                    ),
                    Expanded(
                      child: isRefreshing == true
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              itemCount: 4,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Item(
                                  item: coinMarket![index],
                                );
                              }),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: myWidth * .05),
                      child: Row(
                        children: [
                          Text(
                            'Recommend to Buy',
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: myHeight * .02),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: myWidth * .03),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: coinMarket!.length,
                            itemBuilder: (context, index) {
                              return Item2(
                                item: coinMarket![index],
                              );
                            }),
                      ),
                    ),
                    SizedBox(height: myHeight * .02),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool isRefreshing = true;

  List? coinMarket = [];
  var coinMarketList;
  Future<List<CoinModel>?> getCoinMarket() async {
    const url =
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true';
    setState(() {
      isRefreshing = true;
    });
    var response = await http.get(Uri.parse(url), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
    });
    setState(() {
      isRefreshing = false;
    });
    if (response.statusCode == 200) {
      var x = response.body;
      coinMarketList = coinModelFromJson(x);
      setState(() {
        coinMarket = coinMarketList;
      });
    } else {
      print(response.statusCode);
    }
  }
}
