import 'package:kdmp_cm_app/data/model/common/state.dart';
import 'package:kdmp_cm_app/data/model/naver/directions_request.dart';
import 'package:kdmp_cm_app/data/model/naver/geocoding_request.dart';
import 'package:kdmp_cm_app/data/model/naver/reverse_geocoding_request.dart';

abstract class NaverRepository {
  Future<StateAPI> getAddress({required String clientId, required String clientSecret, required ReverseGeocodingRequest reverseGeocodingRequest});

  Future<StateAPI> getAddressInfo({required String clientId, required String clientSecret, required GeocodingRequest geocodingRequest});

  Future<StateAPI> getDriving({required String clientId, required String clientSecret, required DirectionsRequest directionsRequest});
}
