import 'dart:convert';
import 'dart:io';

import 'package:bloc_study/screens/second_screen/block/bloc_action.dart';
import 'package:bloc_study/screens/second_screen/block/person.dart';
import 'package:bloc_study/screens/second_screen/block/persons_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'dart:developer' as devtools show log;

extension Log on Object {
  void log() => devtools.log(toString());
}

Future<Iterable<Person>> getPersons(String url)=> HttpClient()
    .getUrl(Uri.parse(url))
    .then((req)=>req.close())
    .then((resp)=>resp.transform(utf8.decoder).join())
    .then((str)=>json.decode(str) as List<dynamic>)
    .then((list)=>list.map((e) => Person.fromJson(e)));


extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class SecondScreen extends StatefulWidget {
  static const namePath = "/second_example";

  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title:  const Text("Second Example"),
        ),
        body: Column(
          children: [
            Row(
              children: [
                TextButton(onPressed: (){
                  context.read<PersonsBloc>()
                      .add(const LoadPersonAction(
                      url: persons1Url, loader: getPersons));
                }, child: const Text("Load Json 1#")),
                TextButton(onPressed: (){
                  context.read<PersonsBloc>()
                      .add(const LoadPersonAction(
                      url: persons2Url, loader: getPersons));
                }, child: const Text("Load Json 2#")),
              ],
            ),
            BlocBuilder<PersonsBloc, FetchResult?>(
                buildWhen: (previousResult, currentResult){
                  return previousResult?.persons != currentResult?.persons;
                },
                builder: (_,fetchResult){
                  final persons = fetchResult?.persons;
                  if(persons==null){
                    return const SizedBox();
                  }
                  return Expanded(
                    child: ListView.builder(
                      itemCount: persons.length,
                      itemBuilder: (_,index){
                        final person = persons[index]!;
                        return ListTile(title: Text(person.name));
                      },
                    ),
                  );
                }
            )
          ],
        )
    );
  }
}
