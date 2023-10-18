import 'dart:convert';
import 'dart:io';

import 'package:clean_architecture/core/error/exceptions.dart';
import 'package:clean_architecture/data/datasource/remote/number_trivia_remote_data_source.dart';
import 'package:clean_architecture/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late NumberTriviaRemoteDataSourceImpl dataSourceImpl;
  late MockClient mockHttpClient;
  setUp(() {
    mockHttpClient = MockClient();
    dataSourceImpl = NumberTriviaRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    const tNumber = 1;
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with 
        number being the endpoint and with application/json header''',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      //act
      dataSourceImpl.getConcreteNumberTrivia(tNumber);
      //assert
      verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response is 200 (success)',
        () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
              headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
      //act
      final result = await dataSourceImpl.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, equals(tNumberTriviaModel));
    });
    
    test('should thrown a ServerException when the response code is 404 or other', () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'),
          headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      //act
      final call = dataSourceImpl.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(isA<ServerException>()));
    });
  });

  group('getRandomNumberTrivia', () {
    final tNumberTriviaModel =
    NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('''should perform a GET request on a URL with 
        number being the endpoint and with application/json header''',
            () async {
          //arrange
          when(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
              headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
          //act
          dataSourceImpl.getRandomNumberTrivia();
          //assert
          verify(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
              headers: {'Content-Type': 'application/json'}));
        });

    test('should return NumberTrivia when the response is 200 (success)',
            () async {
          //arrange
          when(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
              headers: anyNamed('headers')))
              .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
          //act
          final result = await dataSourceImpl.getRandomNumberTrivia();
          //assert
          expect(result, equals(tNumberTriviaModel));
        });

    test('should thrown a ServerException when the response code is 404 or other', () async {
      //arrange
      when(mockHttpClient.get(Uri.parse('http://numbersapi.com/random'),
          headers: anyNamed('headers')))
          .thenAnswer((_) async => http.Response('Something went wrong', 404));
      //act
      final call = dataSourceImpl.getRandomNumberTrivia;
      expect(() => call(), throwsA(isA<ServerException>()));
    });
  });
}
