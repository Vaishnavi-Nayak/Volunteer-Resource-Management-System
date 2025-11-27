#!/bin/bash

# VRMS Health Check Script
# Verifies all services are running and responding

echo "🔍 VRMS Platform Health Check"
echo "=============================="

services=(
    "User Service:http://localhost:8080/actuator/health"
    "NGO Postings:http://localhost:8082/actuator/health"  
    "Matching Service:http://localhost:8081/actuator/health"
    "Analytics Service:http://localhost:8000/health"
    "Frontend:http://localhost:5174"
)

all_healthy=true

for service in "${services[@]}"; do
    name=$(echo $service | cut -d: -f1)
    url=$(echo $service | cut -d: -f2-)
    
    echo -n "Checking $name... "
    
    if curl -s -f "$url" > /dev/null 2>&1; then
        echo "✅ Healthy"
    else
        echo "❌ Not responding"
        all_healthy=false
    fi
done

echo ""
echo "📊 Docker Container Status:"
docker-compose ps

echo ""
if $all_healthy; then
    echo "✅ All services are healthy!"
else
    echo "❌ Some services are not responding. Check logs with:"
    echo "   docker-compose logs [service-name]"
fi