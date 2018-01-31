#!/bin/bash

# The MIT License (MIT)
#
# Copyright (c) 2018 Redis Labs
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#
# Script Name: settings.sh
# Author: Cihan Biyikoglu - github:(cihanb)

#open source settings
oss_db_port=6379
oss_host_name="localhost"

test_oss_db(){
    echo "test_oss_db()"

    #launch the container
    echo "docker run -d --name redis-python redislabs/redis-py"
    docker run -d --name redis-python redislabs/redis-py

    docker exec -it redis-python "python" /usr/src/app/Redis-Python-Sample.py $oss_host_name $oss_db_port
}


#Enterprise settings
ent_db_port=12000
ent_host_name=172.17.0.3

test_enterprise_db(){
    echo "test_enterprise_db()"

    #launch the redis-py container
    echo "docker run -d --name redis-python redislabs/redis-py"
    docker run -d --name redis-python redislabs/redis-py

    #launch the enterprise container
    echo "docker run -d --cap-add sys_resource --name rp -p 9443:9443 -p 12000:12000 redislabs/redis"
    docker run -d --cap-add sys_resource --name rp -p 9443:9443 -p 12000:12000 redislabs/redis

    #provision cluster
    sleep 60
    docker exec -d --privileged rp "/opt/redislabs/bin/rladmin" cluster create name cluster.local username cihan@redislabs.com password redislabs123

    #provision db
    sleep  60
    curl -k -u "cihan@redislabs.com:redislabs123" --request POST --url "https://localhost:9443/v1/bdbs" --header 'content-type: application/json' --data '{"name":"db1","type":"redis","memory_size":102400,"port":12000}'

    #get the container ip
    cmd="docker exec -it rp ifconfig | grep 172. | cut -d\":\" -f 2 | cut -d\" \" -f 1"
    ent_host_name=$(eval $cmd)

    docker exec -it redis-python "python" /usr/src/app/Redis-Python-Sample.py $ent_host_name $ent_db_port
}



### START HERE ###
docker rm -f rp
docker rm -f redis-python
docker rmi -f redislabs/redis:latest
docker rmi -f redislabs/redis-py:latest

#call test open source database
test_oss_db
#call test redis enterprise database
test_enterprise_db


