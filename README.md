
# embedded linux building blocks - Containerized gitversion (with some improvements)

# Howto integrate the building block into your own project

The preferred way is via dockerfile.

## Integration via dockerfile

Versions of the building-block are published in the elbb project on docker.io and can be obtained from there:

`docker pull elbb/bb-gitversion:dev`

- [ ] add docker run command here

## Integration via dobi

For integration via dobi it is first necessary to integrate the source code so that the dobi script of the project can access the scripts of the building block.

Recommended methods for integration are either per git submodule (if no adjustments to the building block are necessary) or per git subtree (if it should be adjusted)

In the dobi meta section of your own project you have to include all dobi files integrated in meta.yaml. this way all resources defined by bb-gitversion will be included in your project and can be executed.

It is possible that you need to adapt the mount-points listed in dobi.yaml to your projects needs.

# What is embedded linux building blocks

embedded linux building blocks is a project to create reusable and
adoptable blueprints for highly recurrent issues in building an internet
connected embedded linux system.
