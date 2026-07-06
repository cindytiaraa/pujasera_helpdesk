import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class SupabaseService {
  static final client = Supabase.instance.client;
  static const uuid = Uuid();
  
}