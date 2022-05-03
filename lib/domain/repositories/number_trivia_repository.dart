import 'package:clean_architecture/core/error/failures.dart';
import 'package:clean_architecture/domain/entity/number_trivia.dart';
import 'package:dartz/dartz.dart';

/**
 * Created by IqbalMF on 2022.
 * Package
 */
abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>>? getConcreteNumberTrivia(int? number);

  Future<Either<Failure, NumberTrivia>>? getRandomNumberTrivia();
}
