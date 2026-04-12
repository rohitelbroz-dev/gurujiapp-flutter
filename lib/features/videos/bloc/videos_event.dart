import 'package:equatable/equatable.dart';

abstract class VideosEvent extends Equatable {
  const VideosEvent();

  @override
  List<Object?> get props => [];
}

class FetchVideosEvent extends VideosEvent {
  final int page;
  final int limit;
  final String type;

  const FetchVideosEvent({
    this.page = 1,
    this.limit = 10,
    this.type = 'regular',
  });

  @override
  List<Object?> get props => [page, limit, type];
}
