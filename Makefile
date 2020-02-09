export DOCKER_INFLUXDB_TAG=1.7-alpine
export DOCKER_CHRONOGRAF_TAG=1.7-alpine
export MY_NETWORK=my-network

influxdb: shared-network init
	docker run \
    --rm \
    --interactive \
    --tty \
    --name influxdb \
    --publish 8086:8086 \
    --net ${MY_NETWORK} \
    --mount type=bind,source=${PWD}/tmp/influxdb-volume,target=/var/lib/influxdb \
    influxdb:${DOCKER_INFLUXDB_TAG}

chronograf: shared-network init
	docker run \
    --rm \
    --interactive \
    --tty \
    --name chronograf \
    --publish 8888:8888 \
    --net ${MY_NETWORK} \
    --mount type=bind,source=${PWD}/tmp/influxdb-volume,target=/var/lib/influxdb \
    chronograf:${DOCKER_CHRONOGRAF_TAG}

shared-network:
	docker network ls | grep ${MY_NETWORK} || docker network create ${MY_NETWORK}

init:
	mkdir -p ${PWD}/tmp/influxdb-volume
	mkdir -p ${PWD}/tmp/chronograf-volume

clean:
	docker container prune
	docker network prune
	rm -rf ./tmp
