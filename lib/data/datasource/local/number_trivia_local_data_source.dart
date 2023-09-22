import 'package:clean_architecture/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel>? getLastNumberTrivia();

  Future<void>? setCacheNumberTrivia(NumberTriviaModel? triviaToCache);
}
