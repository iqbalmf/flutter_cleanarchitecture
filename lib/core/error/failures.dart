import 'package:equatable/equatable.dart';

/**
 * Created by IqbalMF on 2022.
 * Package
 */

abstract class Failure extends Equatable {
  Failure([List properties = const <dynamic>[]]);
}


//General Failures
class ServerFailure extends Failure {
  @override
  List<Object?> get props => [];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}
