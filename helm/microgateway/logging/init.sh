#!/bin/bash

touch /home/ballerina/microgw.log
/ballerina/runtime/bin/ballerina run --config /home/ballerina/conf/micro-gw.conf $PROJECT.balx | tee -a /home/ballerina/microgw.log