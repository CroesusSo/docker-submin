#!/bin/sh

VERSION=`cat VERSION`

docker build \
	-t croesus/submin:${VERSION} \
	-t croesus/submin \
	-t croesus/submin:latest \
	.
