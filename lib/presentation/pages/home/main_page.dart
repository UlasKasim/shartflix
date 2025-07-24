import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:shartflix/core/core.dart';
import 'package:shartflix/presentation/blocs/blocs.dart';
import 'package:shartflix/presentation/widgets/widgets.dart';

class MainPage extends StatelessWidget {
  final Widget child;

  const MainPage({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: AppTheme.backgroundDark,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: AppTheme.backgroundDark,
        body: Stack(
          children: [
            // Main content - full screen
            child,

            // Gradient + Navigation Column
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BlocBuilder<NavigationCubit, NavigationPage>(
                builder: (context, currentPage) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Gradient transition - only show on home page
                      if (currentPage == NavigationPage.home)
                        Container(
                          height: 40,
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                AppTheme.backgroundDark,
                              ],
                            ),
                          ),
                        ),

                      // Bottom Navigation with SafeArea
                      Container(
                        color: AppTheme.backgroundDark,
                        child: Container(
                          height: 72 + MediaQuery.of(context).padding.bottom,
                          alignment: Alignment.center,
                          child: const CustomBottomNavigation(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
