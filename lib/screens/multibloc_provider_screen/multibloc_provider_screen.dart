import 'package:bloc_study/screens/multibloc_provider_screen/bloc/bottom_bloc.dart';
import 'package:bloc_study/screens/multibloc_provider_screen/bloc/top_bloc.dart';
import 'package:bloc_study/screens/multibloc_provider_screen/models/constants.dart';
import 'package:bloc_study/screens/multibloc_provider_screen/views/app_bloc_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MultiBlocProviderScreen extends StatelessWidget {

  static const namePath = "/multiBlocProvider";
  const MultiBlocProviderScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle .dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider<TopBloc>(create: (_)=> TopBloc(
                waitBeforeLoading: const  Duration(seconds: 3),
                urls:images
            )),
            BlocProvider<BottomBloc>(create: (_)=> BottomBloc(
                waitBeforeLoading: const  Duration(seconds: 3),
                urls: images
            ))
          ],
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: const [
              AppBlocView<TopBloc>(),
              AppBlocView<BottomBloc>()
            ],
          ),
        ),
      ),
    );
  }
}
