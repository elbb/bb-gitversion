<img src="https://raw.githubusercontent.com/elbb/bb-gitversion/master/.assets/logo.png" height="200">

# (e)mbedded (l)inux (b)uilding (b)locks - containerized GitVersion (with some improvements)

This building block integrates GitVersion ("GitVersion looks at your git history and works out the semantic version of the commit being built") and adds the following features to GitVersion:

-   Output of the version numbers as json file.
-   Output of the version numbers, divided into plain text files
-   Output of the version numbers as linux environment file.
-   Output of the version numbers as c++ header file.

For more information, see <https://gitversion.net/docs/>

By default [this](https://github.com/elbb/bb-gitversion/blob/master/gitversion/GitVersion.yaml) GitVersion configuration is used.

## Characteristic Features

### `GitVersion_BranchVersion`
Depending on the default branch of your repository `bb-gitversion` creates the variable `GitVersion_Branchversion` with content equal to `GitVersion_FullSemVer` if the branch is the default branch. On any other branch `GitVersion_Branchversion` equals to `GitVersion_InformationalVersion`. You can configure the default branch via setting the environment variable `DEFAULT_BRANCH` when executing bb-gitversion.

### GitVersion for labeling `docker` images
You can not use a version info compliant to https://semver.org/ for labeling `docker` images. `docker` doesnt allow the character `+` in a label.
Therefore `bb-gitversion` provides the variables `GitVersion_FullSemVerDockerLabel`, `GitVersion_BranchVersionDockerLabel` and `GitVersion_InformationalVersionDockerLabel` which have content analog to `GitVersion_FullSemVer`, `GitVersion_BranchVersion` and `GitVersion_InformationalVersion` where `+` is replaced with `-`.

## Options
Options are set via environment variables.

- `DEFAULT_BRANCH` - sets the default branch of the repository
- `GIT_BRANCH` - optional, set to branchname if checkout is in detached state (e.g. detached checkout by ci/cd)
- `USER_ID` - the user id which is used to generate the version information files
- `VERBOSE` - {0,1} print `bb-gitversion` variables on generation

# Usage and Integration into your own project

## Integration via docker image

All stable versions of `bb-gibversion` are published in the elbb project on docker.io and can be obtained from there:

`docker pull elbb/bb-gitversion`

To generate a version number for the current git branch of your project, call:

```bash
docker run -v $(pwd):/git -v $(pwd)/gen:/gen elbb/bb-gitversion
docker run -v $(pwd):/git -v $(pwd)/gen:/gen -e USERID=$(id -u) -e DEFAULT_BRANCH=master -e VERBOSE=1 elbb/bb-gitversion
```

After a successful scan the `./gen` directory looks like this:

```bash
./gen/json/gitversion.json
./gen/cpp/version.h
./gen/env/gitversion.env
./gen/plain/Minor
./gen/plain/BuildMetaDataPadded
./gen/plain/MajorMinorPatch
./gen/plain/AssemblySemVer
./gen/plain/LegacySemVerPadded
...
```

The generated files can now be used and evaluated by other applications/ci-systems, e.g. the concourse pipeline of this repository uses bb-gitversion itself.

## Integration via dobi

Use our [bb-buildingblock](https://github.com/elbb/bb-buildingblock.git) `elbb` project template to bootstrap your project. It already integrates `bb-gitversion`.<br>
This repository itself uses `bb-gitversion` for versioning via `./dobi.sh`. The `dobi` target `version` is implicitly called for all other `dobi` targets.  <br>
`./dobi.sh`:
```bash
${dobi} --filename meta.yaml version
```
`meta.yaml` includes `version.yaml` which you can use to integrate and adapt to your needs.

# Build

_There is normally no need to build this building block manually. For the integration
into your project it is sufficient to use the image on hub.docker.com as described
in the Usage section._

The corresponding image can be created manually or e.g. via dobi (<https://github.com/dnephin/dobi>), the way described here.

## Prerequisites

-   [docker](https://docs.docker.com/install/)
-   [dobi](https://github.com/dnephin/dobi) (downloaded if not in `PATH`)
-   [concourse](https://concourse-ci.org/) (ci/cd)

## Using dobi for local build

dobi should only be used via the `dobi.sh` script, because there important variables are set and the right scripts are included.

The following dobi resources are available:

```bash
./dobi.sh build     #build gitversion container image
./dobi.sh deploy    #deploy gitversion container image to registry
 ./dobi.sh version  #generate version informations (auto called by dobi.sh
```

### Default project variables

Edit `./default.env` to set default project variables.

### Local project variables

If you want to override project variables, copy `./local.env.template` to `./local.env` and edit `./local.env` accordingly.<br>
`./local.env` is ignored by git via `./.gitignore`.

## Using concourse CI for a CI/CD build

The pipeline file must be uploaded to concourse CI via `fly`.
Enter the build users ssh private key into the file `ci/credentials.template.yaml` and rename it to `ci/credentials.yaml`.
Copy the file `ci/email.template.yaml` to `ci/email.yaml` and enter the email server configuration and email addresses.
For further information how to configure the email notification, see: <https://github.com/pivotal-cf/email-resource>

**Note: `credentials.yaml` and `email.yaml` are ignored by `.gitignore` and will not be checked in.**

In further releases there will be a key value store to keep track of the users credentials.
Before setting the pipeline you might login first to your concourse instance `fly -t <target> login --concourse-url http://<concourse>:<port>`. See the [fly documentation](https://concourse-ci.org/fly.html) for more help.
Upload the pipeline file with fly:

    $ fly -t <target> set-pipeline -n -p bb-gitversion -l ci/config.yaml -l ci/credentials.yaml -l ci/email.yaml -c pipeline.yaml

After successfully uploading the pipeline to concourse CI login and unpause it. After that the pipeline should be triggered by new commits on the master branch (or new tags if enabled in `pipeline.yaml`).

# Troubleshooting

## Customization of working directories

Some CI/CD systems, e.g. concourse, don't provide the possibility to explicitly force the specific mount directories `/git` and `/gen` in the instantiated `bb-gitversion` container. You can set the environment variables `GIT_PATH` and `GEN_PATH` in this case.

# What is embedded linux building blocks

embedded linux building blocks is a project to create reusable and
adoptable blueprints for highly recurrent issues in building an internet
connected embedded linux system.

# License

Licensed under either of

-   Apache License, Version 2.0, (./LICENSE-APACHE or <http://www.apache.org/licenses/LICENSE-2.0>)
-   MIT license (./LICENSE-MIT or <http://opensource.org/licenses/MIT>)

at your option.

# Contribution

Unless you explicitly state otherwise, any contribution intentionally
submitted for inclusion in the work by you, as defined in the Apache-2.0
license, shall be dual licensed as above, without any additional terms or
conditions.

Copyright (c) 2020 conplement AG
