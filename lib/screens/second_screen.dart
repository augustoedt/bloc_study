import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@immutable
abstract class LoadAction{
  const LoadAction();
}

@immutable
class LoadPersonAction extends LoadAction {
  final PersonUrl url;

  const LoadPersonAction({required this.url}): super();

}

@immutable
class Person {
  final String name;
  final num age;

  const Person({required this.name,required this.age});

  Person.fromJson(Map<String,dynamic> json) :
        name = json["name"] as String,
        age = json["age"] as int;
}

// service
Future<Iterable<Person>> getPersons(String url)=> HttpClient()
    .getUrl(Uri.parse(url))
    .then((req)=>req.close())
    .then((resp)=>resp.transform(utf8.decoder).join())
    .then((str)=>json.decode(str) as List<dynamic>)
    .then((list)=>list.map((e) => Person.fromJson(e)));

@immutable
class FetchResult {
  final Iterable<Person> persons;
  final bool isRetrieveFromCache;

  const FetchResult({
    required this.isRetrieveFromCache,
    required this.persons
  });

  @override
  String toString()=> 'FetchResult (isRetrievedFromCache = $isRetrieveFromCache, persons = $persons)';
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final  Map<PersonUrl, Iterable<Person>> _cache = {};
  PersonsBloc() : super(null){
    on<LoadPersonAction>(
          (event, emit) async {
        final url = event.url;
        if(_cache.containsKey(url)){
          final cachePersons = _cache[url]!;
          final result= FetchResult(
              isRetrieveFromCache: true,
              persons: cachePersons);
          emit(result);
        }else {
          final persons = await getPersons(url.urlString);
          _cache[url] = persons;
          final result= FetchResult(
              isRetrieveFromCache: false,
              persons: persons);
          emit(result);
        }
      },
    );
  }
}

enum PersonUrl {
  person1,
  person2
}

extension UrlString on PersonUrl {
  String get urlString {
    switch(this){
      case PersonUrl.person1:
        return "localhost:8000/persons1";
      case PersonUrl.person2:
        return "localhost:8000/persons2";
    }
  }
}

const Iterable<String> names = ['foo', 'bar'];

void testIt(){
  final String baz = names[1];
}

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
                  context.read<PersonsBloc>().add(const LoadPersonAction(url: PersonUrl.person1));
                }, child: const Text("Load Json 1#")),
                TextButton(onPressed: (){
                  context.read<PersonsBloc>().add(const LoadPersonAction(url: PersonUrl.person2));
                }, child: const Text("Load Json 2#")),
              ],
            ),
            BlocBuilder<PersonsBloc, FetchResult?>(
                buildWhen: (previous, state){

                },
                builder: (_,state){

                }
            )
          ],
        )
    );
  }
}
