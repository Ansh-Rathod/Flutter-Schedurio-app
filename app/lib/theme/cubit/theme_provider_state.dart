// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_provider_cubit.dart';

class ThemeProviderState {
  final ThemeMode mode;
  ThemeProviderState({
    required this.mode,
  });

  factory ThemeProviderState.initial() {
    return ThemeProviderState(
      mode: ThemeMode.system,
    );
  }
}
