#!/bin/bash

# ------------- variables --------------------
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
fi

# ------------- variables --------------------

if [[ $platform == 'linux' ]]; then

  docker-compose down

  service docker stop

else

  docker-compose down

fi
