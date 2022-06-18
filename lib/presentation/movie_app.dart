import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../common/constants/languages.dart';
import '../common/constants/route_constants.dart';
import '../common/screenutil/screenutil.dart';
import '../di/get_it.dart';
import 'app_localizations.dart';
import 'cubits/languages/language_cubit.dart';
import 'cubits/loading/loading_cubit.dart';
import 'cubits/theme/theme_cubit.dart';
import 'fade_page_route_builder.dart';
import 'routes.dart';
import 'styles/theme_color.dart';
import 'styles/theme_text.dart';
import 'views/loading/loading_screen.dart';
import 'wiredash_app.dart';

class MovieApp extends StatefulWidget {
  const MovieApp({Key? key}) : super(key: key);

  @override
  State<MovieApp> createState() => _MovieAppState();
}

class _MovieAppState extends State<MovieApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late LanguageCubit _languageCubit;
  late LoadingCubit _loadingCubit;
  late ThemeCubit _themeCubit;

  @override
  void initState() {
    super.initState();
    _languageCubit = getItInstance<LanguageCubit>();
    _languageCubit.loadPreferredLanguage();
    _loadingCubit = getItInstance<LoadingCubit>();
    _themeCubit = getItInstance<ThemeCubit>();
    _themeCubit.loadPreferredTheme();
  }

  @override
  void dispose() {
    _languageCubit.close();
    _loadingCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init();
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>.value(value: _languageCubit),
        BlocProvider<LoadingCubit>.value(value: _loadingCubit),
        BlocProvider<ThemeCubit>.value(value: _themeCubit),
      ],
      child: BlocBuilder<ThemeCubit, Themes>(
        builder: (context, theme) {
          return BlocBuilder<LanguageCubit, Locale>(
            builder: (context, locale) {
              return WiredashApp(
                navigatorKey: _navigatorKey,
                languageCode: locale.languageCode,
                child: MaterialApp(
                  navigatorKey: _navigatorKey,
                  debugShowCheckedModeBanner: false,
                  title: 'Movie App',
                  theme: ThemeData(
                    unselectedWidgetColor: AppColor.royalBlue,
                    primaryColor:
                        theme == Themes.dark ? AppColor.vulcan : Colors.white,
                    scaffoldBackgroundColor:
                        theme == Themes.dark ? AppColor.vulcan : Colors.white,
                    colorScheme: Theme.of(context).colorScheme.copyWith(
                          background: const Color(0xFF000000),
                          onBackground: const Color(0xFF2e2e2e),
                          primary: const Color(0xFF6553D9),
                          onPrimary: const Color(0xFFeeeeee),
                          brightness: Brightness.dark,
                        ),
                    brightness: theme == Themes.light
                        ? Brightness.light
                        : Brightness.dark,
                    cardTheme: CardTheme(
                      color:
                          theme == Themes.dark ? Colors.white : AppColor.vulcan,
                    ),
                    visualDensity: VisualDensity.adaptivePlatformDensity,
                    textTheme: theme == Themes.dark
                        ? ThemeText.getTextTheme()
                        : ThemeText.getLightTextTheme(),
                    appBarTheme: const AppBarTheme(elevation: 0),
                    inputDecorationTheme: InputDecorationTheme(
                      hintStyle: Theme.of(context).textTheme.greySubtitle1,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: theme == Themes.dark
                              ? Colors.white
                              : AppColor.vulcan,
                        ),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey)),
                    ),
                    // colorScheme: ColorScheme.fromSwatch()
                    //     .copyWith(secondary: AppColor.royalBlue),
                  ),
                  supportedLocales:
                      Languages.languages.map((e) => Locale(e.code)).toList(),
                  locale: locale,
                  localizationsDelegates: const [
                    AppLocalizations.delegate,
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                  ],
                  builder: (context, child) {
                    return LoadingScreen(
                      screen: child!,
                    );
                  },
                  initialRoute: RouteList.initial,
                  onGenerateRoute: (RouteSettings settings) {
                    final routes = Routes.getRoutes(settings);
                    final WidgetBuilder? builder = routes[settings.name];
                    return FadePageRouteBuilder(
                      builder: builder!,
                      settings: settings,
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
