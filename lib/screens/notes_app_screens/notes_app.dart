import 'package:bloc_study/api/login_api.dart';
import 'package:bloc_study/api/notes_api.dart';
import 'package:bloc_study/bloc/actions.dart';
import 'package:bloc_study/bloc/app_bloc.dart';
import 'package:bloc_study/bloc/app_states.dart';
import 'package:bloc_study/components/interable_list_view.dart';
import 'package:bloc_study/dialog/generic_dialog.dart';
import 'package:bloc_study/dialog/loadind_screen.dart';
import 'package:bloc_study/models.dart';
import 'package:bloc_study/screens/notes_app_screens/login_view.dart';
import 'package:bloc_study/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotesApp extends StatelessWidget {
  static const String namePath = '/notesApp';

  const NotesApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context)=>
          AppBloc(
              loginApi: LoginApi(),
              notesApi: NotesApi()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(homePage),
        ),
        body: BlocConsumer<AppBloc, AppState>(
          listener: (context, appState){
            //loading screen
            if(appState.isLoading){
              LoadingScreen.instance().show(
                  context: context,
                  text: pleaseWait);
            } else {
              LoadingScreen.instance().hide();
            }

            final loginError = appState.loginErrors;
            if(loginError!= null){
              showGenericDialog(
                  context: context,
                  content: loginErrorDialogContent,
                  title: loginErrorDialogTitle,
                  optionsBuilder:()=>{ok: true}
              );
            }
            if(
            appState.isLoading == false &&
                appState.loginErrors == null &&
                appState.loginHandle == const LoginHandle.fooBar() &&
                appState.fetchedNotes == null
            ){
              context.read<AppBloc>().add(const LoadNotesAction());
            }
          },
          builder: (context, appState){
            final notes = appState.fetchedNotes;
            if(notes == null){
              return LoginView(
                  onLoginTapped: (email, password){
                    context.read<AppBloc>().add(
                        LoginAction(email: email, password: password));}
              );
            }
            else{
              return notes.toListView();
            }
          },
        ),
      ),
    );
  }
}
