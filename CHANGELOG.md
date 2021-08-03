# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.9.0] - 2021.Q3

- cicd: add regression test
- **breaking change**:  rm `GitVersion_BranchVersion` and `GitVersion_BranchVersionDockerLabel`
- update gitversion config
    - rename master -> main for main branch
    - reconfigure mode of feature branch to ContinuousDeployment
- entrypoint.sh: add user only if not already existing

## [0.8.4] - 2021.Q2

- use upstream gitversion 5.6.11
- fix race getting gitversion in pipeline
- mv pipeline.yaml -> ci/pipeline.yaml
- changed default branch master -> main

## [0.8.3] - 2021.Q2

- added `GitVersion_InformationalVersionDockerLabel` that replaces the `+` to `-` `from GitVersion_InformationalVersion`

## [0.8.2] - 2021.Q1

- fixed parsing of `DEFAULT_BRANCH` when it includes a slash

## [0.8.1] - 2021.Q1

- introduced environment variable `GIT_BRANCH` - optional, set to branchname if checkout is in detached state (e.g. detached checkout by ci/cd) (cause: upstream gittools/gitversion currently detects head commit of detached checkouts in branch "branchname" and "origin/branchname" which is not unambiguous)
- use gittools/gitversion in alpine flavour

## [0.8.0] - 2021.Q1

- add docker user/password for all docker images used for concourse ci
- **breaking change**: if you use bb-gitversion to label docker images use now `GitVersion_FullSemVerDockerLabel` or `GitVersion_BranchVersionDockerLabel`; this version does not replace `+` with `-` in all `GitVersion_`-variables anymore
- set the environment variable `DEFAULT_BRANCH` to configure the default branch of the repository; per default `DEFAULT_BRANCH==master`;
- set the environment variable `VERBOSE=1` to print generated gitversion variables

## [0.7.0] - 2020.Q4

-  updated ci pipeline tagging (reintegrated bb-buildingblock)
-  added `default.env`, `local.env.template` and doku how to use it -> enables setting default and local environment variables for `dobi` targets
-  `dobi.sh` downloads `dobi` if `dobi` is not `$PATH`
-  `dobi.sh`: parameter checking and handling for `dobi` target `list` and `dobi.sh` target `version`
-  added email notification on error/success in `concourse` pipeline

## [0.6.2] - 2020.Q2

### Added

-   added branch version to gitversion json file.
-   the genenrated files (plain, env and cpp now also contain the branch version)

## [0.6.1] - 2020.Q2

### Added

-   added cpp version namespace elbb::version

## [0.6.0] - 2020.Q2

### Added

-   generation of a cpp version header file

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
