import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  static final _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();
  final StreamController<bool> _controller = StreamController<bool>.broadcast();

  Stream<bool> get onStatusChange => _controller.stream;

  Future<void> initialize() async {
    final results = await _connectivity.checkConnectivity();
    _controller.add(_isConnected(results));

    _connectivity.onConnectivityChanged.listen((results) {
      _controller.add(_isConnected(results));
    });
  }

  Future<bool> checkNow() async {
    final results = await _connectivity.checkConnectivity();
    return _isConnected(results);
  }

  bool _isConnected(List<ConnectivityResult> results) {
    if (results.isEmpty) return false;
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi);
  }
}
