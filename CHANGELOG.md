# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

-  documentation "Prerequisites"
-  documentation "Howto use bb-buildingblock template"
-  documentation "Versioning"

## [0.3.0] - 2020.Q2

-   `latest` tags for docker images only for release branch when new tag is created `(*.*.*)`

## [0.2.2] - 2020.Q2

-   don't use build dependencies which are tagged "latest" in pipeline and ci examples as well
-   version bump of dependency bb-gitversion

## [0.2.1] - 2020-05-28

-   adapt pipeline for bb-gitversion fixes (bb-gitversion#9)
-   added 'passed' marker of gitversion creation in concourse pipeline in example #20

## [0.2.0] - 2020-05-25

-   default concourse CI environment for CI/CD builds

### Added

-   default concourse CI pipeline

## [0.1.0] - 2020-03-29

Initial Version

### Added

-   dobi environment template for local builds
-   license informations (MIT and Apache V 2.0)
-   changelog template
-   automated versioning (using elbb/bb-gitversion)
