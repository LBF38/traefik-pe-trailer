#!/bin/bash

GITHUB_USER=LBF38

kubectl config use-context k3d-eu
flux bootstrap github \
    --owner=$GITHUB_USER \
    --repository=traefik-pe-trailer \
    --branch=main \
    --path=./clusters/eu \
    --personal

kubectl config use-context k3d-us
flux bootstrap github \
    --owner=$GITHUB_USER \
    --repository=traefik-pe-trailer \
    --branch=main \
    --path=./clusters/us \
    --personal

echo "Flux bootstrapped !"
