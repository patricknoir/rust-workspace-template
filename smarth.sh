#!/bin/bash

function add_project() {
  echo "Creating project $1"
  cargo ws create --bin --edition 2021 --name "$1" "$1"
  rm -rf "$1"
  cargo generate --git http://github.com/patricknoir/rust-bin-module-template --name "$1"
  cp $1/templates/k8s/* k8s/helm/templates
}

function publish_image() {
  echo "Creating image $1"
  docker buildx build --push --platform linux/arm64 -t "patricknoir/{{project-name}}-$1:$2" -f "$1/Dockerfile" .
}

while getopts "a:p:v:" opt; do
  case $opt in
    a)
      echo "Add Project: $OPTARG" >&2
      add_project $OPTARG
      ;;
    p)
      image=$OPTARG
      ;;
    v)
      version=$OPTARG
      ;;
  esac
done

if [ -n "$image" ]; then
  echo "Publishing image $image"
  publish_image "$image" "$version"
fi


