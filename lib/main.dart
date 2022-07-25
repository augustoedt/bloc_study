import 'package:bloc_study/screens/first_screen.dart';
import 'package:bloc_study/screens/second_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

const allRoutes = <String, String>{
  MainPage.namePath: "Home",
  FirstScreen.namePath: "Example 1",
};


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
        initialRoute: "/",
        routes: {
          MainPage.namePath: (context)=>const MainPage(),
          FirstScreen.namePath: (context)=>const FirstScreen(),
          SecondScreen.namePath: (context)=>BlocProvider(
            create: (_)=>PersonsBloc(),
            child: const SecondScreen(),
          ),
        }
    );
  }
}

class MainPage extends StatelessWidget {
  static const namePath = "/";

  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: allRoutes.entries.where((el) => el.key!='/')
              .map((e) => TextButton(onPressed: (){
                Navigator.pushNamed(context, e.key);
          }, child: Text(e.value))).toList()
        ),
      ),
    );
  }
}
