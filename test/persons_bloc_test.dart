import 'package:bloc_study/block/bloc_action.dart';
import 'package:bloc_study/block/persons_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:bloc_study/block/person.dart';

const mockedPersons1  = [
  Person(
      age: 10,
      name: "Foo 1"
  ),
  Person(
      age: 20,
      name: "Bar 1"
  ),
];

const mockedPersons2  = [
  Person(
      age: 10,
      name: "Foo 2"
  ),
  Person(
      age: 20,
      name: "Bar 2"
  ),
];

Future<Iterable<Person>> mockGetPerson1(String _) => Future.value(mockedPersons1);
Future<Iterable<Person>> mockGetPerson2(String _) => Future.value(mockedPersons2);

void main(){
  group('Testing bloc', (){

    late PersonsBloc bloc;

    setUp((){
      bloc = PersonsBloc();
    });

    blocTest<PersonsBloc, FetchResult?>(
      "Test initial state",
      build: ()=>bloc,
      // verify: (bloc) => expect(bloc.state, const FetchResult(isRetrieveFromCache: false, persons: [])),
      verify: (bloc) => expect(bloc.state, null),
    );

    blocTest<PersonsBloc, FetchResult?>(
      "Mock retrieving persons from first iterable list",
      build: ()=>bloc,
      act: (bloc){
        bloc.add(const LoadPersonAction(url: "dummy_url_1", loader: mockGetPerson1));
        bloc.add(const LoadPersonAction(url: "dummy_url_1", loader: mockGetPerson1));
      },
      expect: () => [
        const FetchResult(isRetrieveFromCache: false, persons: mockedPersons1),
        const FetchResult(isRetrieveFromCache: true, persons: mockedPersons1),
      ]
    );
    blocTest<PersonsBloc, FetchResult?>(
        "Mock retrieving persons from second iterable list",
        build: ()=>bloc,
        act: (bloc){
          bloc.add(const LoadPersonAction(url: "dummy_url_2", loader: mockGetPerson2));
          bloc.add(const LoadPersonAction(url: "dummy_url_2", loader: mockGetPerson2));
        },
        expect: () => [
          const FetchResult(isRetrieveFromCache: false, persons: mockedPersons2),
          const FetchResult(isRetrieveFromCache: true, persons: mockedPersons2),
        ]
    );

  });
}
