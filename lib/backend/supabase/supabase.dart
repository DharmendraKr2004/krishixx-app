import 'package:supabase_flutter/supabase_flutter.dart';

export 'database/database.dart';

String _kSupabaseUrl = 'https://pjpaegjjynxnczwpvyqo.supabase.co';
String _kSupabaseAnonKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBqcGFlZ2pqeW54bmN6d3B2eXFvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzE1MjQ3MzgsImV4cCI6MjA4NzEwMDczOH0.q_0tDSZQilWZTy7dBuuUjMl5kkK5GKMBH2t6KhFB2iY';

class SupaFlow {
  SupaFlow._();

  static SupaFlow? _instance;
  static SupaFlow get instance => _instance ??= SupaFlow._();

  final _supabase = Supabase.instance.client;
  static SupabaseClient get client => instance._supabase;

  static Future initialize() => Supabase.initialize(
        url: _kSupabaseUrl,
        headers: {'X-Client-Info': 'flutterflow'},
        anonKey: _kSupabaseAnonKey,
        debug: false,
        authOptions:
            FlutterAuthClientOptions(authFlowType: AuthFlowType.implicit),
      );
}
