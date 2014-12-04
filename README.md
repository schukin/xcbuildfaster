# XCBuildFaster

Tweaks your Xcode project / subprojects for faster compilation times.

## Installation

	gem install xcbuildfaster

## Usage

	xcbuildfaster MyProject.xcodeproj

If you want to ignore certain subprojects, use the `--ignore` flag with the respective project names.

	xcbuildfaster MyProject.xcodeproj --ignore FooBarSubProject
