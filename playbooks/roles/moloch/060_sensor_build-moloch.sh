REPO=moloch
TAG=bluefin

IMAGE=${REPO}:${TAG}
DOCKERFILE_PATH=${INSTALL_DIR}/dev/${REPO}/

head_msg "Building ${IMAGE} Docker Image"

if [[ ! "$(docker images -q ${IMAGE} 2> /dev/null)" ]]; then
  docker build -t ${IMAGE} ${DOCKERFILE_PATH}
else
  warn_msg "${IMAGE}: Already exists. Will not overwrite. Maually remove for update"
fi

