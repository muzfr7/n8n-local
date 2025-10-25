#!/bin/bash
set -e

log() {
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $1"
}

log "Starting PostgreSQL database initialization..."

if [ -n "${POSTGRES_NON_ROOT_USER:-}" ] && [ -n "${POSTGRES_NON_ROOT_PASSWORD:-}" ]; then
    log "Creating non-root user: ${POSTGRES_NON_ROOT_USER}"
    
    psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
        -- Create user with appropriate privileges
        CREATE USER ${POSTGRES_NON_ROOT_USER} WITH PASSWORD '${POSTGRES_NON_ROOT_PASSWORD}';
        
        -- Grant database-level privileges
        GRANT ALL PRIVILEGES ON DATABASE ${POSTGRES_DB} TO ${POSTGRES_NON_ROOT_USER};
        GRANT CREATE ON SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
        
        -- Grant table privileges (for existing and future tables)
        GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
        ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON TABLES TO ${POSTGRES_NON_ROOT_USER};
        
        -- Grant sequence privileges
        GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO ${POSTGRES_NON_ROOT_USER};
        ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL PRIVILEGES ON SEQUENCES TO ${POSTGRES_NON_ROOT_USER};
        
        -- Create useful extensions for n8n
        CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
        CREATE EXTENSION IF NOT EXISTS "pgcrypto";
	EOSQL
    
    log "Successfully created user ${POSTGRES_NON_ROOT_USER} with full privileges"
else
    log "WARNING: No environment variables provided for non-root user creation!"
    log "Please ensure POSTGRES_NON_ROOT_USER and POSTGRES_NON_ROOT_PASSWORD are set"
fi

log "PostgreSQL initialization complete"