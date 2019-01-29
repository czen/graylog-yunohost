#!/bin/bash

# example :
#

docker rm -f mongo 1>&2
docker rm -f elasticsearch 1>&2
docker rm -f $app 1>&2
echo $?
