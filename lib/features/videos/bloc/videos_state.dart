import 'package:equatable/equatable.dart';
import 'package:guruji/features/videos/models/video_model.dart';

abstract class VideosState extends Equatable {
  const VideosState();

  @override
  List<Object?> get props => [];
}

class VideosInitial extends VideosState {
  const VideosInitial();
}

class VideosLoading extends VideosState {
  const VideosLoading();
}

class VideosLoadSuccess extends VideosState {
  final VideosResponse videosResponse;

  const VideosLoadSuccess(this.videosResponse);

  @override
  List<Object?> get props => [videosResponse];
}

class VideosFailure extends VideosState {
  final String message;

  const VideosFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
