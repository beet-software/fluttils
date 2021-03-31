# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.0] - 2021-03-31
### Added
- `Height` and `Width` widgets
- `SafeScaffold` widget
- `SimpleStack` widget
- Documentation for `SimpleFutureBuilder` and `SimpleStreamBuilder` properties

### Changed
- Default value of `indicator` parameter from `SimpleFutureBuilder` and `SimpleStreamBuilder` now
  is `Center(child: CircularProgressIndicator())` instead of `CircularProgressIndicator()`

### Fixed
- `stream` parameter from `SimpleStreamBuilder` is now being used


## [1.3.0] - 2021-03-30
### Added
- `SplashScreen` and `SimpleSplashScreen` widgets

### Changed
- `StyledText` now supports a `align` parameter (equivalent to `textAlign`)

### Fixed
- Dummy function in public API


## [1.2.0] - 2021-03-29
### Added
- `SimplePadding` widget
- *example/README.md* file

### Changed
- Dialog functions now use `TextButton` instead of `FlatButton`
- *README.md* examples now appears in *example/README.md* file


## [1.1.0] - 2021-03-29
### Changed
- `onBuild` argument of `OnDemandListView` widget is now positional instead of named


## [1.0.1] - 2021-03-29
### Added 
- *LICENSE* file

### Changed
- *README* now contains examples and a more detailed package description

### Removed
- `author` section from *pubspec.yaml*


## [1.0.0] - 2021-03-29
### Added
- `StyledText` widget
- `SimpleFutureBuilder` and `SimpleStreamBuilder` widgets
- `SimpleVisibility` widget
- `TapOutsideToUnfocus` widget
- `OnDemandListView` widget
- `colors` constant
- `showSimpleDialog` and `showBinaryDialog` functions
- `asap` function
- `BuildContextUtils` extension