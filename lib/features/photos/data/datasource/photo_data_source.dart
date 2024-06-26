import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pagination_in_cleanarch/app/config/api_endpoints.dart';
import 'package:pagination_in_cleanarch/app/config/http_service.dart';
import 'package:pagination_in_cleanarch/core/failure/failure.dart';
import 'package:pagination_in_cleanarch/features/photos/data/model/photos.dart';

final photoDataSourceProvider = Provider.autoDispose(
    (ref) => PhotoDataSource(ref.read(httpServiceProvider)));

class PhotoDataSource {
  final Dio _dio;
  PhotoDataSource(this._dio);
  Future<Either<Failure, List<Photos>>> getPhotos(int page) async {
    try {
      final response = await _dio.get(
        ApiEndpoints.photos,
        queryParameters: {
          '_page': page,
          '_limit': ApiEndpoints.limitPage,
        },
      );
      final data = response.data as List;
      final photos = data.map((e) => Photos.fromJson(e)).toList();
      return Right(photos);
    } on DioException catch (e) {
      return Left(Failure(message: e.message.toString()));
    }
  }
}
