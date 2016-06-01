#! /bin/bash

#
# Copyright (c) 2013-2016 Jens Deters http://www.jensd.de
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may not use this file except in compliance with the
# License. You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS"
# BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language
# governing permissions and limitations under the License.
#


BASE_NAME_DEFAULT="jerady"
DOCKER_RUN_ARGS_DEFAULT="-ti"
VERSION=1.0

function print_dockerw_header {
cat <<EOF
     _            _
    | |          | |
  __| | ___   ___| | _____ _ ____      __
 / _' |/ _ \ / __| |/ / _ \ '__\ \ /\ / /
| (_| | (_) | (__|   <  __/ |   \ V  V /
 \__,_|\___/ \___|_|\_\___|_|    \_/\_/

EOF
}

function print_title {
	printf '%s\n\e[1m %s \e[m\n%s\n' "${DIVIDER}" "${1}" "${DIVIDER}"
}

function print_done {
	printf '\e[1;32mDone.\e[m\n%s\n' "${DIVIDER}"
}

function print_message {
	printf "%s: \e[1m%s\e[m\n" "${1}" "${2}"
}

function print_green {
	printf '\e[1;32m%s\e[m\n' "${1}"
}

function print_red {
	printf '\e[1;31m%s\e[m\n' "${1}"
}

function print_bold {
	printf '\e[1m%s\e[m\n' "${1}"
}

function print_env {
  echo
  print_bold "$(basename $0) environment:"
  echo "CONTAINER_NAME  = ${CONTAINER_NAME}"
  echo "BASE_NAME       = ${BASE_NAME}"
  echo "IMAGE_NAME      = ${IMAGE_NAME}"
  echo "DOCKER_RUN_ARGS = ${DOCKER_RUN_ARGS}"
  echo "DOCKER_RUN      = ${DOCKER_RUN}"
  echo
}

function help {
  print_dockerw_header
  printf '\e[1m%s\e[m%s\n' "$(basename ${0})" ", a simple docker command wrapper for the rest of us"
  printf '\e[1m%s\e[m\n' "version ${VERSION}, (c) copyright 2016 Jens Deters / www.jensd.de"
  echo

  print_message "Usage:" "${0} [ build | run | stop | clean | status | env | help ]"
cat <<EOF

  build  : builds the docker image
  run    : runs a docker container based on the image
  stop   : stops ALL running container based on the image and removes them
  clean  : stops and removes the image and containers
  status : status if the docker image
  env    : list current environment variables
  help   : display this help

EOF
}

function build {
  print_title "docker BUILD ${IMAGE_NAME}"
  build_image ${IMAGE_NAME}
}

function run {
  stop
  print_title "docker RUN ${IMAGE_NAME}"
  print_message "executing" "${DOCKER_RUN}"
  ${DOCKER_RUN}
}

function stop {
  print_title "docker STOP ${CONTAINER_NAME}"
  stop_remove_container ${CONTAINER_NAME}
  print_done
}

function clean {
  stop
  print_title "docker CLEAN ${IMAGE_NAME}"
  remove_image ${IMAGE_NAME}
  print_done
}

function status {
  print_title "docker image STATUS ${IMAGE_NAME}"
  docker images ${IMAGE_NAME}
}


function build_image {
  print_message "attempt to build image" "docker build -t ${1} ."
  time docker build -t ${1} .
  if [ $? -eq 0 ]
  then
    status
    print_green "Successfully build ${IMAGE_NAME}"
  else
    print_red "Failed to build ${IMAGE_NAME}"
    exit 1
  fi
}

function remove_image {
	IMAGE=$(docker images | grep "${1}" | awk '{ print $1}')
  print_message "attemt to remove image" ${1}
	if [ ! -z "${IMAGE}" ]
	then
	 time docker rmi --force ${IMAGE}
	else
		print_message "no such image" ${1}
	fi
}

function stop_remove_container {
  CID=$(docker ps -a | grep "${1}" | awk '{ print $1}')
  print_message "attempt to stop running containers" ${1}
  if [ ! -z "${CID}" ]
  then
    echo -e "Stopping and removing containers with CID:\n${CID}"
    docker stop ${CID}
    docker rm ${CID}
  else
    print_message "no running container found" ${1}
  fi
}

function check_env_variables {
  if [[ -z ${CONTAINER_NAME} ]]
  then
    CONTAINER_NAME="$(basename `pwd`)"
  fi

  if [[ -z ${BASE_NAME} ]]
  then
    BASE_NAME=${BASE_NAME_DEFAULT}
  fi

  if [[ -z ${IMAGE_NAME} ]]
  then
    IMAGE_NAME="${BASE_NAME}/${CONTAINER_NAME}"
  fi
  if [[ -z ${DOCKER_RUN_ARGS} ]]
  then
    DOCKER_RUN_ARGS=${DOCKER_RUN_ARGS_DEFAULT}
  fi

  if [[ -z ${DOCKER_RUN} ]]
  then
    DOCKER_RUN="docker run ${DOCKER_RUN_ARGS} --name ${CONTAINER_NAME} ${IMAGE_NAME}"
  fi
}

#
# MAIN
#

check_env_variables

case "${1}" in
  b|build)  build ;;
  r|run)    run ;;
  c|clean)  clean ;;
  s|stop)   stop ;;
  status)   status ;;
  e|env)    print_env ;;
  h|help)   help ;;
  *)        help ;;
esac
