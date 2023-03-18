import 'package:clean_architecture/domain/entity/number_trivia.dart';
import 'package:clean_architecture/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture/domain/usecase/get_concrete_number_trivia_usecase.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

/**
 * Created by IqbalMF on 2022.
 * Package
 */
class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia? usecase;
  MockNumberTriviaRepository? mockNumberTriviaRepository;
  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: 1, text: 'test');
  test(
    'Should get trivia for the number from repository',
    () async {
      //arrange
      when(mockNumberTriviaRepository?.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));
      //act
      final result = await usecase?.call(Params(number: tNumber));
      //assert
      expect(result, Right(tNumberTrivia));
      verify(mockNumberTriviaRepository?.getConcreteNumberTrivia(tNumber));
      verifyNoMoreInteractions(mockNumberTriviaRepository);
    },
  );
}
