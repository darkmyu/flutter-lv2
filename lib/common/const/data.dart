import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const accessTokenKey = 'ACCESS_TOKEN';
const refreshTokenKey = 'REFRESH_TOKEN';

const emulatorIp = '10.0.0.2:3000';
const simulatorIp = '127.0.0.1:3000';
final ip = Platform.isIOS ? simulatorIp : emulatorIp;

const storage = FlutterSecureStorage();
