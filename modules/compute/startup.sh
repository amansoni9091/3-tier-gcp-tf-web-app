#!/bin/bash
set -e

# Update package repository and install Nginx
apt-get update -y
apt-get install -y nginx

# Create /health endpoint file for GCP Load Balancer health check (returns HTTP 200 OK)
mkdir -p /var/www/html
echo "OK" > /var/www/html/health

# Ensure Nginx is started and enabled on boot
systemctl enable nginx
systemctl restart nginx
