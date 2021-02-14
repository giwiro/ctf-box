#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'

IMAGE_NAME=ctf-box
BUILDER_NAME="$IMAGE_NAME:build"
CONTAINER_NAME="$IMAGE_NAME"
VOLUME_NAME=volume-ctf-box
HOSTNAME=machinex
BASH_BIN=/bin/zsh

CURRENT_DIR=$(pwd)

for i in "$@"
do
    case $i in
	-d|--delete)
        DELETE_BUILD=true
        shift
        ;;
    -b|--build)
        BUILD_IMAGE=true
        shift
        ;;
    -r|--run)
        RUN_IMAGE=true
        shift
        ;;
    *)
        ;;
    esac
done


if [ -n "$DELETE_BUILD" ]
then
  # Clean up
  echo -e "${GREEN}[Cleaning up]${NC}"
  RUNNING_CONTAINER_ID=$(docker ps --filter "ancestor=$BUILDER_NAME" --filter "status=running" -aq)

  # Stop and kill all running ctf-box containers
  if [ ! -z "$RUNNING_CONTAINER_ID" ]
  then
    echo -e "Killing running container_id $RUNNING_CONTAINER_ID"
    docker kill "$RUNNING_CONTAINER_ID"
    sleep 2
  fi
  
  # Delete all stopped ctf-box containers
  CONTAINER_ID=$(docker ps --filter "ancestor=$BUILDER_NAME" -aq)
  if [ ! -z "$CONTAINER_ID" ]
  then
    docker rm "$CONTAINER_ID"
  fi

  # Delete ctf-box image
  IMAGE_ID=$(docker images "$IMAGE_NAME" -aq)
  if [ ! -z "$IMAGE_ID" ]
  then
    docker rmi "$IMAGE_ID"
  fi

  BUILDER_IMAGE_ID=$(docker images "$BUILDER_NAME" -aq)
  if [ ! -z "$BUILDER_IMAGE_ID" ]
  then
    docker rmi "$BUILDER_IMAGE_ID"
  fi

  # Delete the ones that has <none> repository name
  if [[ "$(docker images -f 'dangling=true' -q 2> /dev/null)" != "" ]]; then
    docker rmi $(docker images -f 'dangling=true' -q)
  fi
fi

if [ -n "$BUILD_IMAGE" ]
then
  # Build
  echo -e "${GREEN}[Building]${NC} ${BUILDER_NAME}"
  docker build --no-cache -t $BUILDER_NAME .
  # Create a container named builder for our built image
  # echo -e "${GREEN}[Create container]${NC} ${CONTAINER_NAME}"
  # docker create --rm --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v "$CURRENT_DIR/$VOLUME_NAME":"/dev/$VOLUME_NAME" --name $CONTAINER_NAME $BUILDER_NAME
fi

if [ -n "$RUN_IMAGE" ]
then
  RUNNING_CONTAINER_ID=$(docker ps --filter "ancestor=$BUILDER_NAME" --filter "status=running" -aq)
  if [ -z "$RUNNING_CONTAINER_ID" ]
  then
    echo -e "${GREEN}[Running detached]${NC} ${BUILDER_NAME}"
    # Why all these options? https://github.com/tonyOreglia/argument-counter/wiki/How-to-use-GDB-within-Docker-Container
    docker run --privileged --detach --hostname $HOSTNAME --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
      -v "$CURRENT_DIR/$VOLUME_NAME":"/dev/$VOLUME_NAME" $BUILDER_NAME # $BASH_BIN
    sleep 2
  fi
  RUNNING_CONTAINER_ID=$(docker ps --filter "ancestor=$BUILDER_NAME" --filter "status=running" -aq)
  echo -e "${GREEN}[Connect]${NC} ${RUNNING_CONTAINER_ID}"
  docker exec -it "$RUNNING_CONTAINER_ID" "$BASH_BIN"
fi
