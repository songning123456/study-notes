#!/bin/sh

# linux ��װgit maven
cd /home/songning/Documents/cykb
git clone git@github.com:songning123456/cykb-server.git
cd cykb-server/
mvn clean install -DskipTests