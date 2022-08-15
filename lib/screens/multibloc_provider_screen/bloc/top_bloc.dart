import 'package:bloc_study/screens/multibloc_provider_screen/bloc/app_bloc.dart';

class TopBloc extends AppBloc{
  TopBloc({
    Duration?  waitBeforeLoading,
    required Iterable<String> urls
  }): super(
    waitBeforeLoading: waitBeforeLoading,
    urls: urls,
  );
}