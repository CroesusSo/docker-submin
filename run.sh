#!/bin/sh

docker-compose up

# VERSION=`cat VERSION`
# hostname="10.136.1.109"
# port="8010"
# 
# docker run -it \
#       --name submin \
#       -p "${port}:80" \
#       -e "SUBMIN_HOSTNAME=${hostname}" \
#       -e "SUBMIN_EXTERNAL_PORT=${port}" \
#       -v "./svn/repos:/var/lib/svn" \
#       -v "./svn/log:/var/log/apache2" \
#       -v "./svn/submin:/var/lib/submin" \
#        croesus/submin:${VERSION}

