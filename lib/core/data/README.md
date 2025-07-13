# Data Layer

This directory contains the data layer implementation following Clean Architecture principles. It handles all data operations including API calls, local storage, and data transformations.

## Structure

```
lib/core/data/
├── models/                    # Data models
│   ├── base/                 # Base models
│   │   ├── api_response.dart # API response models
│   │   └── error_model.dart  # Error handling models
│   ├── user/                 # User-related models (to be created)
│   ├── settings/             # Settings models (to be created)
│   └── index.dart           # Models exports
├── datasources/              # Data sources
│   ├── remote/              # Remote data sources
│   │   ├── api_client.dart  # API client interface
│   │   ├── http_client.dart # HTTP client implementation
│   │   ├── interceptors/    # HTTP interceptors
│   │   └── index.dart       # Remote exports
│   ├── local/               # Local data sources
│   │   ├── storage/         # Local storage
│   │   ├── database/        # Database (to be created)
│   │   └── index.dart       # Local exports
│   └── index.dart           # Data sources exports
├── repositories/             # Repository implementations
│   └── index.dart           # Repository exports
└── index.dart               # Data layer exports
```

## Components

### Models

#### Base Models

- **`api_response.dart`**: Provides consistent API response structures
  - `ApiResponse<T>`: Generic API response wrapper
  - `PaginatedApiResponse<T>`: Paginated response wrapper
  - `PaginationInfo`: Pagination metadata
  - `ApiErrorResponse`: Error response structure
  - `ApiSuccessResponse<T>`: Success response structure
  - `ApiMetadata`: Response metadata

- **`error_model.dart`**: Comprehensive error handling
  - `ErrorModel`: Base error model
  - `ValidationErrorModel`: Validation-specific errors
  - `NetworkErrorModel`: Network-related errors
  - Extension methods for error handling

#### Usage Examples

```dart
// API Response
final response = ApiResponse.success(
  data: userData,
  message: 'User retrieved successfully',
  statusCode: 200,
);

// Error Handling
final error = ErrorModel.networkError(
  message: 'Connection failed',
  details: 'No internet connection',
);

// Validation Errors
final validationError = ValidationErrorModel.fromFieldErrors({
  'email': ['Invalid email format'],
  'password': ['Password too short'],
});
```

### Data Sources

#### Remote Data Sources

- **`api_client.dart`**: Abstract API client interface
  - Defines contract for API operations
  - Supports all HTTP methods
  - File upload/download capabilities
  - Authentication management
  - Interceptor support

- **`http_client.dart`**: Dio-based HTTP client implementation
  - Implements `ApiClient` interface
  - Automatic error handling
  - Request/response logging
  - Timeout configuration

- **Interceptors**: HTTP request/response processing
  - `logging_interceptor.dart`: Request/response logging
  - `auth_interceptor.dart`: Authentication (to be created)
  - `error_interceptor.dart`: Error handling (to be created)
  - `cache_interceptor.dart`: Caching (to be created)

#### Local Data Sources

- **Storage**: Local data persistence
  - `local_storage.dart`: SharedPreferences wrapper
  - `secure_storage.dart`: Encrypted storage (to be created)
  - `cache_storage.dart`: Cache management (to be created)

- **Database**: Local database (to be implemented)
  - SQLite/Drift integration
  - Data access objects (DAOs)
  - Database entities

#### Usage Examples

```dart
// HTTP Client
final client = HttpClient(
  baseUrl: 'https://api.example.com',
  defaultHeaders: {'Content-Type': 'application/json'},
);

// API Request
final response = await client.get<User>(
  '/users/1',
  fromJson: (json) => User.fromJson(json),
);

// Local Storage
final storage = LocalStorage();
await storage.setString('user_token', token);
final token = await storage.getString('user_token');
```

### Repositories

Repository implementations that coordinate between remote and local data sources.

#### Planned Repositories

- `auth_repository_impl.dart`: Authentication operations
- `user_repository_impl.dart`: User data management
- `settings_repository_impl.dart`: App settings
- `post_repository_impl.dart`: Post data operations

#### Repository Pattern

```dart
class UserRepositoryImpl implements UserRepository {
  final ApiClient _apiClient;
  final LocalStorage _localStorage;

  UserRepositoryImpl(this._apiClient, this._localStorage);

  @override
  Future<Result<User>> getUser(String id) async {
    try {
      // Try remote first
      final response = await _apiClient.get<User>(
        '/users/$id',
        fromJson: (json) => User.fromJson(json),
      );

      if (response.isSuccess) {
        // Cache locally
        await _localStorage.setString('user_$id', jsonEncode(response.data));
        return Result.success(response.data!);
      }

      // Fallback to local cache
      final cached = await _localStorage.getString('user_$id');
      if (cached != null) {
        return Result.success(User.fromJson(jsonDecode(cached)));
      }

      return Result.failure(ErrorModel.unknownError());
    } catch (e) {
      return Result.failure(ErrorModel.fromException(e));
    }
  }
}
```

## Best Practices

### 1. Error Handling

- Always use `ErrorModel` for consistent error representation
- Provide user-friendly error messages
- Log detailed error information for debugging
- Handle network errors gracefully

### 2. Data Transformation

- Keep models immutable
- Use factory constructors for complex object creation
- Implement proper JSON serialization/deserialization
- Validate data at the model level

### 3. Caching Strategy

- Implement cache-first approach for better UX
- Use appropriate cache invalidation strategies
- Handle cache misses gracefully
- Consider cache size limits

### 4. API Design

- Use consistent response formats
- Implement proper pagination
- Handle rate limiting
- Support offline functionality

### 5. Testing

- Mock external dependencies
- Test error scenarios
- Validate data transformations
- Test cache behavior

## Dependencies

- `dio`: HTTP client
- `shared_preferences`: Local storage
- `freezed`: Immutable data classes (optional)
- `json_annotation`: JSON serialization

## Future Enhancements

1. **Database Integration**: Add SQLite/Drift for complex local data
2. **Caching Layer**: Implement sophisticated caching strategies
3. **Offline Support**: Enhanced offline functionality
4. **Data Synchronization**: Sync local and remote data
5. **Analytics**: Track data operations for insights
6. **Encryption**: Secure sensitive data storage

## Contributing

When adding new data models or sources:

1. Follow the existing naming conventions
2. Add proper documentation
3. Include usage examples
4. Update the relevant index files
5. Add tests for new functionality
6. Consider backward compatibility 