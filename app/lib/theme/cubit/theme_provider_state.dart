// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_provider_cubit.dart';

class ThemeProviderState {
  final ThemeMode mode;
  final bool onDone;
  ThemeProviderState({
    required this.mode,
    required this.onDone,
  });

  factory ThemeProviderState.initial() {
    return ThemeProviderState(mode: ThemeMode.system, onDone: false);
  }

  ThemeProviderState copyWith({
    ThemeMode? mode,
    bool? onDone,
  }) {
    return ThemeProviderState(
      mode: mode ?? this.mode,
      onDone: onDone ?? this.onDone,
    );
  }
}
