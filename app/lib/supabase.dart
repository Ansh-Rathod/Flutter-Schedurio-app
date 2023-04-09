import 'package:supabase/supabase.dart';

final supabase = SupabaseClient('https://ymqribzzaqwkxsfervlb.supabase.co',
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InltcXJpYnp6YXF3a3hzZmVydmxiIiwicm9sZSI6ImFub24iLCJpYXQiOjE2ODA4NjA3NjksImV4cCI6MTk5NjQzNjc2OX0.PqDSfGGW42riZfbThw0YFiZhNJS-PEIy0-WSTsEuRHY');


final rows = await supabase
      .from('tweets')
      .select('*')
      .limit(100)
      .range(int.parse(page) * 100, int.parse(page) * 100 + 100)
      .order('posted_at', ascending: false);