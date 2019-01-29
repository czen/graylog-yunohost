#!/bin/bash

# example :
#
#[ "$architecture" == "amd64" ] && image=portainer/portainer:1.14.0
#[ "$architecture" == "i386" ]  && image=portainer/portainer:linux-386-1.14.0
#[ "$architecture" == "armhf" ] && image=portainer/portainer:linux-arm-1.14.0
#[ -z $image ] && ynh_die "Sorry, your $architecture architecture is not supported ..."
#
#options="-p $port:9000 -v $data_path/data:/data"
#
#docker run -d --name=$app --restart always $options $image 1>&2
#echo $?

options="-p $port:9000 -p 12201:12201 -p 514:514 -v $data_path/data:/data"

iptables -t filter -N DOCKER

docker run --name mongo -d --restart always mongo:3 1>&2
docker run --name elasticsearch \
    -e "http.host=0.0.0.0" -e "xpack.security.enabled=false" \
    -d --restart always docker.elastic.co/elasticsearch/elasticsearch-oss:6.5.4 1>&2
docker run --link mongo --link elasticsearch \
    --name=$app --restart always \
    $options \
    -e GRAYLOG_WEB_ENDPOINT_URI="http://127.0.0.1:9000/api" \
    -d graylog/graylog:3.0 1>&2

CR=$?
echo $CR