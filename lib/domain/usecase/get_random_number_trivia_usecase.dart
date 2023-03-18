import 'package:dartz/dartz.dart';

import '../../core/error/failures.dart';
import '../../core/usecase/usecase.dart';
import '../entity/number_trivia.dart';
import '../repositories/number_trivia_repository.dart';

/**
 * Created by IqbalMF on 2022.
 * Package
 */
class GetRandomNumberTrivia extends UseCase<NumberTrivia, NoParams> {
  final NumberTriviaRepository? repository;

  GetRandomNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>?> call(NoParams params) async {
    return await repository?.getRandomNumberTrivia();
  }
}
