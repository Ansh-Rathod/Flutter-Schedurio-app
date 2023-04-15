import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'theme_provider_state.dart';

class ThemeProviderCubit extends Cubit<ThemeProviderState> {
  ThemeProviderCubit() : super(ThemeProviderState.initial());

  void setTheme(ThemeMode mode) {
    emit(ThemeProviderState(mode: mode, onDone: false));
  }

  void onDone() {
    emit(state.copyWith(onDone: true));
  }
}
