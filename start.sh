#!/bin/bash
service docker restart

docker-compose up -d

service docker status
