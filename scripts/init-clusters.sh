#!/bin/bash

k3d cluster create eu --k3s-arg "--disable=traefik@server:0" -p 80:80@loadbalancer -p 443:443@loadbalancer -p 8080:8080@loadbalancer --agents 2 --wait
k3d cluster create us --k3s-arg "--disable=traefik@server:0" -p 81:80@loadbalancer -p 444:443@loadbalancer -p 8081:8080@loadbalancer --agents 2 --wait

echo "clusters created !"

EU_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' k3d-eu-serverlb)
US_IP=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' k3d-us-serverlb)

echo "EU Cluster LoadBalancer IP: $EU_IP"
echo "US Cluster LoadBalancer IP: $US_IP"

echo "Updating /etc/hosts..."
sudo sed -i '/foobar-eu.cloud.local/d' /etc/hosts
sudo sed -i '/foobar.cloud.local/d' /etc/hosts
sudo sed -i '/foobar-us.cloud.local/d' /etc/hosts
echo "$EU_IP foobar-eu.cloud.local" | sudo tee -a /etc/hosts
echo "$EU_IP foobar.cloud.local" | sudo tee -a /etc/hosts
echo "$US_IP foobar-us.cloud.local" | sudo tee -a /etc/hosts

echo "DNS updated! You can now access the clusters:"
echo "EU Cluster: http://foobar-eu.cloud.local"
echo "US Cluster: http://foobar-us.cloud.local"
echo "Load balancing: https://foobar.cloud.local"
