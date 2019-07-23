#!/usr/bin/env bash
set -e

GREEN='\033[0;32m'
NC='\033[0m'

BUILDER_NAME=ctf-box:build
CONTAINER_NAME=ctf-box
VOLUME_NAME=ctf-box-volume
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
  STOPPED_CONTAINERS=$(docker ps -q -a)
  if [ -z "$STOPPED_CONTAINERS" ]
  then
  	echo "No stopped containers"
  else
  	docker rm $(docker ps -q -a)
  fi
  docker rmi $BUILDER_NAME
  # Delete the ones that has <none> repository name
  if [[ "$(docker images -f 'dangling=true' -q 2> /dev/null)" != "" ]]; then
    docker rmi $(docker images -f 'dangling=true' -q)
  fi
fi

if [ -n "$BUILD_IMAGE" ]
then
  # Build
  echo -e "${GREEN}[Building]${NC} ${BUILDER_NAME}"
  docker build -t $BUILDER_NAME .
  # Create a container named builder for our built image
  # echo -e "${GREEN}[Create container]${NC} ${CONTAINER_NAME}"
  # docker create --rm --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v "$CURRENT_DIR/$VOLUME_NAME":"/dev/$VOLUME_NAME" --name $CONTAINER_NAME $BUILDER_NAME
fi

if [ -n "$RUN_IMAGE" ]
then
  echo -e "${GREEN}[Running]${NC} ${BUILDER_NAME}"
  # docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined -v "$CURRENT_DIR/$VOLUME_NAME":"/dev/$VOLUME_NAME" -it $BUILDER_NAME
  docker run --cap-add=SYS_PTRACE --security-opt seccomp=unconfined \
    -v "$CURRENT_DIR/$VOLUME_NAME":"/dev/$VOLUME_NAME" -it $BUILDER_NAME $BASH_BIN
fi
