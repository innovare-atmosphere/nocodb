version: '3.3'

services:
  root_db:
    image: postgres
    restart: always
    volumes:
      - db_data:/var/lib/postgresql/data
    environment:
      POSTGRES_PASSWORD: ${database_password}
      POSTGRES_USER: postgres
      POSTGRES_DB: root_db
    healthcheck:
      test: pg_isready -U "$$POSTGRES_USER" -d "$$POSTGRES_DB"
      interval: 10s
      timeout: 2s
      retries: 10
  nocodb:
    depends_on:
      root_db:
        condition: service_healthy
    image: nocodb/nocodb:latest
    ports:
      - "8080:8080"
      - "8081:8081"
      - "8082:8082"
      - "8083:8083"
    restart: always
    volumes:
      - ./data:/usr/app/data/
    environment:
      NC_DB: "pg://root_db:5432?u=postgres&p=${database_password}&d=root_db"
volumes:
  db_data: {}