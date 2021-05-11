import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:tmdb/const/constant.dart';
import 'package:tmdb/model/cast_model.dart';
import 'package:tmdb/model/movie_model.dart';
import 'package:tmdb/model/person_model.dart';
import 'package:http/http.dart' as http;

class Cast with ChangeNotifier {
  PersonModel person;
  List<MovieModel> _movies = [];
  List<CastModel> _popularPeople = [];

  PersonModel get getPerson {
    return person;
  }

  List<MovieModel> get getMovies {
    return [..._movies];
  }

  List<CastModel> get popularPeople {
    return [..._popularPeople];
  }

  Future<void> getPersonDetails(int id) async {
    final personUrl = '$BASE_URL/person/$id?api_key=$API_KEY&language=en-US';
    final moviesUrl =
        '$BASE_URL/person/$id/movie_credits?api_key=$API_KEY&language=en-US';

    try {
      final personResponse = await http.get(personUrl);
      final personData =
          json.decode(personResponse.body) as Map<String, dynamic>;
      // print('person data ----------> ${personData}');

      final moviesResponse = await http.get(moviesUrl);
      final moviesData =
          json.decode(moviesResponse.body) as Map<String, dynamic>;
      final fetchedMovies = moviesData['cast'];
      // print('movies data ----------> ${fetchedMovies}');

      _movies.clear();
      fetchedMovies.forEach((element) {
        _movies.add(MovieModel.fromJson(element));
        // print('added element id ------------------> ${element['id']}');
      });

      person = PersonModel(
        name: personData['name'],
        birthday: DateTime.parse(personData['birthday']),
        biography: personData['biography'],
        placeOfBirth: personData['place_of_birth'],
        movies: _movies,
      );
      // print(personResponse.body);

      notifyListeners();
    } catch (error) {
      print('cast provider error -------------> $error');
      throw error;
    }
  }

  Future<void> getPopularPeople(int page) async {
    final url =
        'https://api.themoviedb.org/3/person/popular?api_key=$API_KEY&language=en-US&page=1';

    try {
      final response = await http.get(url);
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      final data = responseData['results'];

      // print('results -----------> $data');

      data.forEach((element) {
        _popularPeople.add(CastModel.fromJson(element));
      });

      // print('done---------> $_popularPeople');
      notifyListeners();
    } catch (error) {
      print('cast provider error -------------> $error');
      throw error;
    }
  }
}
