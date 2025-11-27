# VRMS Platform - Docker Compose Setup

This Docker Compose configuration runs all VRMS services locally on different ports, each with its own database source.

## Architecture Overview

### Services & Ports

| Service | Port | Database | Description |
|---------|------|----------|-------------|
| **User Service** | 8080 | MySQL (3306) | User management, authentication |
| **NGO Postings Service** | 8082 | PostgreSQL (5432) | NGO opportunity management |
| **Matching Service** | 8081 | None (Stateless) | Volunteer-opportunity matching |
| **Analytics Service** | 8000 | MySQL (shared) | Reporting and analytics |
| **Frontend** | 5174 | None | React-based web interface |

### Database Configuration

- **MySQL**: Used by User Service and Analytics Service
  - Port: 3306
  - Database: `userdb`
  - Credentials: root/root

- **PostgreSQL**: Used by NGO Postings Service
  - Port: 5432  
  - Database: `ngo_posting_db`
  - Credentials: postgres/postgres

## Quick Start

### Prerequisites

- Docker and Docker Compose installed
- Java 17+ (for building services)
- Maven 3.6+ (for building Java services)
- Node.js 18+ (for building frontend)

### 1. Automated Setup (Recommended)

```bash
# Run the setup script
./start-services.sh
```

This script will:
1. Build all Java services with Maven
2. Start databases first
3. Launch all services in the correct order
4. Display service URLs and documentation links

### 2. Manual Setup

```bash
# Build Java services
cd User-Service && mvn clean package -DskipTests && cd ..
cd NGO-Postings-Service && mvn clean package -DskipTests && cd ..
cd Matching-Service/matching && mvn clean package -DskipTests && cd ../..

# Start services
docker-compose up -d

# Check status
docker-compose ps
```

### 3. Stop Services

```bash
# Stop all services
./stop-services.sh

# Or manually
docker-compose down

# Stop and remove volumes (reset databases)
docker-compose down -v
```

## Service URLs

Once running, access services at:

- **Frontend**: http://localhost:5174
- **User Service API**: http://localhost:8080
- **NGO Postings API**: http://localhost:8082
- **Matching Service API**: http://localhost:8081
- **Analytics Service API**: http://localhost:8000

## API Documentation

- **User Service**: http://localhost:8080/swagger-ui.html
- **NGO Postings**: http://localhost:8082/swagger-ui.html  
- **Matching Service**: http://localhost:8081/swagger-ui.html
- **Analytics Service**: http://localhost:8000/docs

## Environment Variables

The Docker Compose file configures all necessary environment variables:

### User Service
```bash
SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/userdb
SPRING_DATASOURCE_USERNAME=root
SPRING_DATASOURCE_PASSWORD=root
JWT_SECRET=dGhpc19pc19hX3Zlcnlfc2VjdXJlX2RlZmF1bHRfa2V5X2Zvcl9kZXZlbG9wbWVudF91c2Vfb25seQ==
```

### NGO Postings Service  
```bash
SPRING_DATASOURCE_URL=jdbc:postgresql://postgres:5432/ngo_posting_db
SPRING_DATASOURCE_USERNAME=postgres
SPRING_DATASOURCE_PASSWORD=postgres
JWT_SECRET=dGhpc19pc19hX3Zlcnlfc2VjdXJlX2RlZmF1bHRfa2V5X2Zvcl9kZXZlbG9wbWVudF91c2Vfb25seQ==
```

### Matching Service
```bash
POSTING_SERVICE_URL=http://ngo-posting-service:8082/api/v1/postings
VOLUNTEER_SERVICE_URL=http://user-service:8080/api/v1/users/volunteers
```

### Analytics Service
```bash
MYSQL_HOST=mysql
MYSQL_DB=userdb
MYSQL_USER=root
MYSQL_PASSWORD=root
```

## Troubleshooting

### Check Service Status
```bash
docker-compose ps
```

### View Service Logs
```bash
# All services
docker-compose logs

# Specific service
docker-compose logs user-service
docker-compose logs ngo-posting-service
docker-compose logs matching-service
docker-compose logs analytics-service
docker-compose logs frontend
```

### Database Connection Issues
```bash
# Check database health
docker-compose exec mysql mysqladmin ping -uroot -proot
docker-compose exec postgres pg_isready -U postgres
```

### Rebuild Services
```bash
# Rebuild specific service
docker-compose build user-service

# Rebuild all services
docker-compose build --no-cache
```

### Reset Everything
```bash
# Stop and remove everything
docker-compose down -v --rmi all

# Restart fresh
./start-services.sh
```

## Development Notes

### Service Dependencies

The services start in this order:
1. **Databases** (MySQL, PostgreSQL)
2. **Core Services** (User Service, NGO Postings Service)  
3. **Dependent Services** (Matching Service)
4. **Analytics & Frontend** (Analytics Service, Frontend)

### Health Checks

All services include health checks:
- **Java Services**: `/actuator/health` endpoint
- **Python Service**: `/health` endpoint
- **Databases**: Native connection checks

### Networking

All services communicate through the `vrms-network` Docker network, enabling:
- Service-to-service communication using container names
- Isolated network environment
- Port exposure only where needed

### Volumes

Persistent data storage:
- `mysql_data`: MySQL database files
- `postgres_data`: PostgreSQL database files

## Configuration Files Created

This setup creates several configuration files:

- `docker-compose.yml` - Main orchestration file
- `start-services.sh` - Automated startup script  
- `stop-services.sh` - Cleanup script
- Service-specific Dockerfiles where missing
- `nginx.conf` for frontend reverse proxy

## Next Steps

1. **Test the Setup**: Run `./start-services.sh` and verify all services start
2. **Database Migration**: Run any necessary database migrations
3. **Sample Data**: Load test data if needed
4. **Integration Testing**: Test service-to-service communication
5. **Production**: Adapt configuration for production deployment