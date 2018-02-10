#!/usr/bin/env bash

set -e

[ "$(which less)" ] && SPEC='less' || SPEC='more'

COMPOSE_FILE="docker-compose.yaml"
compose () {
	touch web.env db.env my_config.txt my_secret.txt
	docker-compose config > ${COMPOSE_FILE%.*}.txt
	$SPEC ${COMPOSE_FILE%.*}.txt
}

case "$1" in
	yml|yaml)
		$SPEC $COMPOSE_FILE
		;;
	*)
		[ ${#@} -eq 0 ] && ( compose; rm -f web.env db.env my_*.txt ${COMPOSE_FILE%.*}.txt )  || echo -e "Usage: bash $(basename "$0")"
		;;
esac
