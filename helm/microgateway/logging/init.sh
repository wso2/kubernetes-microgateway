#!/bin/bash

touch /home/ballerina/logs/microgw.log
/ballerina/runtime/bin/ballerina run --config /home/ballerina/conf/micro-gw.conf $PROJECT.balx 2>&1 | tee -a /home/ballerina/logs/microgw.log
