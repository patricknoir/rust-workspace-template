#!/bin/bash

function add_project() {
  echo "Creating project $1"
  cargo ws create "$1"
  rm -rf "$1"
  cargo generate --git  http://github.com/patricknoir/rust-bin-module-template --name "$1"
  copy "$1/k8s/templates/* k8s/helm/templates"
}

function publish_image() {
  echo "Creating image $1"
  docker buildx build --push --platform linux/arm64 -t "patricknoir/{{project-name}}-$1:$2" -f "$1/Dockerfile" .
}

getopts "add:publish:" opt; do
  case $opt in
    add)
      echo "Add Project: $OPTARG" >&2
      add_project $OPTARG
      ;;
    publish)
      echo "Publish Image: $OPTARG" >&2
      publish_image $OPTARG
      ;;
  esac
done


