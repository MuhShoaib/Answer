import 'dart:async';

import 'package:answer/Ans.dart';
import 'package:answer/language.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:facebook_audience_network/facebook_audience_network.dart';

import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:timezone/timezone.dart ' as tz;
import 'package:timezone/data/latest.dart' as tz;

import 'package:share_plus/share_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import "dart:math";
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'package:translator/translator.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

var j1, j2;
bool isalr = false;

bool isans = false;
int hour = 0;
int minutes = 0;
String randomAnsw = " ";
String al = "";
String applink =
    "https://play.google.com/store/apps/details?id=com.answerapp.ans";
List<String> str = ["YES", "NO"];

var element, el, alr;
String ta = "Answers";
String ye = "YES/NO";
String alm = "Alarm";
String ca = "Create Alarm";
String am = "Alarm Page";
final _random = Random();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      title: 'Splash Screen',
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  getList() async {
    return await http
        .get(Uri.parse(
            "https://script.google.com/macros/s/AKfycbzikHTHQ6_5tRbWaXpiCsXp1jPwFsXfzMfh6fL4xiT1RRPRvtFueRmUmaJktUNgweAD3g/exec"))
        .then((response) {
      // print(convert.jsonDecode(response.body));
      // return response.body.toString();
      if (response.statusCode == 200) {
        var jsonans = convert.jsonDecode(response.body) as List;
        return jsonans.map((json) => Answer.fromJson(json)).toList();
      } else {
        getList();
      }
    });
  }

  getTwoLists() async {
    var r1 = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbzikHTHQ6_5tRbWaXpiCsXp1jPwFsXfzMfh6fL4xiT1RRPRvtFueRmUmaJktUNgweAD3g/exec"));

    var r2 = await http.get(Uri.parse(
        "https://script.google.com/macros/s/AKfycbzluUpjs50wOLaGkTH1m1JhnUCHCq2eXEfJfBVtyLr-QGb3gyv7oa8lSS-_HaUVTxyl/exec"));

    if (r1.statusCode == 200 && r2.statusCode == 200) {
      var json1 = convert.jsonDecode(r1.body) as List;
      var json2 = convert.jsonDecode(r2.body) as List;
      //print("JSON1$json1");
      j1 = json1.map((json) => Answer.fromJson(json)).toList();
      j2 = json2.map((json) => Alarm.fromJson(json)).toList();

      return json1;
    } else {
      getTwoLists();
    }
  }

  @override
  void initState() {
    super.initState();
    tz.initializeTimeZones();

    FacebookAudienceNetwork.init(
      testingId: "37b1da9d-b48c-4103-a393-2e895e734bd6",
    );

    getTwoLists().then((list) {
      setState(() {
        isans = true;
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => SecondScreen(
                      "abc",
                      answerslist: j1,
                      alramlist: j2,
                    )));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        color: Colors.black,
        child: Image.asset(
          'assets/images/LOGO.jpg',
          height: 150,
          width: 150,
        ),
        alignment: Alignment.center,
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  SecondScreen(String s, {Key? key, this.answerslist, this.alramlist})
      : super(key: key);

  final List<Answer>? answerslist;
  List<Alarm>? alramlist;

  @override
  _SecondScreenState createState() =>
      _SecondScreenState(answ: answerslist, alrm: alramlist);
}

class _SecondScreenState extends State<SecondScreen> {
  _SecondScreenState({this.answ, this.alrm});

  List<Answer>? answ;

  List<Alarm>? alrm;

  String banid = "ca-app-pub-8939536596294423/1883122804";
  late BannerAd _bannerAd;
  bool _isAdloaded = false;

  String banid2 = "ca-app-pub-8939536596294423/8256959468";
  late BannerAd _banaAd2;
  bool _isban2 = false;

  String banid3 = "ca-app-pub-8939536596294423/6285402249";
  late BannerAd _banaAd3;
  bool _isban3 = false;

  String initid = "ca-app-pub-8939536596294423/2868067260";
  late InterstitialAd _initAd;
  bool _isload = false;

  String initid1 = "ca-app-pub-8939536596294423/3146380813";
  late InterstitialAd _initAd1;
  bool _isinit1 = false;

  String initid3 = "ca-app-pub-8939536596294423/3820140568";
  late InterstitialAd _initAd3;
  bool _isinit3 = false;

  String initid4 = "ca-app-pub-8939536596294423/7406912221";
  late InterstitialAd _initAd4;
  bool _isinit4 = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  GoogleTranslator translator = GoogleTranslator();

  showAd() {
    FacebookInterstitialAd.loadInterstitialAd(
        placementId: "IMG_16_9_APP_INSTALL#2312433698835503_2650502525028617",
        listener: (result, value) {
          if (result == InterstitialAdResult.LOADED) {
            FacebookInterstitialAd.showInterstitialAd(delay: 0);
          }
        });
  }

  void _changelanguage(Language language) {
    switch (language.langaugeCode) {
      case "hi":
        {
          translator.translate(randomAnsw, to: 'hi').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });

          translator.translate(ta, to: 'hi').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'hi').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'hi').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      case "ar":
        {
          translator.translate(randomAnsw, to: 'ar').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });
          translator.translate(ta, to: 'ar').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'ar').then((output) {
            setState(() {
              ye = output.toString();
            });
          });

          translator.translate(alm, to: 'ar').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      case "sv":
        {
          translator.translate(randomAnsw, to: 'sv').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });
          translator.translate(ta, to: 'sv').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'sv').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'ar').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      case "de":
        {
          translator.translate(randomAnsw, to: 'de').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });
          translator.translate(ta, to: 'de').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'de').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'de').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      case "nl":
        {
          translator.translate(randomAnsw, to: 'nl').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });

          translator.translate(ta, to: 'nl').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'hl').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'hl').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      case "fr":
        {
          translator.translate(randomAnsw, to: 'fr').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });
          translator.translate(ta, to: 'fr').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'fr').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'fr').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }

      case "es":
        {
          translator.translate(randomAnsw, to: 'es').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });

          translator.translate(ta, to: 'es').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'es').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'es').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      case "az":
        {
          translator.translate(randomAnsw, to: 'az').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });
          translator.translate(ta, to: 'az').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'az').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'az').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      case "it":
        {
          translator.translate(randomAnsw, to: 'it').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });

          translator.translate(ta, to: 'it').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'it').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'it').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      case "zh-cn":
        {
          translator.translate(randomAnsw, to: 'zh-cn').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });
          translator.translate(ta, to: 'zh-cn').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'zh-cn').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'zh-cn').then((output) {
            setState(() {
              alm = output.toString();
            });
          });

          break;
        }
      case "vi":
        {
          translator.translate(randomAnsw, to: 'vi').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });
          translator.translate(ta, to: 'vi').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'vi').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'vi').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      case "th":
        {
          translator.translate(randomAnsw, to: 'th').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });
          translator.translate(ta, to: 'th').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'th').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'th').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      case "ja":
        {
          translator.translate(randomAnsw, to: 'ja').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });
          translator.translate(ta, to: 'ja').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'ja').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
          translator.translate(alm, to: 'ja').then((output) {
            setState(() {
              alm = output.toString();
            });
          });
          break;
        }
      default:
        {
          translator.translate(randomAnsw, to: 'en').then((output) {
            setState(() {
              randomAnsw = output.toString();
            });
          });
          translator.translate(ta, to: 'en').then((output) {
            setState(() {
              ta = output.toString();
            });
          });

          translator.translate(ye, to: 'en').then((output) {
            setState(() {
              ye = output.toString();
            });
          });
        }
        break;
    }
  }

  @override
  void initState() {
    super.initState();
    init();
    _initBannerAd();
    _initBanAd2();
    _initBanAd3();

    _initAdd();
    _initAdd1();
    _initAdd3();
    _initAdd4();

    if (isans == true) {
      element = answ?[_random.nextInt(answ?.length ?? 0)];
      setState(() {
        randomAnsw = element.ans;
      });
      print("Answerr is $randomAnsw");
    }

    alr = alrm?[_random.nextInt(alrm?.length ?? 0)];
    setState(() {
      al = alr.alarm;
    });

    print("Alram is $al");

    showat9();
    showat6();
  }

  void _initBanAd2() {
    _banaAd2 = BannerAd(
        size: AdSize.banner,
        adUnitId: banid2,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isban2 = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}),
        request: AdRequest());

    _banaAd2.load();
  }

  void _initBanAd3() {
    _banaAd3 = BannerAd(
        size: AdSize.banner,
        adUnitId: banid3,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isban3 = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}),
        request: AdRequest());

    _banaAd3.load();
  }

  void _initBannerAd() {
    _bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: banid,
        listener: BannerAdListener(
            onAdLoaded: (ad) {
              setState(() {
                _isAdloaded = true;
              });
            },
            onAdFailedToLoad: (ad, error) {}),
        request: AdRequest());

    _bannerAd.load();
  }

  void _initAdd() {
    InterstitialAd.load(
        adUnitId: initid,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: onAdLoaded, onAdFailedToLoad: (error) {}));
  }

  void onAdLoaded(InterstitialAd ad) {
    _initAd = ad;
    _isload = true;
  }

  void _initAdd1() {
    InterstitialAd.load(
        adUnitId: initid1,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: onAdLoaded1, onAdFailedToLoad: onNotAdload));
  }

  void onAdLoaded1(InterstitialAd ad) {
    _initAd1 = ad;
    _isinit1 = true;
  }

  void onNotAdload(LoadAdError) {
    showAd();
  }

  void _initAdd3() {
    InterstitialAd.load(
        adUnitId: initid3,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: onAdLoaded3, onAdFailedToLoad: (error) {}));
  }

  void onAdLoaded3(InterstitialAd ad) {
    _initAd3 = ad;
    _isinit3 = true;
  }

  void _initAdd4() {
    InterstitialAd.load(
        adUnitId: initid4,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
            onAdLoaded: onAdLoaded4, onAdFailedToLoad: (error) {}));
  }

  void onAdLoaded4(InterstitialAd ad) {
    _initAd4 = ad;
    _isinit4 = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      key: _scaffoldKey,
      drawer: Drawer(
        child: Scaffold(
            body: ListView(
              children: <Widget>[
                ListTile(
                  title: Text(ta),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // _initAdd();
                    if (_isload) {
                      _initAd.show();
                    }

                    // alr = alrm?[_random.nextInt(alrm?.length ?? 0)];
                    // Navigator.pop(context);
                    // setState(() {
                    //   al = alr.alarm;
                    // });
                    element = answ![_random.nextInt(answ!.length)];
                    Navigator.pop(context);
                    setState(() {
                      randomAnsw = element.ans!;
                    });
                    // displayNotification(randomAnsw);
                  },
                ),
                ListTile(
                  title: Text(ye),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    // _initAdd1();
                    if (_isinit1) {
                      _initAd1.show();
                    }

                    el = str[_random.nextInt(str.length)];
                    Navigator.pop(context);
                    setState(() {
                      randomAnsw = el;
                    });

                    // // el =str[_random.nextInt(str.length)];
                    // // Navigator.pop(context);
                    // // setState(() {
                    // //   al =el;
                    // });
                    // displayNotification(randomAnsw);
                  },
                ),

                ListTile(
                  title: Text(alm),
                  trailing: const Icon(Icons.arrow_forward),
                  onTap: () {
                    if (_isload) {
                      _initAd.show();
                    }
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => Alram()));
                  },
                ),

                // Spacer(),
              ],
            ),
            bottomNavigationBar: _isAdloaded
                ? Container(
                    height: _bannerAd.size.height.toDouble(),
                    width: _bannerAd.size.width.toDouble(),
                    child: AdWidget(
                      ad: _bannerAd,
                    ),
                  )
                : SizedBox()),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          ta,
          style: TextStyle(color: Colors.white),
        ),
        leading: GestureDetector(
          onTap: () {
            _scaffoldKey.currentState!.openDrawer();
          },
          child: Icon(
            Icons.menu, // add custom icons also
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.language,
              color: Colors.white,
            ),
            onPressed: () {
              buildLanguageDialog(context);
              // do something
            },
          ),
        ],
      ),
      bottomNavigationBar: _isban2
          ? Container(
              height: _banaAd2.size.height.toDouble(),
              width: _banaAd2.size.width.toDouble(),
              child: AdWidget(
                ad: _banaAd2,
              ),
            )
          : SizedBox(),
      body: Center(
        child: Text(
          randomAnsw,
          style: const TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () => {
          if (_isinit3) {_initAd3.show()},
          share(context, applink)
        },
        child: new IconTheme(
          data: new IconThemeData(color: Colors.black),
          child: new Icon(Icons.share),
        ),
      ),
    );
  }

  buildLanguageDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (builder) {
          return AlertDialog(
                title: Text('Choose Your Country'),
                content: Scaffold(
                  body: Container(
                    width: double.maxFinite,
                    child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(0),
                            child: GestureDetector(
                              child: ListTile(
                                leading:
                                    Text(Language.langaugeList()[index].name),
                                title: Text(Language.langaugeList()[index].flag),
                              ),
                              onTap: () {
                                switch (
                                    Language.langaugeList()[index].langaugeCode) {
                                  case "hi":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'hi')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ta, to: 'hi')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'hi')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'hi')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'hi')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'hi')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });

                                      break;
                                    }
                                  case "ar":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'ar')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(ta, to: 'ar')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'ar')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(alm, to: 'ar')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'ar')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'ar')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }
                                  case "sv":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'sv')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(ta, to: 'sv')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'sv')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'sv')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'sv')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'sv')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }
                                  case "de":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'de')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(ta, to: 'de')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'de')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'de')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'de')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'de')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }
                                  case "nl":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'nl')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ta, to: 'nl')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'hl')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'hl')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'nl')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'nl')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }
                                  case "fr":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'fr')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(ta, to: 'fr')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'fr')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'fr')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'fr')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'fr')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }

                                  case "es":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'es')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ta, to: 'es')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'es')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'es')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(am, to: 'es')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'es')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }
                                  case "az":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'az')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(ta, to: 'az')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'az')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'az')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'az')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'az')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }
                                  case "it":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'it')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ta, to: 'it')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'it')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'it')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'it')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'it')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }
                                  case "zh-cn":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'zh-cn')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(ta, to: 'zh-cn')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'zh-cn')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'zh-cn')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'zh-cn')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'zh-cn')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });

                                      break;
                                    }
                                  case "vi":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'vi')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(ta, to: 'vi')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'vi')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'vi')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'vi')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'vi')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }
                                  case "th":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'th')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(ta, to: 'th')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'th')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'th')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(am, to: 'th')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'th')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }
                                  case "ja":
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'ja')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(ta, to: 'ja')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'ja')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(alm, to: 'ja')
                                          .then((output) {
                                        setState(() {
                                          alm = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(am, to: 'ja')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'ja')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                      break;
                                    }
                                  default:
                                    {
                                      translator
                                          .translate(randomAnsw, to: 'en')
                                          .then((output) {
                                        setState(() {
                                          randomAnsw = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(ta, to: 'en')
                                          .then((output) {
                                        setState(() {
                                          ta = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ye, to: 'en')
                                          .then((output) {
                                        setState(() {
                                          ye = output.toString();
                                        });
                                      });
                                      translator
                                          .translate(am, to: 'en')
                                          .then((output) {
                                        setState(() {
                                          am = output.toString();
                                        });
                                      });

                                      translator
                                          .translate(ca, to: 'en')
                                          .then((output) {
                                        setState(() {
                                          ca = output.toString();
                                        });
                                      });
                                    }
                                    break;
                                }
                                Navigator.pop(context);
                                print(Language.langaugeList()[index].id);
                              },
                            ),
                          );
                        },
                        separatorBuilder: (context, index) {
                          return Divider(
                            color: Colors.black,
                          );
                        },
                        itemCount: Language.langaugeList().length),
                  ),
                        bottomNavigationBar: _isban3
                            ? Container(
                                height: _bannerAd.size.height.toDouble(),
                                width: _bannerAd.size.width.toDouble(),
                                child: AdWidget(
                                  ad: _banaAd3,
                                ),
                              )
                            : SizedBox()
                ),
              );

        });
  }

  ShowAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Stop"),
      onPressed: () {
        isalr = true;
        if (isalr == true) {
          alr = alrm?[_random.nextInt(alrm?.length ?? 0)];
          setState(() {
            randomAnsw = alr.alarm;
          });

          print("Random $randomAnsw");
          FlutterRingtonePlayer.stop();
          Navigator.pop(context);
        }
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Alarm Message"),
      content: Text("Stop the Alarm to See Random Alarm Message?"),
      actions: [
        cancelButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<void> init() async {
    //Initialization Settings for Android
    final AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('lo');

    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  void selectNotification(String? payload) async {
    ShowAlertDialog(context);
    FlutterRingtonePlayer.playAlarm(asAlarm: false);
  }
}

Future<void> showat9() async {
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day, 6, 00);
  var a = tz.TZDateTime.from(
    date,
    tz.local,
  );

  await flutterLocalNotificationsPlugin.zonedSchedule(
    1,
    'Answer App',
    'Luckey Message',
    a,
      const NotificationDetails(
          android: AndroidNotificationDetails("c1", "c2",
              playSound: true,
              sound: RawResourceAndroidNotificationSound('b'))),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true);
}

Future<void> showat6() async {
  DateTime now = new DateTime.now();
  DateTime date = new DateTime(now.year, now.month, now.day, 18, 00);
  var time = tz.TZDateTime.from(
    date,
    tz.local,
  );
  await flutterLocalNotificationsPlugin.zonedSchedule(
      4,
      "Answer App",
      "Luckey Message",
      time,
      const NotificationDetails(
          android: AndroidNotificationDetails("c8", "c9",
              playSound: true,
              sound: RawResourceAndroidNotificationSound('b'))),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true);

  // var time = new Time(18, 01, 0);
  // await flutterLocalNotificationsPlugin.showDailyAtTime(
  //   3,
  //   'Answer App',
  //   'Luckey Message',
  //   time,
  //   NotificationDetails(
  //       android: AndroidNotificationDetails("c4", "c5",
  //           playSound: true, sound: RawResourceAndroidNotificationSound('b'))),
  // );
}

void share(BuildContext context, String str) {
  String message = "Please Download this Answer App $str";

  RenderBox? box = context.findRenderObject() as RenderBox;
  Share.share(message,
      subject: "Description",
      sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
}

class Alram extends StatefulWidget {
  const Alram({Key? key}) : super(key: key);

  @override
  _AlramState createState() => _AlramState();
}

class _AlramState extends State<Alram> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => SecondScreen(
                          "abc",
                          answerslist: j1,
                          alramlist: j2,
                        )));
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(am),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(primary: Colors.white),
              onPressed: () async {
                DatePicker.showDateTimePicker(context,
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(2088, 6, 7, 05, 09), onChanged: (date) {
                  print('change $date in time zone ' +
                      date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) async {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondScreen(
                                "abc",
                                answerslist: j1,
                                alramlist: j2,
                              )));
                  await shedule(date);

                  print('confirm $date');
                  Theme(
                    data: ThemeData().copyWith(
                        primaryColor: Colors.red, //Head background
                        accentColor: Colors.red, //selection color
                        dialogBackgroundColor: Colors.white),
                    child: Text("Hello"),
                  );
                });
              },
              child: Text(
                ca,
                style: TextStyle(fontSize: 20.0, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> shedule(DateTime dateTime) async {
    print("This is Shoaib ${DateTime.now()}");

    var time = tz.TZDateTime.from(
      dateTime,
      tz.local,
    );
    flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "Alarm Message",
        "Click to continue",
        time.add(
          Duration(seconds: 2),
        ),
        const NotificationDetails(
            android: AndroidNotificationDetails(
          "c6", "c7",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('a')
        )),
        payload: 'abc',
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  }
}
