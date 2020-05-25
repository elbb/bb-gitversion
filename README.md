<img src="https://raw.githubusercontent.com/elbb/bb-buildingblock/master/.assets/logo.png" height="200">

# embedded linux building block template

This code serves as a template for the creation of further building blocks with the purpose of giving all blocks a uniform structure and usage.

## Using dobi for local build

dobi should only be used via the `dobi.sh` script, because there important variables are set and the right scripts are included.

By default three dobi resources are predefined (but not implemented):

```sh
./dobi.sh build  # build the building block
./dobi.sh test   # run all tests
./dobi.sh deploy # deploy the building block
```

These point to the resources defined in dobi.yaml.
The separation between meta.yaml and dobi.yaml is necessary to integrate the building block into another building block via dobi.

Version information is generated automatically from git history by using building block bb-gitversion (<https://github.com/elbb/bb-gitversion>).
In the dobi files you can reference to this generated version information by accessing them with e.g. `{env.GitVersion_MajorMinorPatch}`. See the `gen/env/gitversion.env` file for defined env variables to use.

## Using concourse CI for a CI/CD build

The pipeline file must be uploaded to concourse CI via `fly`. 
Enter the build users ssh private key into the file `ci/credentials.template.yaml` and rename it to `ci/credentials.yaml`. 

**Note: `credentials.yaml` is ignored by `.gitignore` and will not be checked in.**

In further releases there will be a key value store to keep track of the users credentials.
Before setting the pipeline you might login first to your concourse instance `fly -t <target> login --concourse-url http://<concourse>:<port>`. See the [fly documentation](https://concourse-ci.org/fly.html) for more help.
Upload the pipeline file with fly:

    $ fly -t <target> set-pipeline -n -p bb-buildingblock -l ci/config.yaml -l ci/credentials.yaml -c pipeline.yaml

After successfully uploading the pipeline to concourse CI login and unpause it. After that the pipeline should be triggered by new commits on the master branch (or new tags if enabled in `pipeline.yaml`).

See the [integration documentation](ci/example/README.md) on how to modify the `pipeline.yaml` and config files for your building block.

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
