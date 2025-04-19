import 'package:actual/common/const/data.dart';
import 'package:actual/user/model/user_model.dart';
import 'package:actual/user/repository/auth_repository.dart';
import 'package:actual/user/repository/user_me_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserMeStateNotifier extends StateNotifier<UserModelBase?> {
  final AuthRepository authRepository;
  final UserMeRepository repository;
  final FlutterSecureStorage storage;

  UserMeStateNotifier({
    required this.authRepository,
    required this.repository,
    required this.storage,
  }) : super(UserModelLoading()) {
    getMe();
  }

  Future<void> getMe() async {
    final accessToken = await storage.read(key: accessTokenKey);
    final refreshToken = await storage.read(key: refreshTokenKey);

    if (accessToken == null || refreshToken == null) {
      state = null;

      return;
    }

    final response = await repository.getMe();

    state = response;
  }

  Future<UserModelBase> login({
    required String username,
    required String password,
  }) async {
    try {
      state = UserModelLoading();

      final response = await authRepository.login(
        username: username,
        password: password,
      );

      await storage.write(
        key: accessTokenKey,
        value: response.accessToken,
      );

      await storage.write(
        key: refreshTokenKey,
        value: response.refreshToken,
      );

      final userResponse = await repository.getMe();

      state = userResponse;

      return userResponse;
    } catch (e) {
      state = UserModelError(
        message: '로그인에 실패했습니다.',
      );

      return Future.value(state);
    }
  }

  Future<void> logout() async {
    state = null;

    await Future.wait([
      storage.delete(key: accessTokenKey),
      storage.delete(key: refreshTokenKey),
    ]);
  }
}
