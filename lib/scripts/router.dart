import 'package:go_router/go_router.dart';
import 'package:mbl_am/screens/adm/adm_screen.dart';
import 'package:mbl_am/screens/adm/auth_screen.dart';
import 'package:mbl_am/screens/adm/create_news.dart';
import 'package:mbl_am/screens/home_screen/home_screen.dart';
import 'package:mbl_am/screens/news_details/news_details.dart';
import 'package:mbl_am/screens/noticias_screen/noticias_screen.dart';

final GoRouter router = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) {
        return const HomeScreen();
      },
    ),
    GoRoute(
      path: '/createNews',
      builder: (context, state) {
        return const CreateNews();
      },
    ),
    GoRoute(
      path: '/auth',
      builder: (context, state) {
        return const AuthScreen();
      },
    ),
    GoRoute(
      path: '/adm',
      builder: (context, state) {
        return const AdmScreen();
      },
    ),
    GoRoute(
      path: '/noticias',
      builder: (context, state) {
        return const NoticiasScreen();
      },
    ),
    GoRoute(
      path: '/noticias/:id',
      builder: (context, state) {
        String newId = state.pathParameters['id']!;
        return NewsDetails(newsData: newId);
      },
    ),
  ],
);