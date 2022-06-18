import 'package:flutter/material.dart';

import '../common/constants/route_constants.dart';
import 'views/favorite/favorite_screen.dart';
import 'views/home/home_screen.dart';
import 'views/movie_detail/movie_detail_arguments.dart';
import 'views/movie_detail/movie_detail_screen.dart';

class Routes {
  static Map<String, WidgetBuilder> getRoutes(RouteSettings setting) => {
        RouteList.initial: (context) => const HomeScreen(),
        RouteList.home: (context) => const HomeScreen(),
        RouteList.movieDetail: (context) => MovieDetailScreen(
              movieDetailArguments: setting.arguments as MovieDetailArguments,
            ),
        RouteList.favorite: (context) => const FavoriteScreen(),
      };
}
