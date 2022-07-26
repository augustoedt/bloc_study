import 'package:bloc_study/screens/second_screen/block/person.dart';
import 'package:flutter/foundation.dart' show immutable;

typedef PersonsLoader = Future<Iterable<Person>> Function(String url);

@immutable
abstract class LoadAction{
  const LoadAction();
}

@immutable
class LoadPersonAction extends LoadAction {
  final String url;
  final PersonsLoader loader;
  const LoadPersonAction({
    required this.url,
    required this.loader
  }): super();
}

enum PersonUrl {
  person1,
  person2
}
const persons1Url = "http://localhost:8000/persons1";
const persons2Url = "http://localhost:8000/persons2";