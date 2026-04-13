/// Base service class providing common functionality for all services
abstract class BaseService {
  /// Initialize the service
  Future<void> initialize();

  /// Clean up resources
  Future<void> dispose();
}
