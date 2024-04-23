FROM postgres:16.2

# Copy SQL scripts to initialize the database
COPY init.sql /docker-entrypoint-initdb.d/