sle2docker is a convenience tool which creates SUSE Linux Enterprise images for
[Docker](http://docker.com).

The tool relies on [KIWI](https://github.com/openSUSE/kiwi) and Docker itself
to build the images.

Packages can be fetched either from SUSE Customer Center (SCC) or from a local
Subscription Management Tool (SMT).

Using DVD sources is currently unsupported.

# Requirements

Ruby is required to execute the sle2docker program.

Docker must be running on the system and the user invoking sle2docker must
have the rights to interact with it.

# Installation

The recommended way to install sle2docker is via zypper:

```
sudo zypper in sle2docker
```

However sle2docker can be installed via gem:

```
sudo gem install --no-format-exec sle2docker
```

The `--no-format-exec` is recommended otherwise the `sle2docker` binary will
be prefixed with the ruby version installed on the system (eg: the binary on
SLE12 would be called `sle2docker.ruby2.1`).

# How it works

The sle2docker gem comes with a set of supported SLE templates. These are KIWI
source files which are filled with the informations provided by the user at
runtime.

The image creation happens inside of
[this](https://registry.hub.docker.com/u/opensuse/kiwi/)
Docker image. This has to be done because on recent systems (like SLE12) KIWI
cannot create SLE11 images. That happens because building a SLE11 systems
requires the `db45-utils` package to be installed on the host system; this
package is obsolete and is not available on SLE12.

The Docker image used by sle2docker is based on openSUSE and it's freely
downloadable from the [Docker Hub](https://registry.hub.docker.com/). The image
is built using Docker's build system by starting from the
[official openSUSE image](https://registry.hub.docker.com/_/opensuse/).
The `Dockerfile` used to create this image can be found inside of
[this](https://github.com/openSUSE/docker-containers) repository.

sle2docker automatically fetches the `opensuse/kiwi` image if not found on the
system.

# Usage

To build a template just use the following command:

```
sle2docker build TEMPLATE
```

A list of the available templates may be obtained by running:

```
sle2docker list
```

A templated rendered with user provided data can be printed by using the
following command:

```
sle2docker show TEMPLATE
```

## SUSE Customer Center integration

By default sle2docker downloads all the required packages from SUSE
Customer Center (SCC). Before the build starts sle2docker ask the user
his credentials. It is possible to start a build in a non interactive way by
using the following command:

```
sle2docker build -u USERNAME -p PASSWORD TEMPLATE_NAME
```


## Subscription Management Tool integration

It is possible to download all the required packages from a local 
Subscription Management Tool (SMT) instance:

```
sle2docker build -s SMT_SERVER_HOSTNAME/repo TEMPLATE
```

By default sle2docker assumes the contents of the SMT server are served over
HTTPS. To force the retrieval of the package over plain HTTP use the
following command:

```
sle2docker build -s SMT_SERVER_HOSTNAME/repo --disable-https TEMPLATE
```

Example: Say the FQDN of your SMT is mysmt.company.com and you want to build a SLE12 Docker image.
The corresponding call to sle2docker would look like this:

```
sle2docker build -s mysmt.company.com/repo --disable-https SLE12
```

By default sle2docker expects the SMT instance to not require any form of
authentication. However it is possible to specify the access credentials by
using the following command:

```
sle2docker build -s SMT_SERVER_HOSTNAME -u USERNAME -p PASSWORD TEMPLATE
```

## Additional repos for the base image

When building images with `sle2docker`, only the main and updates repositories
is used for installing needed packages. If you want to obtain extra packages
you need to tweak the templates.

Templates are .erb files located under `lib/templates`. If you installed `sle2docker`
via `zypper`, the templates are located under
`/usr/lib64/ruby/gems/2.1.0/gems/sle2docker-0.2.4/lib/templates` (paths may differ).
You may then add your own `<repository>` section:

```
  <repository type="rpm-md" alias="YOUR_ALIAS" <%= 'imageinclude="true"' if include_build_repos %>>
    <source path="PATH_TO_YOUR_REPO"/>
  </repository>
```

### Preservation of repository information

If you want to preserve the repository information in the final image, you need to supply the `--include-build-repos` parameter to the `build` command.

# License

sle2docker is released under the MIT license.
