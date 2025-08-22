# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

AXKit is a Swift package that provides a type-safe wrapper around Apple's Accessibility APIs (`AXUIElement.h`) for macOS applications. The package enables inspection, manipulation, and observation of accessibility elements across the macOS system.

## Development Commands

### Building
```bash
swift build
```

### Testing
```bash
swift test                    # Run all tests
swift test --filter <name>    # Run specific test by name
```

### Single Test Target
Since this is a Swift package with a single test target, use:
```bash
swift test --target AXKitTests
```

## Architecture Overview

### Core Components

- **`AXClient` Protocol**: Central abstraction using associated types for platform-specific element types
- **`AXClientLive`**: Production implementation wrapping macOS accessibility APIs
- **`AXClientMock`**: Comprehensive mock implementation for testing with configurable closures
- **`AXClientKey`**: Integration with Point-Free's Dependencies library for dependency injection

### Key Patterns

- **Protocol-Oriented Design**: Uses associated types to maintain type safety across implementations
- **Type-Safe Attribute System**: `Attribute<T>` struct provides compile-time type information for accessibility attributes
- **Comprehensive Constants**: Well-organized enums for all accessibility constants (Action, AXNotification, Role, etc.)
- **Modern Swift Concurrency**: AsyncStream integration for observing accessibility notifications
- **Typed Throws**: Uses Swift's typed throws for clean error handling

### Testing Architecture

- Tests use Swift Testing framework with `@Test` and `@Suite` annotations
- Every test is `async throws`
- Tests follow naming scheme: `systemUnderTest_with[condition]_should[expected_result]`
- Mock system provides configurable closures for every protocol method
- Uses `withDependencies {}` construct for dependency overrides in tests

### Dependencies

- **Point-Free Dependencies**: For dependency injection and testability
- **ApplicationServices**: Core accessibility framework integration
- **Swift Concurrency**: AsyncStream for modern event handling
- **Carbon**: For keyboard modifier constants

## Important Implementation Details

### Type Safety Goals
The package aims for increased type safety with planned restrictions:
- Notifications per element type (e.g., prevent window notifications on applications)
- Actions per element type (e.g., prevent press actions on windows)
- Attributes per element type (e.g., element-specific attribute availability)

### Error Handling
Uses `AXClientError` enum for typed error handling with proper AXError to Swift error translation.

### Value Type Handling
Automatic encoding/decoding for Core Foundation types (CGRect, CGPoint, CGSize, CFRange) with type preservation through roundtrips.

## Configuration Notes

- Package.swift enables `StrictConcurrency` experimental feature
- Minimum platform: macOS 12.0
- Swift tools version: 5.10

# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.j