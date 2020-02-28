
# containerized gitversion ( with some improvements )

# howto integrate the building block into your own project

the preferred way is via dockerfile.

## integration via dockerfile

Versions of the building-block are published in the elbb project on docker.io and can be obtained from there:

`docker pull elbb/bb-gitversion:dev`

- [ ] add docker run command here

## integration via dobi

For the integration via dobi it is first of all necessary to integrate the source code so that the dobi script of the project can access the scripts in the building block.

recommended methods are either per git submodule ( if no adjustments to the building block are necessary) or per git subtree ( if it should be adjusted)

in the dobi meta section of your own project you have to include all dobi files integrated in meta.yaml. this way all resources defined by bb-gitversion will be included in your project and can be executed.

Possibly the mount-points listed in dobi.yaml have to be adapted to the own project.

# License

# What is embedded linux building blocks

embedded linux building block's is a project to create reusable and
adoptable blueprints for highly recurrent issues in building an internet
connected embedded linux system.
