
import 'package:bloc/bloc.dart';
import 'package:bloc_study/screens/second_screen/block/person.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'bloc_action.dart';


extension IsEqualtoIgnoringOrdering<T> on Iterable<T>{
  bool isEqualToIgnoringOrdering(Iterable<T> other) =>
      length == other.length && {...this}.intersection({...other}).length == length;
}

// service

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

  @override bool operator == (covariant FetchResult other) =>
      persons.isEqualToIgnoringOrdering(other.persons) &&
      isRetrieveFromCache == other.isRetrieveFromCache;

  @override
  int get hashCode => Object.hash(persons, isRetrieveFromCache);
}

class PersonsBloc extends Bloc<LoadAction, FetchResult?> {
  final  Map<String, Iterable<Person>> _cache = {};
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
          final loader = event.loader;
          final persons = await loader(url);
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
