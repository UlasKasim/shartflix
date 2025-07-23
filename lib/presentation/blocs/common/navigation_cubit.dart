import 'package:flutter_bloc/flutter_bloc.dart';

enum NavigationPage { home, profile }

class NavigationCubit extends Cubit<NavigationPage> {
  NavigationCubit() : super(NavigationPage.home);

  void setCurrentPage(NavigationPage page) {
    emit(page);
  }

  bool get isHomePage => state == NavigationPage.home;
  bool get isProfilePage => state == NavigationPage.profile;
}
