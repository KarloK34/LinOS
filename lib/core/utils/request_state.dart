import 'package:equatable/equatable.dart';

sealed class RequestState<T> extends Equatable {
  const RequestState();

  @override
  List<Object?> get props => [];
}

class RequestInitial<T> extends RequestState<T> {
  const RequestInitial();
}

class RequestLoading<T> extends RequestState<T> {
  const RequestLoading();
}

class RequestSuccess<T> extends RequestState<T> {
  final T data;
  const RequestSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class RequestError<T> extends RequestState<T> {
  final String message;
  const RequestError(this.message);

  @override
  List<Object?> get props => [message];
}
