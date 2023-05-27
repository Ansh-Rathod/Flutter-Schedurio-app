part of 'gif_picker_cubit.dart';

enum ProcessStatus { inital, loading, loaded, failed }

class GifPickerState {
  final List<GifModel> files;
  final ProcessStatus status;
  final List<GifModel> results;
  final bool isResults;
  GifPickerState({
    required this.files,
    required this.status,
    required this.results,
    required this.isResults,
  });

  factory GifPickerState.initialize() {
    return GifPickerState(
      results: [],
      files: [],
      status: ProcessStatus.inital,
      isResults: false,
    );
  }

  GifPickerState copyWith({
    List<GifModel>? files,
    ProcessStatus? status,
    List<GifModel>? results,
    bool? isResults,
  }) {
    return GifPickerState(
      files: files ?? this.files,
      status: status ?? this.status,
      results: results ?? this.results,
      isResults: isResults ?? this.isResults,
    );
  }
}
