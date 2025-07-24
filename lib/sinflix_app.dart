import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/injection/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'l10n/generated/app_localizations.dart';
import 'presentation/blocs/auth/auth_bloc.dart';
import 'presentation/blocs/common/navigation_cubit.dart';
import 'presentation/blocs/movie/movie_bloc.dart';
import 'presentation/blocs/profile/profile_bloc.dart';
import 'presentation/routes/app_router.dart';

class SinflixApp extends StatelessWidget {
  const SinflixApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(create: (_) => sl<AuthBloc>()),
        BlocProvider<MovieBloc>(create: (_) => sl<MovieBloc>()),
        BlocProvider<ProfileBloc>(create: (_) => sl<ProfileBloc>()),
        BlocProvider<NavigationCubit>(create: (_) => NavigationCubit()),
      ],
      child: MaterialApp.router(
        title: 'Sinflix',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.darkTheme,
        themeMode: ThemeMode.dark,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: AppLocalizations.supportedLocales
            .firstWhere((l) => l.languageCode == "tr"),
        routerConfig: AppRouter.router,
      ),
    );
  }
}
