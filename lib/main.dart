import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:guardproject/Base/ProvidersSetup.dart';
import 'package:guardproject/Providers/LoginReg/Auth.dart';
import 'package:guardproject/Screens/VertificationScreen.dart';
import 'package:guardproject/Screens/home_screen/home_screen.dart';

import 'package:guardproject/Screens/landing_screen/landing_screen.dart';
import 'package:guardproject/Screens/registeration/login_screen.dart';
import 'package:guardproject/Screens/registeration/sign_up_screen.dart';
import 'package:guardproject/models/User.module.dart';

import 'package:guardproject/theme/theme_data.dart';
import 'package:guardproject/utils/available_images.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setUpSingeltons();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // bool _isLogged = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Guard',
        theme: mainTheme,
        home: StreamBuilder<bool>(
          stream: GetIt.I<AuthService>().isLoggedS,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data) {
                return HomeScreen();
              }
              return LandingScreen();
            }
            return AppLogo();
          },
        ),
        routes: {
          MainPage.routeName: (_) => MainPage(),
          VertificationScreen.routeName: (_) => VertificationScreen(),
          LandingScreen.routeName: (_) => LandingScreen(),
          SignUpScreen.routeName: (_) => SignUpScreen(),
          LoginScreen.routeName: (_) => LoginScreen(),
          HomeScreen.routeName: (_) => HomeScreen(),
        },
      ),
    );
  }
}

class AppLogo extends StatelessWidget {
  const AppLogo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Scaffold(
      body: Image.asset(AvailableImages.appLogo),
    ));
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key key}) : super(key: key);
  static const String routeName = "MainPage";

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    GetIt.I<AuthService>().profile.listen((d) {
      print("listining " + d.toString());
    });
    super.initState();

   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.green,
        child: Consumer<AuthService>(
          builder: (context, pr, child) => Column(
            children: <Widget>[
              StreamBuilder(
                stream: pr.isLoggedS,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return Container(
                    child: Text("Welcome  ${snapshot.data} "),
                  );
                },
              ),
              StreamBuilder<User>(
                stream: pr.profile,
                builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
                  return Container(
                    child: Text("Welcome  ${snapshot.data?.displayName} "),
                  );
                },
              ),
              FlatButton(
                child: Text("SignOut"),
                onPressed: pr.signOut,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
