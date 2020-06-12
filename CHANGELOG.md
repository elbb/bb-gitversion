# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.5.1] - 2020.Q2

### Fixed

-   don't auto increment patch level on master branch
-   fix versioning for branches which include substring 'master'

## [0.5.0] - 2020-05-28

### Added

-   added concourse ci/cd pipeline

## [0.4.2] - 2020-05-28

-   fixed issue where we generated different branch version results using a local buildsystem vs concourse

## [0.4.1] - 2020-05-26

-   fixed version generation for branch master

## [0.4.0] - 2020-05-26

### Added

-   replaced '+' characters with '-' for greater compability e.g. docker tags
-   introduced branch specific version files e.g. 
    master branch gets `FullSemVer`, any other branches get `InformationalVersion`

## [0.3.0] - 2020-05-19

### Added

-   allowed versioning of all branch names

## [0.2.0] - 2020-05-13

### Added

-   added env vars to specify directory locations for `git` and `gen`

## [0.1.0] - 2020-03-29

Initial Version

### Added

-   integrated gitversion
-   added json output
-   added env output
-   added plain output
-   integrated dobi as local build environment
-   added license informations (MIT and Apache 2.0)
