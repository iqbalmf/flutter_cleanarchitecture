import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/core/platform/network_info.dart';
import 'package:clean_architecture/data/datasource/local/number_trivia_local_data_source.dart';
import 'package:clean_architecture/data/datasource/remote/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/data/models/number_trivia_model.dart';
import 'package:clean_architecture/domain/entity/number_trivia.dart';
import 'package:clean_architecture/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

typedef Future<NumberTrivia>? _ConcreteOrRandomChoose();

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl(
      {required this.remoteDataSource,
      required this.localDataSource,
      required this.networkInfo});

  @override
  Future<Either<Failure, NumberTrivia>>? getConcreteNumberTrivia(int? number) async {
    return await _getTrivia(() {
      return remoteDataSource.getConcreteNumberTrivia(number);
    });
  }

  @override
  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia() async {
    return await _getTrivia(() {
      return remoteDataSource.getRandomNumberTrivia();
    });
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandomChoose getConcreteOrRandom) async {
    if (await networkInfo.isConnected ?? false) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.setCacheNumberTrivia(NumberTriviaModel(text: remoteTrivia?.text ?? '', number: remoteTrivia?.number ?? 0));
        return Right(remoteTrivia ?? NumberTriviaModel(text: '', number: 0));
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return Right(localTrivia ?? NumberTriviaModel(text: '', number: 0));
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
