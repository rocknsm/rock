#!/bin/sh
#
#Info
#########################
#	file: import_harbor_images.sh
# 	name: Import Harbor Images
#
#
# Description
######################### 
# Imports any Docker images that are not already in the Harbor repo into the repo.
#
#
# Notes
########################
#
# TODO: Right now Harbor uses the /data directory to store everything. It really should be the $INSTALL_DIR/var folder or
# something. There are already some people asking about it: https://github.com/vmware/harbor/issues/2023, but currently
# there doesn't seem to be a public solution.
#
# Functions
#########################
# Main function to import the images

main() {
# Check to see if any images have not been installed into Harbor
if [ "$(docker images | grep -v ${HOSTNAME} 2> /dev/null)" ]; then 
  x=1
  HOSTNAME="$(hostname)"

  # TODO: Should definitely check they are up instead of waiting for 20 seconds.
  sleep 20
  # TODO: need to delete out the images not in use by docker and the old images
  if [ "$(ping -c 1 ${HOSTNAME})" ]; then
    # Log in to harbor
    # TODO: When time permits, we should add a function to perform hostname verification to make sure the host is in format XXXX.YYYY
    docker login --username="admin" --password="password" "${HOSTNAME}"

    # TODO: Delete out the long name images

    # Here I am grabbing each image that doesn't have a tag of the repo name and then getting the third column which is the image ID
    for image in $(docker images | grep -v ${HOSTNAME} | awk '{print $3}' | grep -v IMAGE); do

      # Get the name of the image that is associated with the respective image
      # number from the above for loop
      name=$(docker images | grep -v ${HOSTNAME} | awk '{print $1}' | grep -v REPOSITORY | sed -n "${x}p")

      # Bash speak for increment x by 1
      let "x++"

      # Retag all the images for the registry. Format hostname/project_name/name:version
      docker tag "${image}" "${HOSTNAME}/library/$name:latest"

      # Push the image to Harbor
      docker push "${HOSTNAME}/library/$name:latest"
    done
  fi
fi
}

#Script Execution:
########################
main


