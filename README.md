# stefanfoulis/docker-python


Opinionated base images for python projects with some useful tools pre-installed.


## Locally build an image

To locally build an image, run the following command::

   ./build.py --repo stefanfoulis/python --tag 0.00-py3.6-alpine3.7 build

Check `./build.py --help` for additional information.


## Release process

Tag commits with the desired Docker image tag, in the form::

   git tag <version>-<flavour>

Then push the tags to GitHub to trigger an automatic build on Docker Cloud::

   git push --tags


## Configuration on docker hub / docker cloud

Go to cloud.docker.com and create a new repository. Connect it to the github 
repo.
Now configure a *Build Rules* like this:

Source Type: Tag
Source: ``/^.+$/``
Docker Tag: ``{sourceref}``
Dockerfile location: ``Dockerfile``
Build Context: ``/``
Autobuild: ``on``
Build Caching: ``off``

You could add a second entry with the only difference being the Docker Tag set to
``{sourceref}-dev``. Then the image will be built with the build-arg
``TARGET=dev``. Otherwise it will be ``TARGET=prod``.

Now create a tag in git and push it to github whenever you want a docker image
built.
The tag should look like this: ``3.7-stretch-vX.xx``.
The first part (``3.7-stretch``) will be the directory in the ``python`` folder
that is built. The docker tag will be the same as the git tag.
