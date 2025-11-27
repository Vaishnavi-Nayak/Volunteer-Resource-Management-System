#!/bin/bash

# VRMS Docker Setup Script
# This script builds and starts all services in the correct order

set -e

echo " Starting VRMS Platform Setup..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo " Docker is not running. Please start Docker and try again."
    exit 1
fi

echo " Building Java services..."

# Build User Service
echo "Building User Service..."
cd User-Service
mvn clean package -DskipTests
cd ..

# Build NGO Postings Service
echo "Building NGO Postings Service..."
cd NGO-Postings-Service
mvn clean package -DskipTests
cd ..

# Build Matching Service
echo "Building Matching Service..."
cd Matching-Service/matching
mvn clean package -DskipTests
cd ../..

echo "🐳 Starting Docker Compose..."

# Start databases first
echo "Starting databases..."
docker compose up -d mysql postgres

# Wait for databases to be ready
echo "Waiting for databases to initialize..."
sleep 30

# Start all services
echo "Starting all services..."
docker compose up -d

echo " VRMS Platform is starting up..."
echo ""
echo " Service URLs:"
echo " User Service:        http://localhost:8080"
echo " NGO Posting Service: http://localhost:8082"
echo " Matching Service:    http://localhost:8081"
echo " Analytics Service:   http://localhost:8000"
echo " Frontend:           http://localhost:5174"
echo ""
echo " API Documentation:"
echo "User Service Swagger:    http://localhost:8080/swagger-ui.html"
echo "NGO Service Swagger:     http://localhost:8082/swagger-ui.html"
echo "Matching Service Swagger: http://localhost:8081/swagger-ui.html"
echo "Analytics Service Docs:  http://localhost:8000/docs"
echo ""
echo " Services may take a few minutes to fully start up."
echo " Check service status with: docker-compose ps"
echo " View logs with: docker-compose logs [service-name]"