# n8n Local

Simple n8n automation platform with PostgreSQL database for local environment.

## 🚀 Quick Start

```bash
# Copy environment file and update passwords
cp .env.example .env
# Edit .env file with your preferred passwords

# Make init script executable (first time only)
chmod +x init-data.sh

# Start services
docker-compose up -d

# Access n8n
open http://localhost:5678
```

## 📁 Project Structure

```
├── .env.example     # Environment template file
├── compose.yaml     # Docker services configuration
├── init-data.sh     # PostgreSQL initialization script
├── README.md        # Project documentation
└── local-files/     # n8n file storage (created automatically)
```

## 🔧 Services

- **n8n**: http://localhost:5678 - Automation platform
- **PostgreSQL**: localhost:5432 - Database

## 💾 Database Access

```bash
# Connect to PostgreSQL
docker-compose exec postgres psql -U n8nuser -d n8n

# View workflows
SELECT name, active FROM workflow_entity;
```

## 📋 Common Commands

```bash
# View logs
docker-compose logs -f n8n
docker-compose logs -f postgres

# Stop services
docker-compose down

# Reset everything (deletes data)
docker-compose down -v
```

## ⚙️ Configuration

Edit `.env` file to change:
- Database credentials
- Timezone settings
- Domain configuration

## 🔄 Updates

```bash
docker-compose pull
docker-compose up -d
```
