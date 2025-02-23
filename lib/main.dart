import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:workout_tracker/core/config/supabase_config.dart';
import 'package:workout_tracker/features/home/presentation/pages/home_page.dart';
import 'package:workout_tracker/features/workouts/presentation/cubit/workouts_cubit.dart';
import 'package:workout_tracker/features/exercises/presentation/cubit/exercises_cubit.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Supabase
  await SupabaseConfig.initialize();
  
  await SentryFlutter.init(
    (options) {
      options.dsn = 'https://9fd643d1d605707829c41a93a36ca05e@o673219.ingest.us.sentry.io/4508865283948544';
      options.debug = true;
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
      options.enableAutoPerformanceTracing = true;
      options.captureFailedRequests = true;
    },
    appRunner: () => runApp(SentryWidget(child: const MyApp())),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<WorkoutsCubit>(
          create: (context) => WorkoutsCubit(),
        ),
        BlocProvider<ExercisesCubit>(
          create: (context) => ExercisesCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Workout Tracker',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const HomePage(),
      ),
    );
  }
}
