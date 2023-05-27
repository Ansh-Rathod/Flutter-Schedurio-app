import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../apis/gif_picker.dart';
import '../../../models/gif_model.dart';

part 'gif_picker_state.dart';

class GifPickerCubit extends Cubit<GifPickerState> {
  GifPickerCubit() : super(GifPickerState.initialize());

  final repo = GifPickerRepo();
  void init() async {
    try {
      emit(state.copyWith(status: ProcessStatus.loading, isResults: false));

      final gifs = await repo.getTrending();
      emit(state.copyWith(
        files: gifs,
        status: ProcessStatus.loaded,
      ));
    } catch (e) {
      emit(state.copyWith(status: ProcessStatus.failed));
    }
  }

  void search(String text) async {
    try {
      emit(state.copyWith(status: ProcessStatus.loading, isResults: true));

      final gifs = await repo.getSerachResult(text);
      emit(state.copyWith(
        status: ProcessStatus.loaded,
        results: gifs,
      ));
    } catch (e) {
      emit(state.copyWith(status: ProcessStatus.failed));
    }
  }

  void back() => emit(state.copyWith(isResults: false));
}
