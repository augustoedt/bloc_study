import 'package:bloc_study/api/login_api.dart';
import 'package:bloc_study/api/notes_api.dart';
import 'package:bloc_study/screens/notes_app_screens/bloc/actions.dart';
import 'package:bloc_study/screens/notes_app_screens/bloc/app_bloc.dart';
import 'package:bloc_study/screens/notes_app_screens/bloc/app_states.dart';
import 'package:bloc_study/screens/notes_app_screens/models.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:flutter_test/flutter_test.dart';


const Iterable<Note> mockNotes = [
  Note(title: "Note 1"),
  Note(title: "Note 2"),
  Note(title: "Note 3"),
];

@immutable
class DummyNotesApi implements NotesApiProtocol{
  final LoginHandle acceptedLoginHandle;
  final Iterable<Note>? notesToReturnForAcceptedLoginHandle;

  const DummyNotesApi({
    required this.acceptedLoginHandle,
    required this.notesToReturnForAcceptedLoginHandle
  });

  const DummyNotesApi.empty()
      : acceptedLoginHandle = const LoginHandle.fooBar(),
        notesToReturnForAcceptedLoginHandle = null;

  @override
  Future<Iterable<Note>?> getNotes({
    required LoginHandle loginHandle,
  }) async {
    if(loginHandle == acceptedLoginHandle){
      return notesToReturnForAcceptedLoginHandle;
    }
    else {
      return null;
    }
  }
}

@immutable
class DummyLoginApi implements LoginApiProtocol{
  final String acceptedEmail;
  final String acceptedPassword;
  final LoginHandle handleToReturn;

  const DummyLoginApi({
    required this.acceptedEmail,
    required this.acceptedPassword,
    required this.handleToReturn
  });

  const DummyLoginApi.empty()
      : acceptedEmail = '',
        acceptedPassword = '',
        handleToReturn = const LoginHandle.fooBar();
  @override
  Future<LoginHandle?> login({
    required String email,
    required String password
  }) async {
    if(email == acceptedEmail && password == acceptedPassword){
      return handleToReturn;
    }else{
      return null;
    }
  }
}

void main(){

  const LoginHandle acceptedLoginHandle = LoginHandle(token: 'ABC');

  blocTest<AppBloc, AppState>(
    'Initial State: AppState.empty()',
    build: ()=>AppBloc(
        loginApi: const DummyLoginApi.empty(),
        notesApi: const  DummyNotesApi.empty(),
        acceptedLoginHandle: acceptedLoginHandle
    ),
    verify: (appState)=>expect(
        appState.state,
        const AppState.empty()),
  );

  blocTest<AppBloc, AppState>(
      'Can we login with correct credentials',
      build: ()=>AppBloc(
        loginApi: const DummyLoginApi(
            acceptedEmail: 'bar@baz.com',
            acceptedPassword: 'foo',
            handleToReturn: LoginHandle(token: 'ABC')
        ),
        notesApi: const  DummyNotesApi.empty(),
        acceptedLoginHandle: acceptedLoginHandle
      ),
      act: (appBloc) => appBloc.add(
        const LoginAction(email: 'bar@baz.com', password: 'foo'),
      ),
      expect: ()=>[
        const AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: null,
            fetchedNotes: null),
        const AppState(
            isLoading: false,
            loginErrors: null,
            loginHandle: acceptedLoginHandle,
            fetchedNotes: null),
      ]
  );

  blocTest<AppBloc, AppState>(
      'Handle invalid credentials.',
      build: ()=>AppBloc(
        loginApi: const DummyLoginApi(
            acceptedEmail: 'foo@bar.com',
            acceptedPassword: 'baz',
            handleToReturn: acceptedLoginHandle
        ),
        notesApi: const  DummyNotesApi.empty(),
        acceptedLoginHandle: acceptedLoginHandle
      ),
      act: (appBloc) => appBloc.add(
        const LoginAction(email: 'bar@baz.com', password: 'foo'),
      ),
      expect: ()=>[
        const AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: null,
            fetchedNotes: null),
        const AppState(
            isLoading: false,
            loginErrors: LoginErrors.invalidHandle,
            loginHandle: null,
            fetchedNotes: null),
      ]
  );


  blocTest<AppBloc, AppState>(
      'Handle invalid credentials.',
      build: ()=>AppBloc(
        loginApi: const DummyLoginApi(
            acceptedEmail: 'foo@bar.com',
            acceptedPassword: 'baz',
            handleToReturn: acceptedLoginHandle
        ),
        notesApi: const DummyNotesApi(
          acceptedLoginHandle: acceptedLoginHandle,
          notesToReturnForAcceptedLoginHandle: mockNotes,
        ),
        acceptedLoginHandle: acceptedLoginHandle
      ),
      act: (appBloc){
        appBloc.add(const LoginAction(email: 'foo@bar.com', password: 'baz'));
        appBloc.add(const LoadNotesAction());
      },
      expect: ()=>[
        const AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: null,
            fetchedNotes: null),
        const AppState(
            isLoading: false,
            loginErrors: null,
            loginHandle: acceptedLoginHandle,
            fetchedNotes: null),
        const AppState(
            isLoading: true,
            loginErrors: null,
            loginHandle: acceptedLoginHandle,
            fetchedNotes: null),
        const AppState(
            isLoading: false,
            loginErrors: null,
            loginHandle: acceptedLoginHandle,
            fetchedNotes: mockNotes),
      ]
  );
}