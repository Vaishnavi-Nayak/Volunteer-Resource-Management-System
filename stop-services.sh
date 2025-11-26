#!/bin/bash

# VRMS Docker Cleanup Script
# This script stops all services and cleans up resources

set -e

echo "🛑 Stopping VRMS Platform..."

# Stop all services
docker-compose down

# Optional: Remove volumes (uncomment if you want to reset databases)
# echo "🗑️  Removing volumes..."
# docker-compose down -v

# Optional: Remove all images (uncomment if you want to rebuild everything)
# echo "🗑️  Removing images..."
# docker-compose down --rmi all

echo "✅ VRMS Platform stopped."
echo ""
echo "💡 To restart: ./start-services.sh"
echo "🗑️  To reset databases: docker-compose down -v"