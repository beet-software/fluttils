# Changelog
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

> :warning: represents a breaking change

## [4.0.0] - 2022-03-08
### Added
- `MappedListView` widget
- `short` factory constructor to `SplashScreen` widget
- `provider` as a dependency
- `FutureBuilder` and `StreamBuilder` now support error handling with error and stacktrace

### Changed
- Make all widgets available as constants
- `TapOutsideToUnfocus` is now called `ContextUnfocuser`
- `Visibility` widget is now controlled by a `VisibilityLevel`
- `SplashScreen` widget now builds the result in-place instead of pushing a new route 
- `Text` widget now supports `TextAlign` as parameter
- `Height` and `Width` single-parameters are now default to zero instead of infinity
 
### Removed
- `Group` widget
- `SimpleSplashScreen` widget
- `OnDemandListView` widget
- Prefix "Simple" from widgets, preferring an import alias as alternative
- Default values for button texts on custom dialogs


## [2.0.0] - 2021-06-27
### Changed
- Migrate to null-safety


## [1.5.0] - 2021-04-07
### Added
- `Group` widget
- `Separated` widget
- `SimpleEdgeInsets` widget


## [1.4.5] - 2021-04-01
### Added
- More widget tests

### Fixed
- `positiveText` and `negativeText` default parameters of `showBinaryDialog` are now fixed


## [1.4.4] - 2021-04-01
### Added
- More widget tests

### Changed
- :warning: `onBuild` parameter of `indexed` constructor of `OnDemandListView` is now positional 
- Enforce widget types (`SimpleStreamBuilder` is now a `StreamBuilder`, `SimpleFutureBuilder` is
  now a `FutureBuilder`)

### Fixed
- `SimpleStreamBuilder` now displays its progress indicator correctly


## [1.4.3] - 2021-03-31
### Added
- More widget tests

### Changed
- Enforce widget types (`SimpleStack` is now a `Stack`; `SafeScaffold` is now a `SafeArea`; 
  `OnDemandListView` is now a `ListView`; `SimpleVisibility` is now a `Visibility`; `SplashScreen`
  is now a `FutureBuilder`)

### Fixed
- :warning: `floatingActionBar` parameter of `SafeScaffold` is renamed to `floatingActionButton`


## [1.4.2] - 2021-03-31
### Added
- `FontStyle` attribute to `StyledText`
- Widget tests for `StyledText`, `SimplePadding`, `Width` and `Height`
- Travis and Codecov badges to *README.md*

### Changed
- `value` parameter of `Width` and `Height` now is optional
- `size` extension property of `BuildContextUtils` is now `screenSize`

### Fixed
- Not using the `fontSize` parameter of `StyledText` now is valid


## [1.4.1] - 2021-03-31
### Added
- `physics` parameter to `OnDemandListView`
- Examples to *README.md* and *example/README.md*

### Changed
- :warning: `builder` parameters from `SimpleFutureBuilder` and `SimpleStreamBuilder` now receives a 
  `BuildContext`
- :warning: `stream` and `future` named parameters from `SimpleFutureBuilder` and 
  `SimpleStreamBuilder` are now positional
- `SplashScreen` is now a `StatelessWidget`
- Documentation improved

### Fixed
- `int` attribute on `StyledText` to represent a `fontSize` is now valid


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
- :warning: `onBuild` argument of `OnDemandListView` widget is now positional instead of named


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
