#!/bin/bash

# ------------- variables --------------------
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
fi

# ------------- variables --------------------

if [[ $platform == 'linux' ]]; then

  service docker restart

  docker-compose up -d

  service docker status

else

  docker-compose up -d

fi
