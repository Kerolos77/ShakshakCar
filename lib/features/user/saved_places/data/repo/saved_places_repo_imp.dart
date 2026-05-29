import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:shakshak/core/constants/api_const.dart';
import 'package:shakshak/core/constants/app_const.dart';
import 'package:shakshak/core/error/failure.dart';
import 'package:shakshak/core/network/dio_helper/dio_helper.dart';
import 'package:shakshak/core/network/local/cache_helper.dart';
import 'package:shakshak/features/user/saved_places/data/models/saved_place_model.dart';
import 'package:shakshak/features/user/saved_places/domain/entities/saved_place_entity.dart';
import 'package:shakshak/features/user/saved_places/domain/repositories/saved_places_repo.dart';

class SavedPlacesRepoImp implements SavedPlacesRepo {
  @override
  Future<Either<Failure, void>> addSavedPlace(SavedPlaceEntity place) async {
    try {
      await DioHelper.postData(
        url: ApiConstant.favoriteLocationsUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {
          'label': place.name,
          'address': place.address,
          'latitude': place.lat.toString(),
          'longitude': place.lng.toString(),
          'is_default': false,
        },
      );
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SavedPlaceEntity>>> getSavedPlaces() async {
    try {
      final response = await DioHelper.getData(
        url: ApiConstant.favoriteLocationsUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      
      final List<dynamic> data = response.data['data'] ?? [];
      final places = data.map((e) => SavedPlaceModel.fromMap(e)).toList();
      return Right(places);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeSavedPlace(String id) async {
    try {
      await DioHelper.deleteData(
        url: '${ApiConstant.favoriteLocationsUrl}/$id',
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<SavedPlaceEntity>>> getSuggestedPlaces() async {
    try {
      final response = await DioHelper.getData(
        url: ApiConstant.suggestedPlacesUrl,
        token: CacheHelper.getData(key: AppConstant.kToken),
      );
      
      final List<dynamic> data = response.data['data'] ?? [];
      final places = data.map((e) => SavedPlaceModel.fromMap(e)).toList();
      return Right(places);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSavedPlace(SavedPlaceEntity place) async {
    try {
      await DioHelper.putData(
        url: '${ApiConstant.favoriteLocationsUrl}/${place.id}',
        token: CacheHelper.getData(key: AppConstant.kToken),
        data: {
          'label': place.name,
          'address': place.address,
          'latitude': place.lat.toString(),
          'longitude': place.lng.toString(),
          'is_default': false,
        },
      );
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure.fromDioError(e));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
