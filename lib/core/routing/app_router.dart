import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/posts/presentation/pages/posts_page.dart';
import '../../features/posts/presentation/pages/create_post_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/counter/presentation/pages/counter_page.dart';
import '../../features/todo/presentation/pages/todo_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../widgets/error_widget.dart';

// Route names constants
class AppRoutes {
  static const String home = '/';
  static const String posts = '/posts';
  static const String createPost = '/posts/create';
  static const String postDetails = '/posts/:id';
  static const String profile = '/profile';
  static const String counter = '/counter';
  static const String todos = '/todos';
  static const String settings = '/settings';
  static const String notFound = '/404';
}

// Route parameters
class RouteParams {
  static const String postId = 'id';
  static const String userId = 'userId';
}


class AppRouter {
  static GoRouter createRouter(Ref ref) {
    return GoRouter(
      initialLocation: AppRoutes.home,
      debugLogDiagnostics: true,
      errorBuilder: (context, state) => _buildErrorPage(context, state),
      redirect: (context, state) => _handleRedirect(context, state, ref),
      routes: [
        // Home route
        GoRoute(
          path: AppRoutes.home,
          name: 'home',
          builder: (context, state) => const HomePage(),
        ),
        
        // Posts routes
        GoRoute(
          path: AppRoutes.posts,
          name: 'posts',
          builder: (context, state) => const PostsPage(),
          routes: [
            GoRoute(
              path: 'create',
              name: 'createPost',
              builder: (context, state) => const CreatePostPage(),
            ),
            GoRoute(
              path: ':id',
              name: 'postDetails',
              builder: (context, state) {
                final postId = int.tryParse(state.pathParameters[RouteParams.postId] ?? '');
                if (postId == null) {
                  return _buildErrorPage(context, state);
                }
                return _buildPostDetailsPage(context, postId);
              },
            ),
          ],
        ),
        
        // Profile route
        GoRoute(
          path: AppRoutes.profile,
          name: 'profile',
          builder: (context, state) => const ProfilePage(),
        ),
        
        // Counter route
        GoRoute(
          path: AppRoutes.counter,
          name: 'counter',
          builder: (context, state) => const CounterPage(),
        ),
        
        // Todos route
        GoRoute(
          path: AppRoutes.todos,
          name: 'todos',
          builder: (context, state) => const TodoPage(),
        ),
        
        // Settings route
        GoRoute(
          path: AppRoutes.settings,
          name: 'settings',
          builder: (context, state) => const SettingsPage(),
        ),
        
        // 404 route
        GoRoute(
          path: AppRoutes.notFound,
          name: 'notFound',
          builder: (context, state) => _buildNotFoundPage(context, state),
        ),
      ],
    );
  }

  // Handle redirects (for authentication, etc.)
  static String? _handleRedirect(BuildContext context, GoRouterState state, Ref ref) {
    // Example: Check if user is authenticated
    // final isAuthenticated = ref.read(authProvider).isAuthenticated;
    // if (!isAuthenticated && state.matchedLocation != '/login') {
    //   return '/login';
    // }
    
    // Example: Check if user has permission for certain routes
    // if (state.matchedLocation.startsWith('/admin') && !ref.read(userProvider).isAdmin) {
    //   return '/unauthorized';
    // }
    
    return null; // No redirect needed
  }

  // Build error page
  static Widget _buildErrorPage(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: CustomErrorWidget(
        message: 'Page not found: ${state.matchedLocation}',
        onRetry: () => context.go(AppRoutes.home),
      ),
    );
  }

  // Build not found page
  static Widget _buildNotFoundPage(BuildContext context, GoRouterState state) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            const Text(
              'Page Not Found',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'The page "${state.matchedLocation}" does not exist.',
              style: const TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }

  // Build post details page (placeholder)
  static Widget _buildPostDetailsPage(BuildContext context, int postId) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Post $postId'),
      ),
      body: Center(
        child: Text('Post details for ID: $postId'),
      ),
    );
  }
}

// Navigation service for easy navigation
class NavigationService {
  static void goToHome(BuildContext context) {
    context.go(AppRoutes.home);
  }

  static void goToPosts(BuildContext context) {
    context.go(AppRoutes.posts);
  }

  static void goToCreatePost(BuildContext context) {
    context.go(AppRoutes.createPost);
  }

  static void goToPostDetails(BuildContext context, int postId) {
    context.go('${AppRoutes.posts}/$postId');
  }

  static void goToProfile(BuildContext context) {
    context.go(AppRoutes.profile);
  }

  static void goToCounter(BuildContext context) {
    context.go(AppRoutes.counter);
  }

  static void goToTodos(BuildContext context) {
    context.go(AppRoutes.todos);
  }

  static void goToSettings(BuildContext context) {
    context.go(AppRoutes.settings);
  }

  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(AppRoutes.home);
    }
  }

  // Push routes (for modal-like navigation)
  static void pushToCreatePost(BuildContext context) {
    context.push(AppRoutes.createPost);
  }

  static void pushToSettings(BuildContext context) {
    context.push(AppRoutes.settings);
  }
} 