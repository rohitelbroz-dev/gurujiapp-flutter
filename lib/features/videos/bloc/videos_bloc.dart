import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:guruji/features/videos/bloc/videos_event.dart';
import 'package:guruji/features/videos/bloc/videos_state.dart';
import 'package:guruji/features/videos/data/videos_repository.dart';

class VideosBloc extends Bloc<VideosEvent, VideosState> {
  final VideosRepository videosRepository;

  VideosBloc({required this.videosRepository}) : super(const VideosInitial()) {
    on<FetchVideosEvent>(_onFetchVideos);
  }

  Future<void> _onFetchVideos(FetchVideosEvent event, Emitter<VideosState> emit) async {
    emit(const VideosLoading());
    try {
      final videosResponse = await videosRepository.fetchVideos(
        page: event.page,
        limit: event.limit,
        type: event.type,
      );
      emit(VideosLoadSuccess(videosResponse));
    } catch (e) {
      emit(VideosFailure(message: e.toString().replaceAll('Exception: ', '')));
    }
  }
}
