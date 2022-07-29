import 'package:bloc/bloc.dart';
import 'dart:math' as math show Random;
import 'package:flutter/material.dart';

const names = ["Foo", "Bar", "Baz"];

extension RandomElement<T> on Iterable<T>{
  T getRandomElement() => elementAt(math.Random().nextInt(length));
}

class NamesCubit extends Cubit<String?>{
  NamesCubit() : super(null);

  void pickRandomName() => emit(names.getRandomElement());
}

class FirstScreen extends StatefulWidget {
  static const namePath = "/firstExample";

  const FirstScreen({Key? key}) : super(key: key);

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {

  late final NamesCubit cubit;

  @override
  void initState() {
    super.initState();
    cubit = NamesCubit();
  }

  @override
  void dispose() {
    cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("First Example"),
      ),
      body: StreamBuilder<String?>(
          stream: cubit.stream,
          builder: (_,snapshot){
            final button =  TextButton(
                onPressed: ()=>cubit.pickRandomName(),
                child: const Text('Pick name')
            );
            switch(snapshot.connectionState){
              case ConnectionState.none:
                return Center(child: button);
              case ConnectionState.waiting:
                return Center(child: button);
              case ConnectionState.active:
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(snapshot.data ?? ''),
                      button
                    ],
                  ),
                );
              case ConnectionState.done:
                return const SizedBox();
            }
          }),
    );
  }
}
