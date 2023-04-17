import 'package:schedurio/config.dart';
import 'package:supabase/supabase.dart';

final supabase = SupabaseClient(AppConfig.supabaseUrl, AppConfig.supabaseToken);
