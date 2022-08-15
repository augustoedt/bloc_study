import 'package:bloc_study/screens/multibloc_provider_screen/bloc/app_bloc.dart';
import 'package:bloc_study/screens/multibloc_provider_screen/bloc/app_state.dart';
import 'package:bloc_study/screens/multibloc_provider_screen/bloc/bloc_events.dart';
import 'package:bloc_study/screens/multibloc_provider_screen/extensions/stream/start_with.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocView<T extends AppBloc> extends StatelessWidget {
  const AppBlocView({Key? key}) : super(key: key);

  void startUpdatingBloc(BuildContext context){
    Stream.periodic(
      const Duration(seconds: 10),
        (_)=> const LoadNextUrlEvent(),
    ).startWith(const LoadNextUrlEvent()).forEach((event) {
      context.read<T>().add(event);
    });
  }
  @override
  Widget build(BuildContext context) {
    startUpdatingBloc(context);
    return Expanded(
      child: BlocBuilder<T, AppState>(
          builder: (context, appState){
        if(appState.error != null){
          //error
          return const Text("An error occurred. Try again in a moment");
        } else if(appState.data != null) {
          //data
          return Image.memory(appState.data!, fit: BoxFit.fitHeight);
        } else {
          //loading
          return const Center(child: CircularProgressIndicator());
        }
      }),
    );
  }

}