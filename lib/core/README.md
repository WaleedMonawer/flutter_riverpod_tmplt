# Core Module

This directory contains the core functionality of the Flutter application, organized following Clean Architecture principles with improved separation of concerns.

## 📁 Structure

```
lib/core/
├── common/                    # Common utilities, constants, and exceptions
│   ├── constants/            # Application constants
│   │   ├── app_constants.dart
│   │   ├── api_constants.dart
│   │   ├── theme_constants.dart
│   │   └── index.dart
│   ├── utils/                # Utility classes
│   │   ├── logger.dart
│   │   ├── date_utils.dart
│   │   ├── validation_utils.dart
│   │   ├── string_utils.dart
│   │   └── index.dart
│   ├── exceptions/           # Exception classes
│   │   ├── app_exceptions.dart
│   │   ├── network_exceptions.dart
│   │   └── index.dart
│   └── index.dart
├── domain/                   # Domain layer (entities, repositories, use cases)
│   ├── entities/            # Business entities
│   ├── repositories/        # Repository interfaces
│   ├── usecases/           # Business logic use cases
│   └── value_objects/      # Value objects
├── data/                    # Data layer (models, datasources, repositories)
│   ├── models/             # Data models
│   ├── datasources/        # Data sources (remote/local)
│   └── repositories/       # Repository implementations
├── presentation/           # Presentation layer
│   ├── widgets/           # Reusable widgets
│   │   ├── common/        # Common widgets
│   │   └── adaptive/      # Platform-adaptive widgets
│   ├── theme/             # Theme configuration
│   │   ├── colors/        # Color definitions
│   │   └── ...
│   └── navigation/        # Navigation configuration
├── services/              # Core services
│   ├── network/           # Network services
│   ├── storage/           # Storage services
│   ├── analytics/         # Analytics services
│   ├── notifications/     # Notification services
│   └── deep_linking/      # Deep linking services
├── providers/             # Riverpod providers
├── i18n/                  # Internationalization
└── README.md
```

## 🎯 Key Improvements

### 1. **Common Module** (`common/`)
- **Constants**: Centralized application constants organized by domain
  - `app_constants.dart`: General application constants
  - `api_constants.dart`: API-related constants (URLs, endpoints, timeouts)
  - `theme_constants.dart`: Design system constants (spacing, colors, typography)
- **Utils**: Reusable utility classes
  - `logger.dart`: Centralized logging functionality
  - `date_utils.dart`: Date formatting and manipulation
  - `validation_utils.dart`: Input validation utilities
  - `string_utils.dart`: String manipulation utilities
- **Exceptions**: Custom exception classes
  - `app_exceptions.dart`: General application exceptions
  - `network_exceptions.dart`: Network-specific exceptions

### 2. **Presentation Layer** (`presentation/`)
- **Widgets**: Organized by purpose and platform adaptation
  - `common/`: Platform-agnostic widgets
  - `adaptive/`: Platform-adaptive widgets
- **Theme**: Comprehensive theming system
  - `colors/`: Color palette and definitions
  - Theme controllers and configurations
- **Navigation**: Centralized routing and navigation

### 3. **Services Layer** (`services/`)
- **Network**: HTTP client, interceptors, network utilities
- **Storage**: Local storage, caching, persistence
- **Analytics**: Event tracking and analytics
- **Notifications**: Push notifications and local notifications
- **Deep Linking**: URL handling and deep link processing

## 🚀 Benefits

### **Maintainability**
- Clear separation of concerns
- Modular architecture
- Easy to locate and modify code

### **Scalability**
- Extensible structure
- Reusable components
- Consistent patterns

### **Testability**
- Isolated components
- Dependency injection ready
- Clear interfaces

### **Developer Experience**
- Intuitive file organization
- Consistent naming conventions
- Comprehensive documentation

## 📦 Usage

### Importing Constants
```dart
import 'package:flutter_riverpod_tmplt/core/common/constants/api_constants.dart';
import 'package:flutter_riverpod_tmplt/core/common/constants/theme_constants.dart';
```

### Using Utilities
```dart
import 'package:flutter_riverpod_tmplt/core/common/utils/date_utils.dart';
import 'package:flutter_riverpod_tmplt/core/common/utils/validation_utils.dart';
```

### Handling Exceptions
```dart
import 'package:flutter_riverpod_tmplt/core/common/exceptions/network_exceptions.dart';
```

### Complete Common Module Import
```dart
import 'package:flutter_riverpod_tmplt/core/common/index.dart';
```

## 🔧 Development Guidelines

### Adding New Constants
1. Create a new file in `common/constants/` for domain-specific constants
2. Add export to `common/constants/index.dart`
3. Follow naming convention: `{domain}_constants.dart`

### Adding New Utilities
1. Create a new file in `common/utils/` for the utility class
2. Add export to `common/utils/index.dart`
3. Follow naming convention: `{purpose}_utils.dart`

### Adding New Exceptions
1. Create a new file in `common/exceptions/` for domain-specific exceptions
2. Add export to `common/exceptions/index.dart`
3. Extend base `AppException` class

### Widget Organization
- **Common Widgets**: Platform-agnostic, reusable components
- **Adaptive Widgets**: Platform-specific implementations
- **Feature Widgets**: Feature-specific components (in feature modules)

## 🎨 Design System

The theme constants provide a comprehensive design system:
- **Spacing**: Consistent padding, margin, and spacing values
- **Typography**: Font sizes, weights, and line heights
- **Colors**: Primary, secondary, and semantic color palette
- **Elevation**: Shadow and elevation values
- **Animation**: Duration and curve constants

## 🔗 Navigation

The navigation system provides:
- Centralized route definitions
- Type-safe navigation
- Deep linking support
- Navigation guards
- Error handling

## 📊 Analytics & Monitoring

The services layer includes:
- Event tracking
- Performance monitoring
- Error reporting
- User behavior analytics

## 🔐 Security

Security features include:
- Input validation
- Data sanitization
- Secure storage
- Network security

## 🌐 Internationalization

The i18n module provides:
- Multi-language support
- RTL layout support
- Localized content
- Cultural adaptations

## 📱 Platform Support

The architecture supports:
- **iOS**: Native iOS patterns and conventions
- **Android**: Material Design and Android patterns
- **Web**: Responsive web design
- **Desktop**: Desktop-optimized interfaces

## 🧪 Testing

The structure supports:
- **Unit Tests**: Isolated component testing
- **Widget Tests**: UI component testing
- **Integration Tests**: End-to-end testing
- **Golden Tests**: Visual regression testing

## 📈 Performance

Performance optimizations include:
- Lazy loading
- Efficient state management
- Optimized rendering
- Memory management

## 🔄 Migration Guide

If migrating from the old structure:

1. **Update Imports**: Replace old import paths with new ones
2. **Move Files**: Relocate files to their new locations
3. **Update Dependencies**: Ensure all dependencies are properly imported
4. **Test Thoroughly**: Verify all functionality works correctly

## 🤝 Contributing

When contributing to the core module:

1. **Follow Structure**: Maintain the established organization
2. **Add Documentation**: Document new components and utilities
3. **Update Index Files**: Add exports for new files
4. **Write Tests**: Include tests for new functionality
5. **Follow Conventions**: Use consistent naming and patterns

## 📚 Additional Resources

- [Flutter Architecture Patterns](https://flutter.dev/docs/development/data-and-backend/state-mgmt/options)
- [Clean Architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev/)
- [Freezed Documentation](https://pub.dev/packages/freezed) 