import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;

import 'model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((value) =>
      runApp(
          MaterialApp(
              home: Scaffold(
                appBar: AppBar(
                  centerTitle: true, title: Text('ЕГАЗ'), backgroundColor: Colors.lightBlue,),
                body: App(),
            )
          )
      )
  );
}
//--------   LOGIN FORM   ------------
TextEditingController logindat = new TextEditingController();
TextEditingController passwdat = new TextEditingController();
var name_c;
var code_c;
class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}
class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Wrap(
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Card(
              color: Colors.white,
              elevation: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children:[
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Image(
                      image: AssetImage('graphics/nithog.png'),
                      width: 70,
                    ),
                  ),
                  Text('Логін',
                    textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 30,color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    child: TextField(
                      controller: logindat,
                      decoration: InputDecoration(
                        hintText: 'Введіть свій логін',
                        labelText: 'Логін',
                      ),
                    ),
                  ),
                  Text('Пароль',textDirection: TextDirection.ltr,
                    style: TextStyle(fontSize: 30,color: Colors.grey),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                    child: TextField(
                      controller: passwdat,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Введіть свій пароль',
                        labelText: 'Пароль',
                      ),
                    ),
                  ),
                  ButtonBar(
                    alignment: MainAxisAlignment.center,
                    buttonMinWidth: 1000,
                    buttonHeight: 50,
                    buttonPadding: EdgeInsets.symmetric(horizontal:15),
                    children:[
                      RaisedButton.icon(
                        icon: Icon(Icons.login),
                        label: Text('Увійти'),
                        textColor: Colors.white,
                        color: Colors.lightBlue,
                        splashColor: Colors.lightBlueAccent[700],
                        onPressed: () async {
                          //GETTING RESPONSE FROM API
                          http.Response response = await http.get('http://85.238.100.58:888/wp/wp-json/v1/EgazAPI.php?'
                              'apicall=getcardinfo&login=${logindat.text}&passw=${passwdat.text}',
                              headers: {'Content-Type': 'application/json, charset=utf-8'});
                            print("Response status: ${response.statusCode}");
                            print("Response body: ${response.body}");

                            //WITH OUR QUERY Json.decode will return a Map, not a List
                            Map<String, dynamic> map = json.decode(utf8.decode(response.bodyBytes));
                            List<dynamic> data = map["cards"];
                            //SETTING UP DATA FOR instance
                            name_c = data[0]["name_card"];
                            code_c = data[0]["code_card"];
                            print('${logindat.text} is ${passwdat.text}');

                            //OPENING UserCard
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UserCard()),);
                          },),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ]
        ),
    );
  }
}
//--------END   LOGIN FORM   ------------

//--------   USERINFO FORM   ------------
class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true, title: Text('Карта користувача'),
        backgroundColor: Colors.lightBlue,
      ),
      body: UserCardInfo(),
    );
  }
}
class UserCardInfo extends StatefulWidget{@override  UserCardInfoState createState() => UserCardInfoState();
}
class UserCardInfoState extends State<UserCardInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('$name_c',style: TextStyle(fontSize: 25,color: Colors.blueGrey,fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text('$code_c',style: TextStyle(fontSize: 20,color: Colors.blueGrey)),
              SizedBox(height: 200),
              QrImage(
                data: '$code_c',
                version: QrVersions.auto,
                size: 300.0,
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.aspect_ratio_rounded),
              label: 'Сайт',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_box_rounded),
              label: 'Мій кабінет',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.phone),
              label: 'Гаряча лінія',

            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.lightBlueAccent,
          onTap: _onItemTapped,
        ),
      );
    }
    int _selectedIndex = 1;

    void _onItemTapped(int index) {
      setState(() {
        _selectedIndex = index;
        switch (_selectedIndex) {
          case 0:
            UrlLauncher.launch('http://egaz.ua/wp/');
            break;
          case 2:
            UrlLauncher.launch('tel:+380677034599');
            break;
        }});
    }
  }
//--------END   USERINFO FORM   ------------