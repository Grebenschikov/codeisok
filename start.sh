#!/bin/bash

CURRENT_DIR=`pwd`
DATABASE_DIR=$CURRENT_DIR/.setup/storage/database
GIT_HOME=$CURRENT_DIR/.setup/storage/git

docker run \
    --name gitphp \
    -p 80:80 \
    -p 443:443 \
    -p 3306:3306 \
    -p 22:22 \
    -v $CURRENT_DIR:/local/gitphp \
    -v $DATABASE_DIR:/var/lib/mysql \
    -v $GIT_HOME:/home/git/ \
    --rm \
    -it \
    gitphp