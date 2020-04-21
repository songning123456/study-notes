#!/bin/sh
docker logs cykb-es-theft_container > theft-log.txt
sz theft-log.txt
rm -rf theft-log.txt