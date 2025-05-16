import 'package:dio/dio.dart';
import 'package:agrirent/config/supabase_config.dart';

final dio = Dio()
  ..interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        final session = SupabaseConfig.supabase.auth.currentSession;
        if (session != null) {
          options.headers['Authorization'] = 'Bearer ${session.accessToken}';
        }
        return handler.next(options);
      },
    ),
  );
