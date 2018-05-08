This repository contains all the necessary files to compile Ruby and package it into a .deb file.

This guide uses an Ubuntu 14.04 (Trusty) Docker image as a base. If you need something else, create a new branch and edit the [Dockerfile](Dockerfile). Docker ensures we have a clean environment with dependencies that match our production setup.

### Using a Custom Ruby Definition
[Ruby-Build](https://github.com/rbenv/ruby-build) is a tool that abstracts away some of the pains of manually compiling Ruby.
It uses `definition` files to give instructions on how to build Ruby.

Since we are compiling Ruby to be packaged to a different system instead of the same system, we have to edit the default definition file.
More specific, we have to remove the `verify_openssl` instruction. This instruction currently cannot be used when compiling for a package.

The target Ruby version for this branch is 2.3.7. If you need a different version, you will have to create a new `definition` file. Use the [Ruby-Build template directory](https://github.com/rbenv/ruby-build/tree/master/share/ruby-build) to find the desired version and remember to remove the `verify_openssl` instruction.
Also change the version in the [Debian control file](DEBIAN/control)

### Publishing a new Ruby version with jemalloc

After ensuring you have a working installation of Docker and the desired `definition` file, we will build an Image of the environment necessary to compile Ruby.

Build the Docker Image using this repository as a context and `ruby-jemalloc` as the image name.
**If you are using a branch other than _master_, check the [documentation](https://docs.docker.com/engine/reference/commandline/build/#git-repositories) so you can modify the command below.

Using GitHub SSH:
```shell
$ docker build git@github.com:myfreecomm/ruby-jemalloc.git -t ruby-jemalloc
```

Or using GitHub HTTPS:
```shell
$ docker build https://github.com/myfreecomm/ruby-jemalloc.git -t ruby-jemalloc
```

This may take a while for the first time.

Once the build is complete, run the image with a bash entrypoint:
```shell
$ docker run -it ruby-jemalloc bash
```

Now you are inside the Docker image and ready to compile Ruby.

Run the following command with the desired Ruby version.
```shell
$ ./compile_and_build.sh 2.3.7
```

This will compile Ruby and build the `.deb` package.

To publish the package to Gemfury, run the following:
```shell
$ curl -F package=@file https://9ryw1qeUBWiPN7PsYosx@push.fury.io/myfreecomm/
```
Where `file` is the path to the `.deb` package.

Now the package is ready to be used.
