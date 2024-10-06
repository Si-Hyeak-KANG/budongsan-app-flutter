import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:mybudongsan/map/map_page.dart';

/// 인터넷 연결 확인 및 로고 표시 후 메인 페이지 이동
class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return _IntroPage();
  }
}

class _IntroPage extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.data != null) {
                if(snapshot.data!) {
                  // 2초 후 웹 페이지로 이동
                  Future.delayed(const Duration(seconds: 2), () {
                    Navigator.of(context)
                        .pushReplacement(MaterialPageRoute(builder: (context) {
                        return const MapPage();
                    }));
                  });
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'My 부동산',
                          style: TextStyle(fontSize: 50),
                        ),
                        SizedBox(height: 20,),
                        Icon(
                          Icons.apartment_rounded,
                          size: 100,
                        )
                      ],
                    ),
                  );
                } else {
                  return const AlertDialog(
                    title: Text('My 부동산'),
                    content: Text(
                      '인터넷이 연결되지 않아 부동산 앱을 사용할 수 없습니다. 나중에 다시 실행해주세요.'
                    ),
                  );
                }
              } else {
                return const Center(
                  child: Text('데이터가 없습니다.'),
                );
              }
            case ConnectionState.waiting:
              return const Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.none:
              return const Center(
                child: Text('데이터가 없습니다.'),
              );
          }
        },
        future: connectCheck(),
      ),
    );
  }

  Future<bool> connectCheck() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    print('con: $connectivityResult');
    return connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi;
  }
}