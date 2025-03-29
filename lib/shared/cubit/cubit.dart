import 'package:ai_powered_skin_disease_detection_application/shared/cubit/states.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class appcubit extends Cubit<appstates> {
  appcubit() :super (initialstate()) {
    //initlize methods here
  }
  static appcubit get(context) => BlocProvider.of(context);
  void method(){

  }

  //all cubit methods will be put here
}